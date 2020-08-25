#!/bin/sh

CMD="./bin/go-ycsb"
LOG_DIR=log_ycsb
mkdir -p ${LOG_DIR}

MYSQL_HOST=10.211.55.4
MYSQL_PORT=4000
MYSQL_DB="ycsbtest"

# RECORD_COUNT=100000000
# OPERATION_COUNT=100000000
RECORD_COUNT=100000
OPERATION_COUNT=100000
FIELD_COUNT=10
FIELD_LENGTH=100
MAXSCANLENGTH=10

# $1 -- op: load/run
# $2 -- workload
# $3 -- threads
op() {
  op=${1:-run}
  w=${2:-a}
  threads=${3:-8}
  ${CMD} run mysql -p mysql.host=${MYSQL_HOST} -p mysql.port=${MYSQL_PORT} -p mysql.db=${MYSQL_DB}_${w} \
    -p recordcount=${RECORDCOUNT} \
    -p operationcount=${OPERATION_COUNT} \
    -p fieldcount=${FIELD_COUNT} \
    -p fieldlength=${FIELD_LENGTH} \
    -p maxscanlength=${MAXSCANLENGTH} \
    -P workloads/workload${w} \
    -p treadcount=${threads} \
    | tee ${LOG_DIR}/${op}_${w}_${threads}
}

# $1 -- op: load / run
# $2 -- workload
# $3 -- threads
case "$1" in
  "load" | "run")
    op $1 $2 $3
    ;;
  *)
    echo "usage: $(basename $0) <load | run> <workload> <threads>"
    ;;
esac
