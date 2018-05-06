#!/bin/env bash

# This script changes screen temperature based on the information
# provided below

LON=28.38
LAT=77.12
HIG=5500
LOW=3700

ps -C redshift &> /dev/null

if [ "$?" -eq "0" ]
then
	exit 0
else
	redshift -l $LON:$LAT -t $HIG:$LOW &
fi
