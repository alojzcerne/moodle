#!/bin/bash

while true; do
  LOGF=/tmp/awstats.log
  NLOGF=awstats.$(date +%Y-%m-%d-%H-%M-%S)-$(hostid).log
  mv ${LOGF} ${LOGF}.new
  kill -HUP 1
  timeout=30
  SECONDS=0 # initialize bash's builtin counter 
  until [ -f ${LOGF} ] || (( SECONDS >= timeout )); do
    sleep 1
  done
  mv ${LOGF}.new /awstats/${NLOGF}.new
  mv /awstats/${NLOGF}.new /awstats/${NLOGF}
  sleep 120
done
