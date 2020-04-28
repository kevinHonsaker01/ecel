#!/bin/bash

# make script executable during ecel_install.sh

if [ -z "$1" ]
	echo "Usage: ./standalone.sh <interval>"
fi

# create master directory to hold all other directories
mkdir $ECEL_HOME/ecel_data
chown $HOSTNAME:$HOSTNAME home/
# create directories to store the output files of each collector
mkdir $ECEL_HOMEecel_data/snoopy; mkdir $ECEL_HOME/ecel_data/tshark; mkdir $ECEL_HOME/ecel_data/pykeylogger

# start tshark; file output
dumpcap -i $(ifconfig | grep 1500 | cut -d":" -f1) -a duration:$1 &

# start pykeylogger -- not installed ??


# collect PIDs to stop collectors
pid_tshark=$(ps aux | grep dumpcap | grep $(ifconfig | grep 1500 | cut -d":" -f1) | cut -d" " -f7)
# pid_pykeylogger=$()

# start snoopy -- capture last because it is running the entire time after install
cp /tmp/snoopy.log $ECEL_HOME/ecel_data/snoopy/snoopy.log
cp /tmp/$(ll /tmp | grep wireshark | cut -d" " -f14) $ECEL_HOME/ecel_data/tshark

# stop collectors gracefully --> they stop after a predefined condition

# zip file
zip -r ecel_data.zip $ECEL_HOME/ecel_data

# push zip to database
python3 $ECEL_HOME/hailCesar.py 
