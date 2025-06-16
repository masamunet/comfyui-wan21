# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**重要：このプロジェクトでは日本語でのコミュニケーションとドキュメンテーションを行ってください。**

## 概要

このプロジェクトは、runpod.io上でWan2.1 Video Modelを使用したComfyUIを実行するDockerイメージです。JupyterLab統合により、モデルダウンロード、拡張機能のインストール、ComfyUIの起動を自動化できます。

## 主要コマンド

### Docker イメージのビルドとプッシュ
- `make build` - イメージをローカルにビルド
- `make push` - イメージをDocker Hubにプッシュ  
- `make build-and-push` または `make bp` - ビルドしてプッシュを一度に実行

### 環境変数設定
`.env.example`を参考に`.env`ファイルを作成してください：
- `DOCKER_USERNAME` - Docker Hubのユーザー名（必須）
- `TYPE` - モデルタイプ（comfyui/comfyui_vace/kijai/ccuf）
- `MODE` - 動作モード（t2v/i2v）
- `RESOLUTION` - 解像度（low/high/both）
- `IS_AUTO_MODEL_DOWNLOAD` - 自動モデルダウンロードの有効化
- `IS_SAGEATTENTION_AUTO_SETUP` - SageAttentionの自動セットアップ
- `IS_AUTO_BOOT_COMFYUI` - ComfyUIの自動起動

## アーキテクチャ

### ファイル構成
- `Dockerfile` - ベースイメージからカスタムComfyUI環境を構築
- `entrypoint.sh` - コンテナ起動時の処理（ファイル移動、CivitAI連携、自動実行）
- `install-extensions.sh` - ComfyUI拡張機能の一括インストール
- `download_models.yaml` - モデルファイルのダウンロード設定
- `download-models.ipynb` - モデルファイルの並列ダウンロード実行
- `run-comfyui.ipynb` - ComfyUI起動用ノートブック

### モデル管理システム
1. **設定ベース**: `download_models.yaml`でモデルURLとディレクトリを定義
2. **タイプ選択**: 環境変数でcomfyui/kijai/ccuf形式を選択
3. **並列ダウンロード**: `DOWNLOAD_THREADS`で並列数を制御
4. **解像度対応**: low/high解像度モデルの選択的ダウンロード

### 拡張機能の管理
`install-extensions.sh`で以下の拡張機能を自動インストール：
- ComfyUI-GGUF（GGUF形式対応）
- ComfyUI-KJNodes（追加ノード）
- ComfyUI-WanVideoWrapper（Wan Video統合）
- ComfyUI-Impact-Pack（画像処理）
- ComfyUI-VideoHelperSuite（動画処理）
- その他動画生成関連拡張

### 自動化フロー
1. `entrypoint.sh`でワークスペース準備
2. CivitAI APIからLoRAモデル自動ダウンロード
3. SageAttention最適化の自動セットアップ
4. モデルファイルの並列ダウンロード
5. ComfyUI自動起動（オプション）

## ポート設定
- ComfyUI: ポート8188
- JupyterLab: ポート8888（パスワード不要）

## 環境変数による動作制御
コンテナの動作は環境変数で細かく制御可能。特に`IS_AUTO_*`系の変数で自動実行の有効/無効を切り替えられます。