#!/bin/sh
# This is an init script, intended for Debian-like Linux systems.
#
# To install to run at startup, add the following line to /etc/rc.local:
#   /bin/su buzzer -l -c /home/buzzer/buzzer-app/buzzer-init.sh
# -or-
# Run crontab -e as user 'buzzer' and add:
#   @reboot /home/buzzer/buzzer-app/buzzer-init.sh
#
# To interact with the running instance of the buzzer app, do this:
#   sudo su - buzzer
#   script -q -c 'screen -x buzz' /dev/null
# (detach from screen with "ctrl-A d")

cd /home/$LOGNAME/buzzer-app
/usr/bin/screen -S buzz -d -m env SINATRA_ENV=deployment rackup -E deployment
