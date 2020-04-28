#!/bin/bash

# make script executable during ecel_install.sh

if [ -z "$1" ]; then
	echo "Usage: ./standalone.sh <interval>"
fi

# create master directory to hold all other directories -- root owned
cd $ECEL_HOME
if [ -f "ecel_data" ]; then
	echo "ecel_data folder exists."
	rm -rf ecel_data
	mkdir ecel_data
	mkdir ecel_data/snoopy
	mkdir ecel_data/pykeylogger
	mkdir ecel_data/tshark
else
	mkdir ecel_data
	mkdir ecel_data/snoopy
	mkdir ecel_data/pykeylogger
	mkdir ecel_data/tshark
fi

# start tshark; file output
cd /tmp
rm -rf *.pcapng
cd $ECEL_HOME
dumpcap -i $(ifconfig | grep 1500 | cut -d":" -f1) -a duration:$1 &
SLEEP=$1
SLEEP=$((SLEEP+5))

# start pykeylogger -- not installed ??


# collect PIDs to stop collectors
# pid_tshark=$(ps aux | grep dumpcap | grep $(ifconfig | grep 1500 | cut -d":" -f1) | cut -d" " -f7)
# pid_pykeylogger=$()

# start snoopy -- capture last because it is running the entire time after install
cp /tmp/snoopy.log $ECEL_HOME/ecel_data/snoopy/snoopy.log
sleep $SLEEP
cp /tmp/*.pcapng $ECEL_HOME/ecel_data/tshark/


# stop collectors gracefully --> they stop after a predefined condition

# change ownership to allow regular users to access
chown $HOSTNAME:$HOSTNAME -R ecel_data

# zip file -- root owned
zip -r ecel_data.zip ecel_data

# change ownership to allow regular users to access
chown $HOSTNAME:$HOSTNAME ecel_data.zip

# push zip to database
# python3 hailCesar.py 
