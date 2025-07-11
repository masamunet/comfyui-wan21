DOCKER_USERNAME ?= $(shell grep DOCKER_USERNAME .env | cut -d '=' -f2 | tr -d ' ')
IMAGE_NAME = runpod-comfyui-wan21
TAG ?= latest

# 使い方:
#   make build                  # イメージをローカルにビルドする
#   make push                   # イメージをDocker Hubにプッシュする
#   make build-and-push        # ビルドしてDocker Hubにプッシュする
#
# 環境変数:
#   DOCKER_USERNAME  - Docker Hubのユーザー名 (デフォルト: your-dockerhub-username)
#   TAG             - イメージのタグ (デフォルト: latest)
#
# 例:
#   DOCKER_USERNAME=myname TAG=v1.0.0 make build
#   DOCKER_USERNAME=myname make build-and-push

.PHONY: build push build-and-push

build:
	docker buildx build --no-cache --pull --platform linux/amd64 --load -t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG) .

push:
	docker push $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG)

build-and-push: bp
bp:
	docker buildx build --no-cache --pull --platform linux/amd64 --push -t $(DOCKER_USERNAME)/$(IMAGE_NAME):$(TAG) .
