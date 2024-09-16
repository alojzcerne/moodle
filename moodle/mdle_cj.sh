# /bin/bash

while true; do 
  if [  -d /moodle/app  ]; then
    if [ ! -f /moodle/app/index.html ]; then
      php /moodle/app/admin/cli/cron.php > /dev/null 
    fi
  fi
  sleep 1
done;
