#!/bin/bash

_CORES=`nproc`
echo "cores-# $_CORES"

################## cpu usage
_cpu=`ps aux  | awk 'BEGIN { sum = 0 }  { sum += $3 }; END { print sum/'$_CORES' }'`
echo "cpu-used-% $_cpu"

################## load average - load of 1.0 means the cpus are fully utilized, warn at 0.8, critical at 1.0
cat /proc/loadavg | awk '{printf("loadavg-01m-%% %s\n", $1*100/'$_CORES' )}' #average load over 1m
cat /proc/loadavg | awk '{printf("loadavg-05m-%% %s\n", $2*100/'$_CORES' )}' #average load over 5m
cat /proc/loadavg | awk '{printf("loadavg-15m-%% %s\n", $3*100/'$_CORES' )}' #average load over 15m

################## storage used % - warning at 80%, critical at 90%
df | grep boot | grep -v tmp | awk '{printf("disk-used-%%-/boot %s\n", $5 )}'
df | grep data | grep -v tmp | awk '{printf("disk-used-%%-/data %s\n", $5 )}'
df | egrep 'rootfs|xvda2|_root' | grep -v tmp | awk '{printf("disk-used-%%-/ %s\n", $5 )}'

################## memory used (free = MemFree + Buffers + Cached)
_mem=` ps aux  | awk 'BEGIN { sum = 0 }  { sum += $4 }; END { print sum }'`
echo "memory-used-% $_mem"

################## disk utlisation & wait times - milliseconds spent waiting to read
iostat xvda -xd | tail -2 | head -1 | awk '{printf "read-await-disk1-(ms) %s\n", $11}'
iostat xvda -xd | tail -2 | head -1 | awk '{printf "write-await-disk1-(ms) %s\n", $12}'
iostat xvda -xd | tail -2 | head -1 | awk '{printf "disk-util-%%-disk1 %s\n", $14}'
_xvdb=`df | grep xvdb | wc -l`
_xvdc=`df | grep xvdc | wc -l`
if (( _xvdb > 0 )); then
        iostat xvdb -xd | tail -2 | head -1 | awk '{printf "read-await-disk2-(ms) %s\n", $11}'
        iostat xvdb -xd | tail -2 | head -1 | awk '{printf "write-await-disk2-(ms) %s\n", $12}'
        iostat xvdb -xd | tail -2 | head -1 | awk '{printf "disk-util-%%-disk2 %s\n", $14}'
elif (( _xvdc > 0 )); then
        iostat xvdc -xd | tail -2 | head -1 | awk '{printf "read-await-disk2-(ms) %s\n", $11}'
        iostat xvdc -xd | tail -2 | head -1 | awk '{printf "write-await-disk2-(ms) %s\n", $12}'
        iostat xvdc -xd | tail -2 | head -1 | awk '{printf "disk-util-%%-disk2 %s\n", $14}'
fi

################## network
ifstat -t10 eth0 | tail -2 | head -1 | awk '{printf "nic-eth0-RX %s\n", $6 }'
ifstat -t10 eth0 | tail -2 | head -1 | awk '{printf "nic-eth0-TX %s\n", $8 }'

################## inode usage - warning at 80%, critical at 90%
df -i | egrep 'rootfs|xvda2|_root' | awk '{printf("inodes-%%-/ %s\n", $5 )}'
df -i | grep data | awk '{printf("inodes-%%-/data %s\n", $5 )}'

exit 0
