#!/bin/bash

if [ $# -eq 0 ]; then
    # <interval> is the time collectors will be running for; 
    # should come from the start/stop condition of the user input;
	echo "Usage: sudo ./collectors <interval>"
fi

SLEEP=$1
SLEEP=$((SLEEP+5))

# remove previous ecel data
rm -rf $ECEL_HOME/ecel_data/

cd "${ECEL_HOME}"
python start_stop_collectors.py $1 &
sleep $SLEEP; kill -9 $(ps aux | grep start_stop_collectors | grep python | cut -d" " -f7); echo 'Finished collectors command.' 
chown $HOSTNAME:$HOSTNAME -R ecel_data/; python3 hailCesar.py

# clean up data space
rm -rf $ECEL_HOME/ecel_data/
exit 0
