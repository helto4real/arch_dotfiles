#!/usr/bin/env zsh

export CUDA_HOME=/opt/cuda
export PATH=/opt/cuda/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/targets/x86_64-linux/lib:/opt/cuda/lib64:$LD_LIBRARY_PATH

/home/thhel/.pyenv/versions/3.13.2/bin/python main.py --output-directory /home/thhel/comfy/output --input-directory /home/thhel/comfy/input --user-directory /home/thhel/comfy/user
#/home/thhel/.pyenv/versions/3.13.2/bin/python main.py --output-directory /home/thhel/comfy/output --input-directory /home/thhel/comfy/input --user-directory /home/thhel/comfy/user --reserve-vram 2.0
# /home/thhel/.pyenv/versions/3.13.2/bin/python main.py --output-directory /home/thhel/comfy/output --input-directory /home/thhel/comfy/input --user-directory /home/thhel/comfy/user --disable-dynamic-vram

