#!/bin/bash
function connectSherlock() {
    local LOGIN_NODE="sherlock"
    local JOB_NAME="neurodesktop"
    
    # --- 1. CHECK FOR EXISTING "NEURODESKTOP" JOBS ---
    # We add --name="neurodesktop" to squeue so we don't accidentally 
    # grab background compute jobs.
    local EXISTING_JOB=$(ssh -q "$LOGIN_NODE" "squeue -u \$USER --name=$JOB_NAME -h -t R -o '%i %N' | head -n 1")
    
    if [ ! -z "$EXISTING_JOB" ]; then
        read -r JOB_ID NODE_NAME <<< "$EXISTING_JOB"
        echo "Found active $JOB_NAME session (Job $JOB_ID) on Node: $NODE_NAME"
        echo -n "Reuse this connection? [Y/n] "
        read -r reuse
        
        # Default to Yes
        if [[ ! "$reuse" =~ ^([nN][oO]|[nN])$ ]]; then
            echo "Reconnecting to $NODE_NAME..."
            echo "ℹ️  Using existing tunnel on port 8888 (maintained by your original terminal)."
            ssh -t "$LOGIN_NODE" "ssh $NODE_NAME"
            return
        fi
    fi

    # --- 2. CONFIGURATION FOR NEW CONNECTION ---
    echo "================================================================================"
    echo " partition   || job runtime | mem/core | per-node cores"
    echo " name        ||     maximum |  maximum | (range)"
    echo "--------------------------------------------------------------------------------"
    echo " normal     ||          7d |      8GB | 20-64"
    echo " bigmem      ||          1d |     64GB | 24-256"
    echo " dev         ||          2h |      8GB | 20-32"
    echo "--------------------------------------------------------------------------------"
    echo "================================================================================"
    
    echo -n "Which partition do you want to submit to? [dev] "
    read -r PARTITION
    PARTITION=${PARTITION:-dev}

    echo -n "How much Memory needed? [8G] "
    read -r MEM
    MEM=${MEM:-8G}

    echo -n "How many CPUs needed? [1] "
    read -r CPUS
    CPUS=${CPUS:-1}

    echo -n "How much Time needed? [01:00:00] "
    read -r WALLTIME
    WALLTIME=${WALLTIME:-01:00:00}

    local MIDDLE_PORT=$(shuf -i 10000-65000 -n 1)
    echo "Establishing tunnel via Login Node port: $MIDDLE_PORT"

    # --- 3. CHECK LOCAL PORT 8888 ---
    # Check if port 8888 is occupied and kill the process if so
    if lsof -Pi :8888 -sTCP:LISTEN -t >/dev/null ; then
        echo "⚠️  Port 8888 is already in use."
        local PID=$(lsof -Pi :8888 -sTCP:LISTEN -t)
        echo "Killing process $PID to free up port 8888..."
        kill -9 "$PID"
    fi

    # --- 4. LAUNCH ALLOCATION ---
    # Added --job-name (or -J) to tag this specific session
    ssh -S none -t -L 8888:localhost:${MIDDLE_PORT} "$LOGIN_NODE" \
        "salloc --job-name=$JOB_NAME -p $PARTITION --nodes=1 --time=$WALLTIME --ntasks=1 --cpus-per-task=$CPUS --mem=$MEM \
        bash -c 'echo \"Allocated: \${SLURM_NODELIST}\"; \
                 ssh -t -L ${MIDDLE_PORT}:localhost:8888 \${SLURM_NODELIST}'"
}