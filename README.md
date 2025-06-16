# 🎬 ComfyUI Wan2.1 Video Model Docker

**最新のWan2.1 Video ModelをComfyUIで簡単に使える、RunPod対応Dockerイメージ**

[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)](https://hub.docker.com/)
[![RunPod](https://img.shields.io/badge/RunPod-Compatible-blue?style=for-the-badge)](https://runpod.io/)
[![ComfyUI](https://img.shields.io/badge/ComfyUI-Ready-green?style=for-the-badge)](https://github.com/comfyanonymous/ComfyUI)

## ✨ 主な機能

- 🚀 **ワンクリック起動**: 環境変数で全て自動化
- 🎥 **Wan2.1 Video Model**: 最新のText-to-Video/Image-to-Video生成
- 🔧 **ComfyUI統合**: 直感的なノードベースUI
- 📊 **JupyterLab**: モデル管理とワークフロー実行
- ⚡ **SageAttention**: メモリ効率の最適化
- 🎭 **CivitAI連携**: LoRAモデルの自動ダウンロード
- 🔄 **並列ダウンロード**: 高速モデル取得

## 🚀 クイックスタート

### 1. RunPodでの使用（推奨）

1. **RunPodにログイン** → [runpod.io](https://runpod.io/)
2. **新しいポッドを作成**
3. **カスタムイメージを選択**: `<your-username>/runpod-comfyui-wan21:latest`
4. **環境変数を設定**:
   ```bash
   TYPE=comfyui
   MODE=t2v
   IS_AUTO_MODEL_DOWNLOAD=true
   IS_AUTO_BOOT_COMFYUI=true
   ```
5. **ポッドを起動** → 自動的にモデルダウンロード＆ComfyUI起動

### 2. ローカルでのDocker実行

```bash
# リポジトリをクローン
git clone https://github.com/your-username/comfyui-wan21.git
cd comfyui-wan21

# 環境変数ファイルを作成
cp .env.example .env
# .envファイルを編集してDockerHubユーザー名を設定

# イメージをビルド
make build

# コンテナを起動
docker run -d \
  -p 8888:8888 \
  -p 8188:8188 \
  -e TYPE=comfyui \
  -e MODE=t2v \
  -e IS_AUTO_MODEL_DOWNLOAD=true \
  -e IS_AUTO_BOOT_COMFYUI=true \
  your-username/runpod-comfyui-wan21:latest
```

## 🎯 対応モデル形式

| 形式 | 説明 | 推奨用途 |
|------|------|----------|
| `comfyui` | 公式ComfyUI形式 | バランス重視 |
| `comfyui_vace` | VACE最適化版 | 高品質生成 |
| `kijai` | Kijai版実装 | 高速処理 |
| `ccuf` | GGUF量子化版 | 省メモリ |

## ⚙️ 環境変数設定

### 基本設定
```bash
# 必須: DockerHubユーザー名
DOCKER_USERNAME=your-dockerhub-username

# モデル設定
TYPE=comfyui                    # comfyui/comfyui_vace/kijai/ccuf
MODE=t2v                        # t2v(Text-to-Video)/i2v(Image-to-Video)
RESOLUTION=both                 # low/high/both

# 自動化設定
IS_AUTO_MODEL_DOWNLOAD=true     # 自動モデルダウンロード
IS_SAGEATTENTION_AUTO_SETUP=true # SageAttention最適化
IS_AUTO_BOOT_COMFYUI=true       # ComfyUI自動起動

# パフォーマンス
DOWNLOAD_THREADS=4              # 並列ダウンロード数
```

### CivitAI連携（オプション）
```bash
CIVITAI_API_KEY=your-api-key
CIVITAI_LORA_IDS=model-id-1,model-id-2
```

## 📱 アクセス方法

起動後、以下のURLでアクセス可能：

- **ComfyUI**: `http://localhost:8188` または RunPodのポート8188
- **JupyterLab**: `http://localhost:8888` または RunPodのポート8888

## 📖 使用手順

### RunPod環境での基本的な流れ

1. **ポッド起動** → 自動でモデルダウンロード開始
2. **JupyterLabにアクセス** → ダウンロード進捗を確認
3. **ComfyUIにアクセス** → ワークフローを実行
4. **動画生成** → プロンプトを入力して生成開始

### 手動でのモデル管理

JupyterLabで以下のノートブックを実行：

- `download-models.ipynb`: モデルの手動ダウンロード
- `setup_sageattention.ipynb`: SageAttentionのセットアップ
- `run-comfyui.ipynb`: ComfyUIの手動起動

## 🔧 カスタマイズ

### 独自のワークフローを追加

```bash
# workflowsディレクトリにJSONファイルを配置
workflows/
├── text_to_video_basic.json
├── image_to_video_hq.json
└── your_custom_workflow.json
```

### 追加拡張機能のインストール

`install-extensions.sh`を編集して新しい拡張機能を追加：

```bash
custom_nodes=(
  "https://github.com/your-extension.git"
  # 既存の拡張機能...
)
```

## 🛠️ 開発者向け

### イメージのビルド＆プッシュ

```bash
# ローカルビルド
make build

# Docker Hubにプッシュ
make push

# ビルド＆プッシュを同時実行
make build-and-push
# または短縮形
make bp
```

### デバッグ情報

```bash
# コンテナ内でのデバッグ
docker exec -it container_name bash

# ログの確認
docker logs container_name

# モデルファイルの確認
ls -la /workspace/ComfyUI/models/
```

## 🔍 トラブルシューティング

### よくある問題と解決法

**Q: モデルダウンロードが失敗する**
```bash
# 解決法1: 手動でダウンロード実行
jupyter nbconvert --execute download-models.ipynb

# 解決法2: 並列数を減らす
DOWNLOAD_THREADS=2
```

**Q: ComfyUIが起動しない**
```bash
# 解決法1: 手動起動
python3 /workspace/ComfyUI/main.py --listen

# 解決法2: SageAttentionを無効化
IS_SAGEATTENTION_AUTO_SETUP=false
```

**Q: CUDA out of memory**
```bash
# 解決法: 軽量モデルを使用
TYPE=ccuf          # GGUF量子化版
RESOLUTION=low     # 低解像度モデル
```

### サポート・コミュニティ

- 🐛 **Issues**: [GitHub Issues](https://github.com/your-username/comfyui-wan21/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/your-username/comfyui-wan21/discussions)
- 📖 **Wiki**: プロジェクトWikiで詳細情報

## 📄 ライセンス

MIT License - 詳細は[LICENSE](LICENSE)ファイルを参照

## 🙏 謝辞

- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) - 素晴らしいUIフレームワーク
- [Wan Video Team](https://github.com/wanvideo) - 最新のビデオ生成モデル
- [RunPod](https://runpod.io/) - クラウドGPUプラットフォーム

---

**⭐ このプロジェクトが役に立った場合は、GitHubでスターをお願いします！**
