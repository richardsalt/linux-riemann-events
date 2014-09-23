linux-riemann-events
==
Generate Riemann events for monitoring Linux server performance

We run a large number of Linux VM's and couldn't find any ready made scripts for generating the Riemann events to monitor their performance, so we rolled our own. Publishing it here in case its of any use to anyone out there. 

###Pre-requisites
--

* Bash
* Python
* Berhnard (A simple Python client for Riemann:  https://github.com/banjiewen/bernhard)

To install Bernhard

* yum install python-pip
* pip install bernhard

###This project

| Filename             | Details |
| -------------        | ------------- |
| riemann-get-stats.sh | bash script that does most of the work to gather interesting Linux statistics  |
| riemann.py  | Python script that takes the output of riemann-get-stats.sh and generates the appropriate Riemann events  |
| riemann.sh  | bash script to run the above two scripts in the correct order every 10 seconds  |

Create a directory such as /etc/linux-riemann-events & put these 3 scripts into it.
Then add this to your crontab to launch riemann.sh every minute (see crontab-append.sh) ...

``` *  *  *  *  * /etc/linux-riemann-events/riemann.sh```


###Gothcas

* iptables - riemann events use TCP & UDP port 5555
* selinux - may need some configuring


###Finally

You will obviously need some kind of monitoring to view the Riemann events
http://riemann.io/index.html

