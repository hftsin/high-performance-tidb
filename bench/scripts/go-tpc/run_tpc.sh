#!/bin/sh

CMD="./bin/go-tpc"
LOG_DIR=log_go_tpc

MYSQL_HOST=10.211.55.4
MYSQL_PORT=4000
MYSQL_DB=tpctest

WAREHOUSE=100

# $1 -- op: prepare / cleanup / run
# $2 -- workload: tpcc / tpch
# $3 -- threads
op() {
  op=${1:-run}
  w=${2:-tpcc}
  th=${3:-8}
  date | tee ${LOG_DIR}/${op}_${w}_${th}
  ${CMD} ${w} -H ${MYSQL_HOST} -P ${MYSQL_PORT} -D ${MYSQL_DB}_${w} \
    --threads ${th} --warehouses ${WAREHOUSE} \
    --time 5m \
    ${op} | tee ${LOG_DIR}/${op}_${w}_${th}
}

case "$1" in
  "prepare" | "run" | "cleanup")
    op $1 $2 $3
    ;;
  *)
    echo "usage: $(basename $0) <load | run> <bench> <threads>"
    ;;
esac
