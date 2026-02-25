#!/bin/bash

random_tunnel_port() {
    # macOS does not ship `shuf` by default.
    if command -v shuf >/dev/null 2>&1; then
        shuf -i 10000-65000 -n 1
        return
    fi

    echo $((10000 + RANDOM % 55001))
}

function connectSherlock() {
    local LOGIN_NODE="sherlock"
    local JOB_NAME="neurodesktop"
    local CTRL_SOCKET="${HOME}/.ssh/sherlock_ctrl_$(date +%s)_${RANDOM}"

    # Start master connection
    # -M: master mode, -f: background, -N: no command, -S: socket path
    ssh -M -f -N -S "$CTRL_SOCKET" "$LOGIN_NODE"
    if [ $? -ne 0 ]; then
        echo "Authentication failed."
        return 1
    fi
    # Close master connection and free up port 8888 on return
    trap 'ssh -S "'"$CTRL_SOCKET"'" -O exit "'"$LOGIN_NODE"'" 2>/dev/null; \
          if lsof -Pi :8888 -sTCP:LISTEN -t >/dev/null 2>&1; then \
              echo "Cleaning up port 8888..."; \
              lsof -Pi :8888 -sTCP:LISTEN -t | xargs kill -9 2>/dev/null; \
          fi' RETURN
    
    # --- 1. CHECK FOR EXISTING "NEURODESKTOP" JOBS ---
    # We add --name="neurodesktop" to squeue so we don't accidentally 
    # grab background compute jobs.
    local EXISTING_JOB=$(ssh -S "$CTRL_SOCKET" -q "$LOGIN_NODE" "squeue -u \$USER --name=$JOB_NAME -h -t R -o '%i %N' | head -n 1")
    
    if [ ! -z "$EXISTING_JOB" ]; then
        read -r JOB_ID NODE_NAME <<< "$EXISTING_JOB"
        echo "Found active $JOB_NAME session (Job $JOB_ID) on Node: $NODE_NAME"
        echo -n "Reuse this connection? [Y/n] "
        read -r reuse
        
        # Default to Yes
        if [[ ! "$reuse" =~ ^([nN][oO]|[nN])$ ]]; then
            echo "Reconnecting to $NODE_NAME..."
            echo "ℹ️  Using existing tunnel on port 8888 (maintained by your original terminal)."
            ssh -S "$CTRL_SOCKET" -t "$LOGIN_NODE" "ssh $NODE_NAME"
            return
        fi
    fi

    # --- 2. CONFIGURATION FOR NEW CONNECTION ---
    echo "================================================================================"
    echo " partition   || job runtime       | mem/core | per-node cores"
    echo " name        ||     maximum       |  maximum | (range)"
    echo "--------------------------------------------------------------------------------"
    echo " normal      || 2d or 7d (owner) |      8GB  | 20-64"
    echo " bigmem      ||               1d |     64GB  | 24-256"
    echo " dev         ||               2h |      8GB  | 20-32"
    echo "--------------------------------------------------------------------------------"
    echo "================================================================================"
    
    echo -n "Which partition do you want to submit to? [normal] "
    read -r PARTITION
    PARTITION=${PARTITION:-normal}

    echo -n "How much Memory needed? [8G] "
    read -r MEM
    MEM=${MEM:-8G}

    echo -n "How many CPUs needed? [1] "
    read -r CPUS
    CPUS=${CPUS:-1}

    echo -n "How much Time needed? [02:00:00] "
    read -r WALLTIME
    WALLTIME=${WALLTIME:-02:00:00}

    echo -n "How many GPUs needed? [none] "
    read -r GPU
    GPU=${GPU:-none}

    local MIDDLE_PORT
    MIDDLE_PORT=$(random_tunnel_port)
    if [[ ! "$MIDDLE_PORT" =~ ^[0-9]+$ ]]; then
        echo "Failed to select a valid tunnel port."
        return 1
    fi
    echo "Establishing tunnel via Login Node port: $MIDDLE_PORT"

    # --- 3. CHECK LOCAL PORT 8888 ---
    # Check if port 8888 is occupied and kill the process(es) if so
    if lsof -Pi :8888 -sTCP:LISTEN -t >/dev/null ; then
        echo "Port 8888 is already in use."
        local PIDS
        PIDS=$(lsof -Pi :8888 -sTCP:LISTEN -t)
        echo "Killing process(es) $PIDS to free up port 8888..."
        echo "$PIDS" | xargs kill -9 2>/dev/null
    fi

    echo "Preparing setup script..."
    ssh -S "$CTRL_SOCKET" "$LOGIN_NODE" "cat > ~/.neurodesk_setup.sh && chmod +x ~/.neurodesk_setup.sh" <<'EOF'
#!/bin/bash
cd $SCRATCH
export PATH=$PATH:/sbin:/usr/sbin
if [ ! -f neurodesktop-overlay.img ]; then
    echo "Creating neurodesktop-overlay.img (2GB)..."
    if command -v apptainer >/dev/null 2>&1 && apptainer overlay create --help >/dev/null 2>&1; then
        apptainer overlay create --size 2048 neurodesktop-overlay.img
    else
        dd if=/dev/zero of=neurodesktop-overlay.img bs=1M count=2048
        overlay_seed_dir=$(mktemp -d)
        mkdir -p "${overlay_seed_dir}/upper" "${overlay_seed_dir}/work"
        if mkfs.ext3 -F -d "${overlay_seed_dir}" neurodesktop-overlay.img >/dev/null 2>&1; then
            :
        else
            echo "mkfs.ext3 on this host does not support -d; using root-owned overlay layout."
            mkfs.ext3 -F neurodesktop-overlay.img
            debugfs -w -R "mkdir upper" neurodesktop-overlay.img
            debugfs -w -R "mkdir work" neurodesktop-overlay.img
        fi
        rm -rf "${overlay_seed_dir}"
    fi
else
    echo "neurodesktop-overlay.img found."
    echo "If you run without --fakeroot and writes fail, recreate it with: rm -f \$SCRATCH/neurodesktop-overlay.img"
fi

if [ ! -d ~/neurodesktop-home ]; then
    echo "Creating ~/neurodesktop-home..."
    mkdir -p ~/neurodesktop-home
else
    echo "~/neurodesktop-home found."
fi

if [ ! -d ~/neurodesktop-home/workdir ]; then
    echo "Creating ~/neurodesktop-home/workdir..."
    mkdir -p ~/neurodesktop-home/workdir
else
    echo "~/neurodesktop-home/workdir found."
fi

SLURM_BINDS=()
HOST_SLURM_CONF="${SLURM_CONF:-/etc/slurm/slurm.conf}"
HOST_SLURM_CONF_DIR=/etc/slurm
if [ -n "${HOST_SLURM_CONF}" ]; then
    HOST_SLURM_CONF_DIR=$(dirname -- "${HOST_SLURM_CONF}")
fi
HOST_SLURM_CONF_REAL=$(readlink -f "${HOST_SLURM_CONF}" 2>/dev/null || echo "${HOST_SLURM_CONF}")
if [ -z "${HOST_SLURM_CONF_REAL}" ]; then
    HOST_SLURM_CONF_REAL="${HOST_SLURM_CONF}"
fi
HOST_SLURM_CONF_REAL_DIR="${HOST_SLURM_CONF_DIR}"
if [ -n "${HOST_SLURM_CONF_REAL}" ]; then
    HOST_SLURM_CONF_REAL_DIR=$(dirname -- "${HOST_SLURM_CONF_REAL}")
fi
CONTAINER_SLURM_CONF_DIR=/etc/slurm
CONTAINER_SLURM_CONF_PATH="${CONTAINER_SLURM_CONF_DIR}/${HOST_SLURM_CONF_REAL##*/}"
if [ -d "${HOST_SLURM_CONF_REAL_DIR}" ]; then
    SLURM_BINDS+=(--bind "${HOST_SLURM_CONF_REAL_DIR}:${CONTAINER_SLURM_CONF_DIR}")
elif [ -d "${HOST_SLURM_CONF_DIR}" ]; then
    SLURM_BINDS+=(--bind "${HOST_SLURM_CONF_DIR}:${CONTAINER_SLURM_CONF_DIR}")
fi

SLURM_PLUGIN_DIRS_RAW=""
if [ -r "${HOST_SLURM_CONF_REAL}" ]; then
    SLURM_PLUGIN_DIRS_RAW=$(awk -F= '/^[[:space:]]*PluginDir[[:space:]]*=/{print $2}' "${HOST_SLURM_CONF_REAL}" | tail -n 1 | tr -d '[:space:]')
fi
if [ -z "${SLURM_PLUGIN_DIRS_RAW}" ] && [ -n "${SLURM_PLUGIN_DIR:-}" ]; then
    SLURM_PLUGIN_DIRS_RAW="${SLURM_PLUGIN_DIR}"
fi
if [ -n "${SLURM_PLUGIN_DIRS_RAW}" ]; then
    OLD_IFS="${IFS}"
    IFS=':'
    read -r -a SLURM_PLUGIN_DIRS <<< "${SLURM_PLUGIN_DIRS_RAW}"
    IFS="${OLD_IFS}"
    for plugin_dir in "${SLURM_PLUGIN_DIRS[@]}"; do
        if [ -n "${plugin_dir}" ] && [ -d "${plugin_dir}" ]; then
            SLURM_BINDS+=(--bind "${plugin_dir}:${plugin_dir}")
        fi
    done
fi

SLURM_LD_LIBRARY_PATH=""
SLURM_HOST_BIN_REAL_STAGING="$SCRATCH/neurodesktop-slurm-bin-real"
SLURM_HOST_BIN_STAGING="$SCRATCH/neurodesktop-slurm-bin"
SLURM_HOST_LIB_STAGING="$SCRATCH/neurodesktop-slurm-libs"
SLURM_WRAPPER_LIB_PATH="/opt/slurm-host-libs"
SLURM_WRAPPER_BIN_PATH="/opt/slurm-host-bin"
unset APPTAINERENV_PREPEND_PATH
unset APPTAINERENV_PATH
if command -v ldd >/dev/null 2>&1; then
    mkdir -p "${SLURM_HOST_BIN_REAL_STAGING}"
    mkdir -p "${SLURM_HOST_BIN_STAGING}"
    mkdir -p "${SLURM_HOST_LIB_STAGING}"
    rm -f "${SLURM_HOST_BIN_REAL_STAGING}"/* 2>/dev/null || true
    rm -f "${SLURM_HOST_BIN_STAGING}"/* 2>/dev/null || true
    rm -f "${SLURM_HOST_LIB_STAGING}"/*.so* 2>/dev/null || true

    SLURM_HOST_CMDS=(sinfo squeue scontrol sacct srun sbatch scancel salloc sstat sprio)
    for slurm_cmd in "${SLURM_HOST_CMDS[@]}"; do
        cmd_path=$(type -P "${slurm_cmd}" 2>/dev/null || true)
        if [ -z "${cmd_path}" ]; then
            for candidate in /usr/bin /usr/local/bin /bin; do
                if [ -x "${candidate}/${slurm_cmd}" ]; then
                    cmd_path="${candidate}/${slurm_cmd}"
                    break
                fi
            done
        fi
        if [ -n "${cmd_path}" ] && [ -x "${cmd_path}" ]; then
            cp -Lf "${cmd_path}" "${SLURM_HOST_BIN_REAL_STAGING}/${slurm_cmd}" 2>/dev/null || true
            printf '%s\n' \
                '#!/bin/bash' \
                "export LD_LIBRARY_PATH=${SLURM_WRAPPER_LIB_PATH}\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}" \
                "exec /opt/slurm-host-bin-real/${slurm_cmd} \"\$@\"" \
                > "${SLURM_HOST_BIN_STAGING}/${slurm_cmd}"
            chmod +x "${SLURM_HOST_BIN_STAGING}/${slurm_cmd}" 2>/dev/null || true
            # Force replacement of container slurm client command paths so PATH changes cannot bypass wrappers.
            SLURM_BINDS+=(--bind "${SLURM_HOST_BIN_STAGING}/${slurm_cmd}:${cmd_path}")
            while read -r dep_path; do
                [ -z "${dep_path}" ] && continue
                dep_base=$(basename "${dep_path}")
                case "${dep_base}" in
                    libc.so.*|libm.so.*|libpthread.so.*|libdl.so.*|librt.so.*|ld-linux*.so.*)
                        continue
                        ;;
                esac
                cp -Lf "${dep_path}" "${SLURM_HOST_LIB_STAGING}/${dep_base}" 2>/dev/null || true
            done < <(ldd "${cmd_path}" 2>/dev/null | awk '$2 == "=>" && $3 ~ /^\// {print $3} $1 ~ /^\// {print $1}')
        fi
    done

    for plugin_dir in "${SLURM_PLUGIN_DIRS[@]}"; do
        [ -d "${plugin_dir}" ] || continue
        while read -r plugin_file; do
            [ -r "${plugin_file}" ] || continue
            while read -r dep_path; do
                [ -z "${dep_path}" ] && continue
                dep_base=$(basename "${dep_path}")
                case "${dep_base}" in
                    libc.so.*|libm.so.*|libpthread.so.*|libdl.so.*|librt.so.*|ld-linux*.so.*)
                        continue
                        ;;
                esac
                cp -Lf "${dep_path}" "${SLURM_HOST_LIB_STAGING}/${dep_base}" 2>/dev/null || true
            done < <(ldd "${plugin_file}" 2>/dev/null | awk '$2 == "=>" && $3 ~ /^\// {print $3} $1 ~ /^\// {print $1}')
        done < <(find "${plugin_dir}" -maxdepth 4 -type f -name '*.so*' 2>/dev/null)
    done

    if ls "${SLURM_HOST_BIN_REAL_STAGING}"/* >/dev/null 2>&1; then
        SLURM_BINDS+=(--bind "${SLURM_HOST_BIN_REAL_STAGING}:/opt/slurm-host-bin-real")
    fi
    if ls "${SLURM_HOST_BIN_STAGING}"/* >/dev/null 2>&1; then
        SLURM_BINDS+=(--bind "${SLURM_HOST_BIN_STAGING}:${SLURM_WRAPPER_BIN_PATH}")
        export APPTAINERENV_PREPEND_PATH="${SLURM_WRAPPER_BIN_PATH}"
        # Explicitly set PATH to keep wrapper precedence even if startup scripts reset PATH.
        export APPTAINERENV_PATH="${SLURM_WRAPPER_BIN_PATH}:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    fi
    if ls "${SLURM_HOST_LIB_STAGING}"/*.so* >/dev/null 2>&1; then
        SLURM_BINDS+=(--bind "${SLURM_HOST_LIB_STAGING}:${SLURM_WRAPPER_LIB_PATH}")
        SLURM_LD_LIBRARY_PATH="${SLURM_WRAPPER_LIB_PATH} (wrapper scoped)"
    fi
fi
if [ -e /run/slurm ]; then
    SLURM_BINDS+=(--bind /run/slurm:/run/slurm)
fi
if [ -e /run/slurmctld ]; then
    SLURM_BINDS+=(--bind /run/slurmctld:/run/slurmctld)
fi
if [ -e /run/slurmdbd ]; then
    SLURM_BINDS+=(--bind /run/slurmdbd:/run/slurmdbd)
fi

CLUSTER_NAME=""
if [ -r "${HOST_SLURM_CONF_REAL}" ]; then
    CLUSTER_NAME=$(awk -F= '/^[[:space:]]*ClusterName[[:space:]]*=/{print $2}' "${HOST_SLURM_CONF_REAL}" | tail -n 1 | tr -d '[:space:]')
fi
if [ -n "${CLUSTER_NAME}" ] && [ -e "/run/slurm-${CLUSTER_NAME}" ]; then
    SLURM_BINDS+=(--bind "/run/slurm-${CLUSTER_NAME}:/run/slurm-${CLUSTER_NAME}")
fi

SACK_SOCKET_CANDIDATE="${SLURM_SACK_SOCKET:-}"
if [ -z "${SACK_SOCKET_CANDIDATE}" ]; then
    if [ -n "${CLUSTER_NAME}" ] && [ -S "/run/slurm-${CLUSTER_NAME}/sack.socket" ]; then
        SACK_SOCKET_CANDIDATE="/run/slurm-${CLUSTER_NAME}/sack.socket"
    elif [ -S /run/slurm/sack.socket ]; then
        SACK_SOCKET_CANDIDATE=/run/slurm/sack.socket
    elif [ -S /run/slurmctld/sack.socket ]; then
        SACK_SOCKET_CANDIDATE=/run/slurmctld/sack.socket
    elif [ -S /run/slurmdbd/sack.socket ]; then
        SACK_SOCKET_CANDIDATE=/run/slurmdbd/sack.socket
    else
        SACK_SOCKET_CANDIDATE=$(find /run -maxdepth 4 -type s -name 'sack.socket' 2>/dev/null | head -n 1)
    fi
fi
if [ -n "${SACK_SOCKET_CANDIDATE}" ] && [ -S "${SACK_SOCKET_CANDIDATE}" ]; then
    SACK_SOCKET_DIR=$(dirname "${SACK_SOCKET_CANDIDATE}")
    if [ -d "${SACK_SOCKET_DIR}" ]; then
        SLURM_BINDS+=(--bind "${SACK_SOCKET_DIR}:${SACK_SOCKET_DIR}")
    fi
fi
if [ -e /run/munge ]; then
    SLURM_BINDS+=(--bind /run/munge:/run/munge)
fi
if [ -e /var/run/munge ]; then
    SLURM_BINDS+=(--bind /var/run/munge:/var/run/munge)
fi

MUNGE_SOCKET_CANDIDATE="${MUNGE_SOCKET:-}"
if [ -z "${MUNGE_SOCKET_CANDIDATE}" ]; then
    for sock in \
        /run/munge/munge.socket.2 \
        /var/run/munge/munge.socket.2 \
        /run/munge/munge.socket \
        /var/run/munge/munge.socket \
        /var/spool/slurmd/munge.socket.2 \
        /var/spool/slurm/munge.socket.2
    do
        if [ -S "${sock}" ]; then
            MUNGE_SOCKET_CANDIDATE="${sock}"
            break
        fi
    done
fi
if [ -n "${MUNGE_SOCKET_CANDIDATE}" ] && [ -S "${MUNGE_SOCKET_CANDIDATE}" ]; then
    MUNGE_SOCKET_DIR=$(dirname "${MUNGE_SOCKET_CANDIDATE}")
    if [ -d "${MUNGE_SOCKET_DIR}" ]; then
        SLURM_BINDS+=(--bind "${MUNGE_SOCKET_DIR}:${MUNGE_SOCKET_DIR}")
    fi
fi

export APPTAINERENV_NEURODESKTOP_SLURM_MODE=host
export APPTAINERENV_SLURM_CONF="${CONTAINER_SLURM_CONF_PATH}"
unset APPTAINERENV_LD_LIBRARY_PATH
if [ -n "${SACK_SOCKET_CANDIDATE}" ] && [ -S "${SACK_SOCKET_CANDIDATE}" ]; then
    export APPTAINERENV_SLURM_SACK_SOCKET="${SACK_SOCKET_CANDIDATE}"
else
    unset APPTAINERENV_SLURM_SACK_SOCKET
fi

if [ -n "${MUNGE_SOCKET_CANDIDATE}" ] && [ -S "${MUNGE_SOCKET_CANDIDATE}" ]; then
    export APPTAINERENV_MUNGE_SOCKET="${MUNGE_SOCKET_CANDIDATE}"
else
    unset APPTAINERENV_MUNGE_SOCKET
fi

echo "Host Slurm integration: mode=${APPTAINERENV_NEURODESKTOP_SLURM_MODE:-unset} conf=${APPTAINERENV_SLURM_CONF:-unset} (from ${HOST_SLURM_CONF}) sack=${APPTAINERENV_SLURM_SACK_SOCKET:-unset} munge=${APPTAINERENV_MUNGE_SOCKET:-unset}"
echo "Host Slurm plugin dirs: ${SLURM_PLUGIN_DIRS_RAW:-unset}"
echo "Host Slurm bin dir: ${APPTAINERENV_PREPEND_PATH:-unset}"
echo "Host Slurm PATH: ${APPTAINERENV_PATH:-unset}"
echo "Host Slurm loader dirs: ${SLURM_LD_LIBRARY_PATH:-unset}"
echo "Host Slurm wrapper count: $(ls "$SLURM_HOST_BIN_STAGING" 2>/dev/null | wc -l | tr -d ' ')"
if [ -e "${HOST_SLURM_CONF_REAL}" ]; then
    ls -l "${HOST_SLURM_CONF_REAL}"
else
    echo "WARNING: host slurm.conf not found at ${HOST_SLURM_CONF_REAL}"
fi

echo "Starting Neurodesktop container..."
apptainer run \
   --nv \
   --fakeroot \
   --overlay $SCRATCH/neurodesktop-overlay.img \
   --bind $GROUP_HOME/neurodesk/local/containers/:/neurodesktop-storage/containers \
   --bind $GROUP_HOME/neurodesk/local/containers/:/neurocommand/local/containers \
   "${SLURM_BINDS[@]}" \
   --no-home \
   --env CVMFS_DISABLE=true \
   --env NB_UID=$(id -u) \
   --env NB_GID=$(id -g) \
   --env NEURODESKTOP_VERSION=latest \
   $GROUP_HOME/neurodesk/neurodesktop_latest.sif \
   start-notebook.py --allow-root
EOF

    # --- 4. LAUNCH ALLOCATION ---
    local GPU_FLAG=""
    if [[ "$GPU" != "none" && ! -z "$GPU" ]]; then
        GPU_FLAG="--gres=gpu:$GPU"
    fi
    
    ssh -S "$CTRL_SOCKET" -t -L 8888:localhost:${MIDDLE_PORT} "$LOGIN_NODE" \
        "salloc --job-name=$JOB_NAME -p $PARTITION --nodes=1 --time=$WALLTIME --ntasks=1 --cpus-per-task=$CPUS --mem=$MEM $GPU_FLAG \
        bash -c 'echo \"Allocated: \${SLURM_NODELIST}\"; \
                 ssh -t -L ${MIDDLE_PORT}:localhost:8888 \${SLURM_NODELIST} \"SLURM_CONF=\${SLURM_CONF:-} SLURM_SACK_SOCKET=\${SLURM_SACK_SOCKET:-} MUNGE_SOCKET=\${MUNGE_SOCKET:-} ~/.neurodesk_setup.sh\"'"
}

# Check if the script is being executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    connectSherlock "$@"
fi
