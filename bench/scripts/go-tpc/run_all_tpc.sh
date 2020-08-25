#!/bin/sh

for w in tpcc tpch; do
  for th in 4 8 16 32; do
    ./run_tpc.sh run ${w} ${th}
    sleep 300
  done
done
