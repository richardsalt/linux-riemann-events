#!/usr/bin/python

##################################################
# this script is launched by riemann.sh          #
# dependencies: riemann.sh, riemann-get-stats.sh #
##################################################

import bernhard
import subprocess

c = bernhard.Client(host = 'monitor1')

_thisServer = subprocess.check_output(['uname', '-n']).replace('\n','')

#linux machine stats
#subprocess.call('/etc/quill/riemann-get-stats.sh >/tmp/riemann-stats', shell=True) #now runs in riemann.sh
lines = [line.rstrip() for line in open('/tmp/riemann-stats')]
for item in lines:
        _key, _trash, _value = item.partition(' ')
        _value = _value.replace('%', '')
        _key = _key.replace('-', ' ')
        #cater fot ifstat's variable metric output
        if _value.endswith('K'):
                _value = float(_value[:-1]) / 1024
        else:
                if _value.endswith('M'):
                        _value = float(_value[:-1]) / 1024 / 1024
        _state = 'ok'
        if "%" in _key:
                if float(_value) > 90:
                        _state = 'critical'
                else:
                        if float(_value) > 80:
                                _state = 'warning'
        #print (_key, float(_value), _state)
        c.send({'host':_thisServer,'service':_key,'metric': float(_value),'state':_state,'tags':["linux"] })


