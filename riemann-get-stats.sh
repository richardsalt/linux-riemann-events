#!/bin/bash

_CORES=`nproc`
echo "cores-# $_CORES"

################## cpu
_cpu=`ps aux  | awk 'BEGIN { sum = 0 }  { sum += $3 }; END { print sum/'$_CORES' }'`
echo "cpu-used-% $_cpu"

################## load average
#load of 1.0 means the cpus are fully utilized, warn at 0.8, critical at 1.0
cat /proc/loadavg | awk '{printf("loadavg-01m-%% %s\n", $1*100/'$_CORES' )}' #average load over 1m
cat /proc/loadavg | awk '{printf("loadavg-05m-%% %s\n", $2*100/'$_CORES' )}' #average load over 5m
cat /proc/loadavg | awk '{printf("loadavg-15m-%% %s\n", $3*100/'$_CORES' )}' #average load over 15m

################## storage used
df | grep boot | grep -v tmp | awk '{printf("disk-used-%%-/boot %s\n", $5 )}' #% of partition used, warning at 80%, critical at 90%
df | grep data | grep -v tmp | awk '{printf("disk-used-%%-/data %s\n", $5 )}' #% of partition used, warning at 80%, critical at 90%
df | grep _root | grep -v tmp | awk '{printf("disk-used-%%-/ %s\n", $5 )}' #% of partition used, warning at 80%, critical at 90%

################## memory used (free = MemFree + Buffers + Cached)
#_total=`head -1 /proc/meminfo | awk '{print $2 }'`
#_free=`head -4 /proc/meminfo | tail -3 | awk '{sum += $2} END {print sum}'`
#_used=$((_total - _free))
#echo "memory-used-% $(((_used*100 / _total*100)/100))" #% memory used, warning at 80%, critical at 90%
_mem=` ps aux  | awk 'BEGIN { sum = 0 }  { sum += $4 }; END { print sum }'`
echo "memory-used-% $_mem"

################## disk utlisation & wait times
iostat xvda -xd | tail -2 | head -1 | awk '{printf "read-await-disk1-(ms) %s\n", $11}' #milliseconds spent waiting to read
iostat xvda -xd | tail -2 | head -1 | awk '{printf "write-await-disk1-(ms) %s\n", $12}' #milliseconds spent waiting to write
iostat xvda -xd | tail -2 | head -1 | awk '{printf "disk-util-%%-disk1 %s\n", $14}' #percentage disk utilisation
_xvdb=`df | grep xvdb | wc -l`
_xvdc=`df | grep xvdc | wc -l`
if (( _xvdb > 0 )); then
        iostat xvdb -xd | tail -2 | head -1 | awk '{printf "read-await-disk2-(ms) %s\n", $11}' #milliseconds spent waiting to read
        iostat xvdb -xd | tail -2 | head -1 | awk '{printf "write-await-disk2-(ms) %s\n", $12}' #milliseconds spent waiting to write
        iostat xvdb -xd | tail -2 | head -1 | awk '{printf "disk-util-%%-disk2 %s\n", $14}' #percentage disk utilisation
elif (( _xvdc > 0 )); then
        iostat xvdc -xd | tail -2 | head -1 | awk '{printf "read-await-disk2-(ms) %s\n", $11}' #milliseconds spent waiting to read
        iostat xvdc -xd | tail -2 | head -1 | awk '{printf "write-await-disk2-(ms) %s\n", $12}' #milliseconds spent waiting to write
        iostat xvdc -xd | tail -2 | head -1 | awk '{printf "disk-util-%%-disk2 %s\n", $14}' #percentage disk utilisation
fi

################## network
#grep eth1 /proc/net/dev | awk '{printf "if-eth1-TX-dropped %s\n", $13}'
#cat /sys/class/net/eth0/statistics/rx_bytes
#cat /sys/class/net/eth0/statistics/tx_bytes
ifstat -t10 eth0 | tail -2 | head -1 | awk '{printf "nic-eth0-RX %s\n", $6 }'
ifstat -t10 eth0 | tail -2 | head -1 | awk '{printf "nic-eth0-TX %s\n", $8 }'
ifstat -t10 eth1 | tail -2 | head -1 | awk '{printf "nic-eth1-RX %s\n", $6 }'
ifstat -t10 eth1 | tail -2 | head -1 | awk '{printf "nic-eth1-TX %s\n", $8 }'

#if this is a firebird server
#echo "firebird-processes `pgrep -u firebird | wc -l`"

exit 0
