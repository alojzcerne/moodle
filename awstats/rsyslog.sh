#!/bin/sh
set -e

/usr/local/bin/rotate-log.sh &

/usr/local/bin/awstats-update.sh &

source /etc/sysconfig/rsyslog
exec /usr/sbin/rsyslogd -n $SYSLOGD_OPTIONS
