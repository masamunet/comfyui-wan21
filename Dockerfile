FROM masamunet/runpod-comfyui

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  wget \
  ffmpeg \
  libsm6 \
  libxext6 \
  libavutil-dev \
  libavcodec-dev \
  libavformat-dev \
  libswscale-dev \
  liblapack-dev \
  libeigen3-dev \
  nginx \
  openssh-server \
  git-lfs \
  curl \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean \
  && git lfs install \
  && pip3 install --upgrade pip \
  && pip3 install --no-cache-dir -U bitsandbytes \
  && pip3 install --no-cache-dir \
  pyyaml \
  "triton>=3.0.0" \
  # sageattention \
  && rm -rf /root/.cache/pip


COPY runpod.yaml entrypoint.sh setup_sageattention.sh install-extentions.sh README.md /
COPY *.ipynb /workspace_tmp/
COPY download_models.yaml /workspace_tmp/

WORKDIR /workspace_tmp/ComfyUI

RUN git pull \
  && cd /workspace_tmp \
  && chmod 644 /workspace_tmp/*.ipynb \
  && chmod +x /*.sh \
  && /install-extentions.sh

WORKDIR /workspace

EXPOSE 8888
EXPOSE 8188
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "if [ \"$IS_AUTO_BOOT_COMFYUI\" = \"true\" ]; then python3 /workspace/ComfyUI/main.py --listen --use-sage-attention --preview-method auto & fi; jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --NotebookApp.token='' --NotebookApp.password='' --no-browser --ServerApp.allow_origin=* --ServerApp.allow_remote_access=True --notebook-dir=/workspace"]
