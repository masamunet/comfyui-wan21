#!/bin/bash

# Check if /workspace_tmp exists
if [ -d "/workspace_tmp" ]; then
    # Move all contents from /workspace_tmp to /workspace
    mv /workspace_tmp/* /workspace/
    # Remove /workspace_tmp directory
    rm -rf /workspace_tmp
fi

cd /workspace
# 環境変数を読み込み、自動実行する

if [ "$IS_SAGEATTENTION_AUTO_SETUP" = "true" ]; then
    jupyter nbconvert --to notebook --execute ./setup_sageattention.ipynb --inplace &
    SAGEATTENTION_PID=$!
fi

if [ "$IS_AUTO_MODEL_DOWNLOAD" = "true" ]; then
    jupyter nbconvert --to notebook --execute ./download-models.ipynb --inplace &
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
