#!/bin/bash

# /workspace/ComfyUI/custom_nodes/* にあるリポジトリを網羅的に更新

# ディレクトリを移動
cd /workspace_tmp/ComfyUI/custom_nodes

# 拡張機能をインストール 
custom_nodes=(
  "https://github.com/city96/ComfyUI-GGUF.git"
  "https://github.com/kijai/ComfyUI-KJNodes.git"
  "https://github.com/kijai/ComfyUI-WanVideoWrapper.git"
  "https://github.com/ltdrdata/ComfyUI-Impact-Pack.git"
  "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git"
  "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation.git"
  "https://github.com/pythongosssss/ComfyUI-Custom-Scripts.git"
  "https://github.com/rgthree/rgthree-comfy.git"
  "https://github.com/BlenderNeko/ComfyUI_TiledKSampler.git"
  "https://github.com/shiimizu/ComfyUI-TiledDiffusion.git"
  "https://github.com/fluffydiveX/ComfyUI-hvBlockswap.git"
)

for node in ${custom_nodes[@]}; do
    git clone $node
done

# それぞれのディレクトリに移動して、requirements.txtがあればインストール
for dir in */; do
    if [ -d "$dir" ]; then
        cd "$dir"
        if [ -f "requirements.txt" ]; then
            echo "Installing requirements for $dir"
            pip install -r requirements.txt
        fi
        cd ..
    fi
done
