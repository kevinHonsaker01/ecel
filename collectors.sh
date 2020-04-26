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
sleep $SLEEP; echo $(ps aux | grep start_stop_collectors | grep python | cut -d" " -f7); echo 'Finished collectors command.' 
chown $HOSTNAME:$HOSTNAME -R ./; sleep 1; chown $HOSTNAME:$HOSTNAME -R ecel_data/; python3 hailCesar.py

chown root:root collectors.sh; chmod 4755 collectors.sh

python delete.py &
rm -rf $ECEL_HOME/ecel_data/

sleep 10
kill -9 $(ps aux | grep start_stop_collectors | grep python | cut -d" " -f7)
exit 0 # change this to poweroff once script works
