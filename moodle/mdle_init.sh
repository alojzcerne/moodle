#!/bin/bash
set -e

if ! mkdir -v /moodle/app 2>/dev/null; then

  echo "Already initialized"
  
else

  echo "Installing." | tee /moodle/app/index.html
  
  sleep 30; while ! nc -z mdledb-cluster-rw 5432 ; do echo "Waiting for db..."; sleep 15; done
  
  mkdir /moodle/data 
  chmod +w /moodle/app /moodle/data
    
  if [[ $MOODLE_TEMPLATE_ID =~ 'git:' ]]; then
    TID=$(cut -d':' -f2 <<<$MOODLE_TEMPLATE_ID)
    TBD=$(cut -d':' -f3 <<<$MOODLE_TEMPLATE_ID)
    mkdir /moodle/new
    cd /moodle/new
    echo "Module id https://gitlab.utility.cdiul-iso.uni-lj.si/moodle/template-${TID}/app.git#${TBD}" | tee /moodle/app/index.html
    git clone -b ${TBD:-main} --single-branch https://${GIT_CRED_REPO}@gitlab.utility.cdiul-iso.uni-lj.si/moodle/template-${TID}/app.git 
    echo "Module id https://gitlab.utility.cdiul-iso.uni-lj.si/moodle/template-${TID}/admin-presets.git#${TBD}" | tee /moodle/app/index.html
    git clone -b ${TBD:-main} --single-branch https://${GIT_CRED_CONF}@gitlab.utility.cdiul-iso.uni-lj.si/moodle/template-${TID}/admin-presets.git
    mv /moodle/new/app/* /moodle/app
    mv /moodle/new/admin-presets/moodle-${TID}.xml /moodle/moodle-${TID}.xml
    rm -rf /moodle/new
  else
    TID=${MOODLE_TEMPLATE_ID}
    cd /moodle/app
    echo "Module id moodle-${TID}.tar.gz" | tee /moodle/app/index.html
    curl -s lib.moodle-sys:8080/moodle_data/moodle-${TID}.tar.gz --output /moodle/moodle-${TID}.tar.gz
    curl -s lib.moodle-sys:8080/moodle_data/moodle-${TID}.xml --output /moodle/moodle-${TID}.xml
    tar -xzf /moodle/moodle-${TID}.tar.gz
    rm /moodle/moodle-${TID}.tar.gz
  fi
   
  echo "Initializing..." | tee /moodle/app/index.html
    
  php /moodle/app/admin/cli/install.php \
         --agree-license \
         --non-interactive \
         --lang=sl \
         --sitepreset=/moodle/moodle-${TID}.xml \
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

  if [[ "xxx$TID" =~ "xxx01" ]]; then
    sed -i '/wwwroot/a $CFG->theme = "mtul";' /moodle/app/config.php
  fi
  if [[ "xxx$TID" =~ "xxx02" ]]; then
    sed -i '/wwwroot/a $CFG->theme = "mtul_slim";' /moodle/app/config.php
  fi

  chmod a=r /moodle/app/config.php
  rm /moodle/app/index.html /moodle/app/install.txt
  rm /moodle/moodle-${TID}.xml

fi
