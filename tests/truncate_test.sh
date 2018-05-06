#!/bin/bash

source $(dirname $0)/functions.sh

LOGS=${TEST_TMPDIR}/logs
PROGS=${TEST_TMPDIR}/logs
mkdir -p $LOGS $PROGS

start_server --vmodule=tail=2,log_watcher=2 --progs $PROGS --logs $LOGS/log

echo 1 >> $LOGS/log
sleep 1
cat /dev/null > $LOGS/log
sleep 1
echo 2 >> $LOGS/log

sleep 1

uri_get /debug/vars
expect_json_field_eq 2 line_count "${WGET_DATA}"
expect_json_field_eq 1 log_count "${WGET_DATA}"
