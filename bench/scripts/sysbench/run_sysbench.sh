#!/bin/sh

DB_SIZE="--tables=8 --table_size=100000"

LOG_DIR=log_sysbench
mkdir -p ${LOG_DIR}

# $1 -- op: prepare / run
# $2 -- bench
# $3 -- threads
op()
{
  op=${1:-run}
  cmd=${2:-oltp_point_select}
  th=${3:-8}
  log=${LOG_DIR}/${cmd}_${th}
  date | tee ${log}
  sysbench --config-file=sysbench.cfg --threads=${th} --mysql-db=sbtest_${cmd} ${DB_SIZE} ${cmd} ${op} | tee ${log}
}

# $1 -- op: prepare / run
# $2 -- bench: oltp_point_select / oltp_update_index / oltp_read_only / oltp_write_only / oltp_read_write
# $3 -- threads
case "$1" in
  "prepare" | "run")
    op $1 $2 $3
    ;;
  *)
    echo "usage: $(basename $0) <prepare|run> <bench> <threads>"
esac
