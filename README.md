linux-riemann-events
====================

Generate Riemann events for monitoring Linux server performance


Pre-requisites
==

* Bash
* Python
* Berhnard (A simple Python client for Riemann:  https://github.com/banjiewen/bernhard)

To install Bernhard

* yum install python-pip
* pip install bernhard

This project:
* riemann-get-stats.sh - bash script that does most of the work to gather interesting Linux statistics
* riemann.py - Pythin script that takes the output of riemann-get-stats.sh and generates the appropriate Riemann events & sets 
* riemann.sh - simple bash script to manage the above two scripts that should be launched by crontab every minute
* crontab - launch riemann.sh every minute - add this line to your crontab 

```bash *  *  *  *  * /etc/quill/riemann.sh```




Gothcas
--
iptables - riemann events use TCP & UDP port 5555
selinux - may need some configuring


Finally
--
You will obviously need some kind of monitoring to view the Riemann events
http://riemann.io/index.html

