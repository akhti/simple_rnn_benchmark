#!/usr/bin/env bash
set -e
set -o pipefail

export CUDA_SO=$(\ls /usr/lib/x86_64-linux-gnu/libcuda* | xargs -I{} echo '-v {}:{}')
export DEVICES=$(\ls /dev/nvidia* | xargs -I{} echo '--device {}:{}')
export CUDA_SRCS="-v /usr/local/cuda:/usr/local/cuda -v /usr/share/nvidia:/usr/share/nvidia"

rm -rf tmp
mkdir -p tmp
cp -R ../contrib/torch-lstm-lm tmp/lstm
cp -R ../contrib/ptb tmp/lstm/data

if [ ! -f "log.docker" ]; then
    docker build -t nn-tests/torch .
    docker run -it $CUDA_SO $CUDA_SRCS $DEVICES nn-tests/torch 2>&1 | tee log.docker.tmp
    mv log.docker.tmp log.docker
fi
cat log.docker | awk '$0 ~ /BENCHMARK RESULTS/ {p = 1} p {++p; if (p > 2) print}' | tee result.docker
