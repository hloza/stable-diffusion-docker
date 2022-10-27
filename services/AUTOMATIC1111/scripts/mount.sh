#!/bin/bash

set -Eeuo pipefail

declare -A MOUNTS

mkdir -p /data/config/auto/
if [ ! -s /data/config/auto/config.json ]; then
  cp /docker/config.json /data/config/auto/config.json
fi
if [ ! -s /data/config/auto/ui-config.json ]; then
  cp /docker/ui-config.json /data/config/auto/ui-config.json
fi

MOUNTS["/root/.cache"]="/data/.cache"

# main
MOUNTS["${ROOT}/models/Stable-diffusion"]="/data/StableDiffusion"
MOUNTS["${ROOT}/models/Codeformer"]="/data/Codeformer"
MOUNTS["${ROOT}/models/GFPGAN"]="/data/GFPGAN"
MOUNTS["${ROOT}/models/ESRGAN"]="/data/ESRGAN"
MOUNTS["${ROOT}/models/BSRGAN"]="/data/BSRGAN"
MOUNTS["${ROOT}/models/RealESRGAN"]="/data/RealESRGAN"
MOUNTS["${ROOT}/models/SwinIR"]="/data/SwinIR"
MOUNTS["${ROOT}/models/ScuNET"]="/data/ScuNET"
MOUNTS["${ROOT}/models/LDSR"]="/data/LDSR"
MOUNTS["${ROOT}/models/hypernetworks"]="/data/Hypernetworks"
MOUNTS["${ROOT}/models/deepbooru"]="/data/deepbooru"
MOUNTS["${ROOT}/models/Deforum"]="/data/Deforum"

MOUNTS["${ROOT}/embeddings"]="/data/embeddings"
MOUNTS["${ROOT}/extensions/aesthetic-gradients/aesthetic_embeddings"]="/data/embeddings"
MOUNTS["${ROOT}/extensions/stable-diffusion-webui-inspiration/inspiration"]="/data/inspiration"

MOUNTS["${ROOT}/config.json"]="/data/config/auto/config.json"
MOUNTS["${ROOT}/ui-config.json"]="/data/config/auto/ui-config.json"

# extra hacks
MOUNTS["${ROOT}/repositories/CodeFormer/weights/facelib"]="/data/.cache"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

#jq '. * input' /data/config/auto/config.json | sponge /data/config/auto/config.json
mkdir -p /output/saved /output/txt2img-images/ /output/img2img-images /output/extras-images/ /output/grids/ /output/txt2img-grids/ /output/img2img-grids/
