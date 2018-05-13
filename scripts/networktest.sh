#!/bin/sh

counter=0
echo "Network test started at: `date`"
while [ 1 ]; do
 #ping -c1 www.google.com
	#ping -q -c5 www.google.com > /dev/null
	ping -q -c5 www.google.com > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		counter=$((counter+1))
		echo "Ping failed at `date` ; Total fails: $counter"
		wifi
	fi
	sleep 5
done