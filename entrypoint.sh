#!/bin/bash

# Check if /workspace_tmp exists
if [ -d "/workspace_tmp" ]; then
    # Move all contents from /workspace_tmp to /workspace
    mv /workspace_tmp/* /workspace/
    # Remove /workspace_tmp directory
    rm -rf /workspace_tmp
fi

cd /
git clone https://github.com/Hearmeman24/CivitAI_Downloader.git
cd CivitAI_Downloader

# Check if CIVITAI_API_KEY is set
if [ ! -z "$CIVITAI_API_KEY" ]; then
    # Check if CIVITAI_LORA_IDS is set
    if [ ! -z "$CIVITAI_LORA_IDS" ]; then
        # Create loras directory if it doesn't exist
        mkdir -p /workspace/ComfyUI/models/loras
        
        # Split CIVITAI_LORA_IDS by comma and iterate
        IFS=',' read -ra LORA_IDS <<< "$CIVITAI_LORA_IDS"
        for lora_id in "${LORA_IDS[@]}"; do
            python3 download.py -t "$CIVITAI_API_KEY" -m "$lora_id" -o /workspace/ComfyUI/models/loras > /dev/null 2>&1
        done
    fi
fi

cd /workspace
# 環境変数を読み込み、自動実行する

if [ "$IS_SAGEATTENTION_AUTO_SETUP" = "true" ]; then
    python3 -m nbconvert --to notebook --execute ./setup_sageattention.ipynb --inplace &
    SAGEATTENTION_PID=$!
fi

if [ "$IS_AUTO_MODEL_DOWNLOAD" = "true" ]; then
    python3 -m nbconvert --to notebook --execute ./download-models.ipynb --inplace &
    MODEL_DOWNLOAD_PID=$!
fi

if [ ! -z "$SAGEATTENTION_PID" ]; then
    wait $SAGEATTENTION_PID
fi
if [ ! -z "$MODEL_DOWNLOAD_PID" ]; then
    wait $MODEL_DOWNLOAD_PID
fi

# Execute the CMD passed as arguments
exec "$@"
