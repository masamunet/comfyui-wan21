#!/bin/bash

pip uninstall -y sageattention # 既存のsageattentionをアンインストール
git clone https://github.com/thu-ml/SageAttention.git
cd SageAttention
pip install -e .
