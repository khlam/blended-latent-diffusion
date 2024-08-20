# Base image with CUDA and necessary Python packages
FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04 AS base

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip3 install --no-cache-dir torch torchvision torchaudio

RUN pip3 install ftfy regex matplotlib lpips opencv-python torch torchvision torchaudio transformers diffusers==0.19.3 accelerate

# Install additional packages from git repositories
RUN pip3 install --no-cache-dir \
    git+https://github.com/CompVis/taming-transformers.git@master#egg=taming-transformers \
    git+https://github.com/openai/CLIP.git@main#egg=clip

ENV PROMPT=""
ENV INIT_IMAGE=""
ENV MASK=""

COPY configs /app/configs
COPY data /app/data
COPY general_utils /app/general_utils
COPY ldm /app/ldm
COPY models /app/models
COPY scripts /app/scripts

# Set the entrypoint
#ENTRYPOINT ["sh", "-c", "python3 -u /app/scripts/text_editing_SDXL.py --prompt \"$PROMPT\" --init_image \"$INIT_IMAGE\" --mask \"$MASK\""]
ENTRYPOINT ["sh", "-c", "python3 -u /app/scripts/text_editing_SD2.py --prompt \"$PROMPT\" --init_image \"$INIT_IMAGE\" --mask \"$MASK\""]
