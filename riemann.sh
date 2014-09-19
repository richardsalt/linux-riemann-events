#!/bin/bash

#run the python script riemann.py every 10 seconds
#this should be launched from crontab every minute


for ((i=0; i<6; i++))
do
        /etc/linux-riemann-events/riemann-get-stats.sh >/tmp/riemann-stats
        /etc/linux-riemann-events/riemann.py
        #/etc/linux-riemann-events/riemann-firebird.py
        #echo $(date)
        sleep 10
done

exit 0
