#!/bin/bash

UPDATE_SOURCE_URL="https://raw.githubusercontent.com/neurodesk/neurodesk.github.io/refs/heads/main/content/en/Getting-Started/Installations/connectSherlock.sh"

download_update_candidate() {
    local target_file="$1"

    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$UPDATE_SOURCE_URL" -o "$target_file"
        return $?
    fi

    if command -v wget >/dev/null 2>&1; then
        wget -qO "$target_file" "$UPDATE_SOURCE_URL"
        return $?
    fi

    return 127
}

script_has_local_git_changes() {
    local script_path="$1"
    local script_dir=""
    local script_abs=""
    local repo_root=""
    local script_rel=""
    local git_status=""

    if ! command -v git >/dev/null 2>&1; then
        return 1
    fi

    script_dir="$(cd "$(dirname "$script_path")" 2>/dev/null && pwd -P)" || return 1
    script_abs="${script_dir}/$(basename "$script_path")"
    repo_root="$(git -C "$script_dir" rev-parse --show-toplevel 2>/dev/null)" || return 1

    case "$script_abs" in
        "$repo_root"/*)
            script_rel="${script_abs#"$repo_root"/}"
            ;;
        *)
            return 1
            ;;
    esac

    # Only guard tracked files to avoid false positives from unrelated paths.
    if ! git -C "$repo_root" ls-files --error-unmatch -- "$script_rel" >/dev/null 2>&1; then
        return 1
    fi

    git_status="$(git -C "$repo_root" status --porcelain -- "$script_rel" 2>/dev/null)" || return 1
    if [[ -n "$git_status" ]]; then
        return 0
    fi

    return 1
}

self_update_connect_sherlock() {
    local script_path="$1"
    shift
    local script_args=("$@")

    if [[ "${CONNECT_SHERLOCK_SKIP_UPDATE_REEXEC:-0}" == "1" ]]; then
        return 0
    fi

    if script_has_local_git_changes "$script_path"; then
        echo "Local git changes detected for $script_path; skipping auto-update."
        return 0
    fi

    local tmp_file
    tmp_file="$(mktemp "${TMPDIR:-/tmp}/connectSherlock.update.XXXXXX")" || return 0

    if ! download_update_candidate "$tmp_file"; then
        rm -f "$tmp_file"
        echo "Update check skipped (unable to download update candidate)."
        return 0
    fi

    if cmp -s "$script_path" "$tmp_file"; then
        rm -f "$tmp_file"
        return 0
    fi

    if ! head -n 1 "$tmp_file" | grep -q "^#!/bin/bash"; then
        rm -f "$tmp_file"
        echo "Update check skipped (downloaded script validation failed)."
        return 0
    fi

    if ! cp "$tmp_file" "$script_path"; then
        rm -f "$tmp_file"
        echo "Update check failed (could not overwrite $script_path)."
        return 0
    fi

    rm -f "$tmp_file"
    chmod +x "$script_path" 2>/dev/null || true
    echo "Updated connectSherlock.sh to latest version. Restarting with updated script..."
    CONNECT_SHERLOCK_SKIP_UPDATE_REEXEC=1 exec bash "$script_path" "${script_args[@]}"
    echo "Restart failed; continuing with current shell process."
}

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
    # Close master connection on return
    trap 'ssh -S "'"$CTRL_SOCKET"'" -O exit "'"$LOGIN_NODE"'" 2>/dev/null' RETURN
    
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
            echo "Info: existing tunnel is maintained by your original terminal."
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

    local MIDDLE_PORT=""
    local LOCAL_PORT=""
    local PORT_SELECT_ATTEMPTS=25
    local PORT_SELECT_TRY=1
    while [ $PORT_SELECT_TRY -le $PORT_SELECT_ATTEMPTS ]; do
        local CANDIDATE_PORT
        CANDIDATE_PORT=$(random_tunnel_port)
        if [[ "$CANDIDATE_PORT" =~ ^[0-9]+$ ]] && ! lsof -Pi :"$CANDIDATE_PORT" -sTCP:LISTEN -t >/dev/null 2>&1; then
            MIDDLE_PORT="$CANDIDATE_PORT"
            LOCAL_PORT="$CANDIDATE_PORT"
            break
        fi
        PORT_SELECT_TRY=$((PORT_SELECT_TRY + 1))
    done

    if [[ -z "$MIDDLE_PORT" || -z "$LOCAL_PORT" ]]; then
        echo "Failed to select a free local tunnel port."
        return 1
    fi
    echo "Using local browser port: $LOCAL_PORT"
    echo "Establishing tunnel via Login Node port: $MIDDLE_PORT"

    echo "Preparing setup script..."
    ssh -S "$CTRL_SOCKET" "$LOGIN_NODE" "cat > ~/.neurodesk_setup.sh << 'EOF'
#!/bin/bash
cd \$SCRATCH
export PATH=\$PATH:/sbin:/usr/sbin
if [ ! -f neurodesktop-overlay.img ]; then
    echo \"Creating neurodesktop-overlay.img (2GB)...\"
    dd if=/dev/zero of=neurodesktop-overlay.img bs=1M count=2048
    mkfs.ext3 -F neurodesktop-overlay.img
    debugfs -w -R \"mkdir upper\" neurodesktop-overlay.img
    debugfs -w -R \"mkdir work\" neurodesktop-overlay.img
else
    echo \"neurodesktop-overlay.img found.\"
fi

if [ ! -d ~/neurodesktop-home ]; then
    echo \"Creating ~/neurodesktop-home...\"
    mkdir -p ~/neurodesktop-home
else
    echo \"~/neurodesktop-home found.\"
fi

if [ ! -d ~/neurodesktop-home/workdir ]; then
    echo \"Creating ~/neurodesktop-home/workdir...\"
    mkdir -p ~/neurodesktop-home/workdir
else
    echo \"~/neurodesktop-home/workdir found.\"
fi

NOTEBOOK_PORT=\"\${1:-8888}\"
if [[ ! \"\$NOTEBOOK_PORT\" =~ ^[0-9]+$ ]]; then
    echo \"Invalid notebook port: \$NOTEBOOK_PORT\"
    exit 1
fi

DISPLAY_PORT=\"\${2:-\$NOTEBOOK_PORT}\"
if [[ ! \"\$DISPLAY_PORT\" =~ ^[0-9]+$ ]]; then
    echo \"Invalid display port: \$DISPLAY_PORT\"
    exit 1
fi


#    --home \$HOME/neurodesktop-home:/home/jovyan \\

echo \"Starting Neurodesktop container on internal port \$NOTEBOOK_PORT (displaying as localhost:\$DISPLAY_PORT)...\"
# Using backslashes for line continuation in the remote file requires double backslash here
apptainer run \\
   --nv \\
   --fakeroot \\
   --overlay \$SCRATCH/neurodesktop-overlay.img \\
   --bind \$GROUP_HOME/neurodesk/local/containers/:/neurodesktop-storage/containers \\
   --bind \$GROUP_HOME/neurodesk/local/containers/:/neurocommand/local/containers \\
   --no-home \\
   --env CVMFS_DISABLE=true \\
   --env NB_UID=\$(id -u) \\
   --env NB_GID=\$(id -g) \\
   --env NEURODESKTOP_VERSION=latest \\
   \$GROUP_HOME/neurodesk/neurodesktop_latest.sif \\
   start-notebook.py --allow-root --port=\"\$NOTEBOOK_PORT\" --ServerApp.port_retries=0 --ServerApp.custom_display_url=\"http://127.0.0.1:\$DISPLAY_PORT\"
EOF
chmod +x ~/.neurodesk_setup.sh"

    # --- 4. LAUNCH ALLOCATION ---
    local GPU_FLAG=""
    local MAX_PORT_ATTEMPTS=10
    if [[ "$GPU" != "none" && ! -z "$GPU" ]]; then
        GPU_FLAG="--gres=gpu:$GPU"
    fi
    
    ssh -S "$CTRL_SOCKET" -t -L ${LOCAL_PORT}:localhost:${MIDDLE_PORT} "$LOGIN_NODE" \
        "salloc --job-name=$JOB_NAME -p $PARTITION --nodes=1 --time=$WALLTIME --ntasks=1 --cpus-per-task=$CPUS --mem=$MEM $GPU_FLAG \
        bash -c 'echo \"Allocated: \${SLURM_NODELIST}\"; \
                 echo \"Open Neurodesktop in your local browser at: http://127.0.0.1:${LOCAL_PORT}\"; \
                 trap \"echo Session cancelled by user. Stopping retries.; exit 130\" INT TERM; \
                 max_attempts=${MAX_PORT_ATTEMPTS}; \
                 attempt=1; \
                 compute_port=${MIDDLE_PORT}; \
                 while [ \$attempt -le \$max_attempts ]; do \
                     echo \"Attempt \$attempt/\$max_attempts using compute-node notebook port: \$compute_port\"; \
                     ssh -t -L ${MIDDLE_PORT}:localhost:\$compute_port \${SLURM_NODELIST} \"~/.neurodesk_setup.sh \$compute_port ${LOCAL_PORT}\"; \
                     ssh_rc=\$?; \
                     if [ \$ssh_rc -eq 0 ]; then \
                         exit 0; \
                     fi; \
                     if [ \$ssh_rc -eq 130 ] || [ \$ssh_rc -eq 143 ] || [ \$ssh_rc -eq 255 ]; then \
                         echo \"Session interrupted or connection closed (exit \$ssh_rc). Stopping retries.\"; \
                         exit \$ssh_rc; \
                     fi; \
                     attempt=\$((attempt + 1)); \
                     if [ \$attempt -le \$max_attempts ]; then \
                         compute_port=\$((compute_port + 1)); \
                         if [ \$compute_port -gt 65000 ]; then \
                             compute_port=10000; \
                         fi; \
                         echo \"Port unavailable or startup failed. Retrying with compute-node notebook port: \$compute_port\"; \
                     fi; \
                 done; \
                 echo \"Failed to start Neurodesktop after \$max_attempts attempts.\"; \
                 exit 1'"
}

# Check if the script is being executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    self_update_connect_sherlock "${BASH_SOURCE[0]}" "$@"
    connectSherlock "$@"
fi
