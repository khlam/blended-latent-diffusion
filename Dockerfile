# Base image with CUDA and necessary Python packages
FROM nvidia/cuda:12.2.2-cudnn8-runtime-ubuntu22.04 AS base

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-pip \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies
RUN pip3 install --no-cache-dir \
    torch torchvision torchaudio \
    ftfy regex matplotlib lpips opencv-python \
    transformers diffusers==0.19.3 accelerate \
    git+https://github.com/CompVis/taming-transformers.git@master#egg=taming-transformers \
    git+https://github.com/openai/CLIP.git@main#egg=clip

# Set environment variables
ENV PROMPT=""
ENV INIT_IMAGE=""
ENV MASK=""

# Copy application files
COPY configs /app/configs
COPY data /app/data
COPY general_utils /app/general_utils
COPY ldm /app/ldm
COPY models /app/models
COPY scripts /app/scripts

# entrypoints

FROM base AS sdxl
ENTRYPOINT ["sh", "-c", "python3 -u /app/scripts/text_editing_SDXL.py --prompt \"$PROMPT\" --init_image \"$INIT_IMAGE\" --mask \"$MASK\""]

FROM base as sd2
ENTRYPOINT ["sh", "-c", "python3 -u /app/scripts/text_editing_SD2.py --prompt \"$PROMPT\" --init_image \"$INIT_IMAGE\" --mask \"$MASK\""]
