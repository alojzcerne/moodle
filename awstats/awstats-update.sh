#!/bin/bash

NFILES=1000
INDEX=/awstats/app/index.html

while true; do
  if ! mkdir -v /awstats/input 2>/dev/null; then
    echo "In progress"
  else
    mkdir /awstats/config /awstats/data /awstats/app && exit 0
    mkdir /awstats/log 
    mv $(find /awstats -name awstats.20\* | sort | head -$NFILES) /awstats/input
    cat /awstats/input/* | sort | sed -En 's/.*moodle.* (\{"@.*\})$/\1/p'  | jq -r '. | select(.kubernetes.namespace_name | startswith("mdl-")) | select(.kubernetes.pod_name | startswith("mdleapp-")) .kubernetes.namespace_name' | sort | uniq > /awstats/input/awstats.ns
    for NS in $(cat /awstats/input/awstats.ns); do
      cat /awstats/input/* | sort | sed -En 's/.*moodle.* (\{"@.*\})$/\1/p'  | jq -r '. | select(.kubernetes.namespace_name=="'${NS}'") | select(.kubernetes.pod_name | startswith("mdleapp-")) .message' > /awstats/log/access_log-${NS}
    done
    cat /awstats/input/* | sort | sed -En 's/.*moodle.* (\{"@.*\})$/\1/p'  | jq -r '. | select(.kubernetes.namespace_name | startswith("mdl-")) | select(.kubernetes.pod_name | startswith("mdleapp-")) .message' > /awstats/log/access_log-all
    for LF in all $(ls -1 /awstats/log | sed -nE 's/access_log-(.*)/\1/p'); do
      sed "s!/var/log/httpd/access_log!/awstats/log/access_log-${LF}!g" /etc/awstats/awstats.model.conf \
          | sed "s/localhost.localdomain/access_log-${LF}/" \
          | sed "s/DNSLookup=2/DNSLookup=1/" \
          | sed "s!/var/lib/awstats!/awstats/data!" \
          > /awstats/config/awstats.${LF}.conf
    done
    /usr/share/awstats/tools/awstats_updateall.pl -configdir=/awstats/config now
    echo > $INDEX
    for CF in $(ls -1 /awstats/config/ | sort | sed -nE "s/awstats.(.+).conf/\1/p" ); do
      echo '<a href="/awstats/awstats.pl?config='$CF'">'$CF'</a><br>' >> $INDEX
    done
    rm -rf /awstats/input /awstats/log
  fi
  sleep 300
done
