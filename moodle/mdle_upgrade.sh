#!/bin/bash
set -e

if ! mkdir -v /moodle/update 2>/dev/null; then

  echo "Already updating"
  
else

  echo "Updating" | tee /moodle/app/index.html
  
  chmod +w /moodle/update 
  
  cp -a /moodle/app/config.php /moodle/update/config.php
    
  if [[ $MOODLE_TEMPLATE_ID =~ 'git:' ]]; then
    TID=$(cut -d':' -f2 <<<$MOODLE_TEMPLATE_ID)
    mkdir /moodle/new
    cd /moodle/new
    echo "Module id https://gitlab.utility.cdiul-iso.uni-lj.si/moodle/template-${TID}/app.git"
    ( git clone https://${GIT_CRED_REPO}@gitlab.utility.cdiul-iso.uni-lj.si/moodle/template-${TID}/app.git 
      cd app
      git checkout main
    ) 
    mv /moodle/app /moodle/app.old
    mkdir /moodle/app
    chmod +w /moodle/app
    echo "Updating.." | tee /moodle/app/index.html
    mv /moodle/new/app/* /moodle/app
    rm -rf /moodle/new
  fi
  
  cp -a /moodle/update/config.php  /moodle/app/config.php
    
  rm /moodle/app/index.html

  rm -rf /moodle/app.old &
  
  php /moodle/app/admin/cli/upgrade.php --non-interactive --maintenance | tee /moodle/update.txt

fi
