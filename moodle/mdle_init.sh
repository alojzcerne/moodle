# /bin/bash
#!/bin/sh
set -e

if ! mkdir -v /moodle/app 2>/dev/null; then

  echo "Already initialized"
  
else

  echo "Installing." | tee /moodle/app/index.html
  
  sleep 20
  
  mkdir /moodle/data 
  chmod +w /moodle/app /moodle/data
    
  ( cd /moodle/app
    echo "Module id moodle-${MOODLE_TEMPLATE_ID}.tar.gz"
    curl -s lib.moodle-sys:8080/moodle_data/moodle-${MOODLE_TEMPLATE_ID}.tar.gz --output /moodle/moodle-${MOODLE_TEMPLATE_ID}.tar.gz
    curl -s lib.moodle-sys:8080/moodle_data/moodle-${MOODLE_TEMPLATE_ID}.xml --output /moodle/moodle-${MOODLE_TEMPLATE_ID}.xml
    tar -xzf /moodle/moodle-${MOODLE_TEMPLATE_ID}.tar.gz
  )
  
  echo "Initializing..." | tee /moodle/app/index.html
    
  php /moodle/app/admin/cli/install.php \
         --agree-license \
         --non-interactive \
         --lang=sl \
         --sitepreset=/moodle/moodle-${MOODLE_TEMPLATE_ID}.xml \
         --dbtype=${MOODLE_DATABASE_TYPE} \
         --dbhost=${MOODLE_DATABASE_HOST} \
         --dbport=${MOODLE_DATABASE_PORT_NUMBER}\
         --dbuser=${MOODLE_DATABASE_USER}\
         --dbname=${MOODLE_DATABASE_NAME}\
         --dbpass=${MOODLE_DATABASE_PASSWORD}\
         --adminuser=${MOODLE_USERNAME} \
         --adminpass=${MOODLE_PASSWORD} \
         --adminemail=${MOODLE_EMAIL} \
         --wwwroot=https://${MOODLE_HOST}/ \
         --fullname="${MOODLE_FULL_NAME}" \
         --shortname="${MOODLE_SHORT_NAME}" \
         --dataroot=/moodle/data \
  | tee /moodle/app/install.txt

  sed -i '/wwwroot/a $CFG->sslproxy = true;'                                     /moodle/app/config.php
  sed -i '/wwwroot/a $CFG->preventexecpath = true;'                              /moodle/app/config.php
  sed -i '/wwwroot/a $CFG->session_handler_class = "\\core\\session\\database";' /moodle/app/config.php
  sed -i '/wwwroot/a $CFG->session_database_acquire_lock_timeout = 120;'         /moodle/app/config.php
  
  mkdir /moodle/temp /moodle/cache
  sed -i '/wwwroot/a $CFG->tempdir = "/moodle/temp";'                            /moodle/app/config.php
  sed -i '/wwwroot/a $CFG->cachedir = "/moodle/cache";'                          /moodle/app/config.php
  sed -i '/wwwroot/a $CFG->localcachedir = "/var/local/cache";'                  /moodle/app/config.php

  if [[ "xxx$MOODLE_TEMPLATE_ID" =~ "xxx01" ]]; then
    sed -i '/wwwroot/a $CFG->theme = "mtul";' /moodle/app/config.php
  fi
  if [[ "xxx$MOODLE_TEMPLATE_ID" =~ "xxx02" ]]; then
    sed -i '/wwwroot/a $CFG->theme = "mtul_slim";' /moodle/app/config.php
  fi

  chmod a=r /moodle/app/config.php
  rm /moodle/app/index.html /moodle/app/install.txt
  rm /moodle/moodle-${MOODLE_TEMPLATE_ID}.tar.gz /moodle/moodle-${MOODLE_TEMPLATE_ID}.xml

fi
