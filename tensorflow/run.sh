#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

if [ $# -ne 3 ]; then
    echo "Usage: $0 <path to TensorFlow root> <path to data> <deviceid>"
    exit 1
fi

TF_ROOT="$1"
DATA_ROOT="$(readlink -f "$2")"
WD="$(readlink -f "$(dirname "$0")")"
export CUDA_VISIBLE_DEVICES=$3

if [ ! -d "$TF_ROOT/tensorflow/models/rnn/ptb" ]; then
    echo "Failed to find $TF_ROOT/tensorflow/models/rnn/ptb"
    exit 1
fi

cd "$TF_ROOT"
bazel build -c opt --config=cuda tensorflow/models/rnn/ptb:ptb_word_lm

for param_set in large small; do
    if [ -f "$WD/results.$param_set" ]; then
        echo "Result already calculated"
    else
        bazel-bin/tensorflow/models/rnn/ptb/ptb_word_lm \
              --data_path="$DATA_ROOT" --model $param_set 2>&1 \
              | tee "$WD/log.$param_set"

        cat "$WD/log.$param_set" | tr -d "\r" | awk -v tag=$param_set '
           $NF == "wps" {wps = $(NF - 1);}
           tolower($0) ~ /valid perplexity/ {valid = $NF}
           tolower($0) ~ /test (set )?perplexity/ {test = $NF}
           END {
              OFS="\t";
              print "tensorflow", tag, wps, valid, test;
           }
        ' > "$WD/results.$param_set"
    fi
done

echo "BENCHMARK RESULTS"
cat "$WD"/results.*
