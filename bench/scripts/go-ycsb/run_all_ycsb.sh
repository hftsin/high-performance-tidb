#!/bin/bash

for w in a b c d e f; do
for th in 8 16 32; do
    sh run_ycsb.sh run ${w} ${th}
    sleep 60
  done
done
