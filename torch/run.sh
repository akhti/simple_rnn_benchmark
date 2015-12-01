#!/usr/bin/env bash

set -e
set -o pipefail
set -o nounset

WD="$(readlink -f "$(dirname "$0")")"

for param_set in small large; do
    if [ -f "$WD/results.$param_set" ]; then
        echo "Result already calculated"
    else
        cd $WD/lstm
        th main.lua -param-set $param_set 2>&1 | tee $WD/log.$param_set

        cat $WD/log.$param_set | tr -d "," | awk -v tag=$param_set '
           $8 == "wps" {wps = $10}
           $0 ~ /Validation set perplexity/ {valid = $NF}
           $0 ~ /Test set perplexity/ {test = $NF}
           END {
              OFS="\t";
              print "torch", tag, wps, valid, test;
           }
        ' > $WD/results.$param_set
    fi
done

echo "BENCHMARK RESULTS"
cat "$WD"/results.*
