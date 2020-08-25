#!/bin/sh

for c in oltp_point_select oltp_update_index oltp_read_only oltp_write_only oltp_read_write; do
  for th in 8 16 32; do
    sh ./run_sysbench.sh run $c ${th}
    sleep 90
  done
done
