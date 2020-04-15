#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "ECEL must be run as root"
    exit 1
fi

cd "${ECEL_HOME}"
python start_stop_collectors.py &
sleep 15
kill -9 $(ps aux | grep start_stop_collectors | grep python | cut -d" " -f7)
python3 hailCesar.py
exit 0
