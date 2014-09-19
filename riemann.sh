#!/bin/bash

#run the python script riemann.py every 10 seconds
#this should be launched from crontab every minute


for ((i=0; i<6; i++))
do
        /etc/quill/riemann-get-stats.sh >/tmp/riemann-stats
        /etc/quill/riemann.py
        #/etc/quill/riemann-firebird.py
        #echo $(date)
        sleep 10
done

exit 0
