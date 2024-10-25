#!/bin/sh
set -e

tagfil=/moodle/app

OWN=$(stat -c '%U' $tagfil)
OWI=$(stat -c '%u' $tagfil)
GRN=$(stat -c '%G' $tagfil)
GRI=$(stat -c '%g' $tagfil)
if [ "$GRN" != "moodle" ]; then
  groupadd moodle -g $GRI
fi
if [ "$OWN" != "devel" ]; then
  useradd devel -u $OWI -G 0 -g $GRI -d /medit/devel
  echo -e "$(cat /etc/devel_pass)\n$(cat /etc/devel_pass)" | (passwd --stdin devel)
  if mkdir -vp /medit/devel/.ssh 2>/dev/null; then
    cp -vn /etc/ssh/authorized_keys /medit/devel/.ssh
  fi
fi

chown -R devel.moodle /medit/devel/.ssh /var/local/cache

touch /var/log/lastlog
chgrp utmp /var/log/lastlog
chmod 664 /var/log/lastlog

exec /usr/sbin/sshd -D -e
