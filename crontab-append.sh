crontab -l >/tmp/crontab
echo "* * * * * /etc/linux-riemann-events/riemann.sh" >>/tmp/crontab
crontab /tmp/crontab
