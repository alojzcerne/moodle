FROM ubi9

RUN dnf config-manager --set-enabled codeready-builder-for-rhel-9-x86_64-rpms && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf -y update && dnf -y install rsyslog rsyslog-gnutls rsyslog-gssapi rsyslog-mysql rsyslog-pgsql rsyslog-relp procps-ng awstats httpd && \
    dnf clean all

COPY rsyslog.sh /usr/local/bin/rsyslog.sh
COPY rotate-log.sh /usr/local/bin/rotate-log.sh
COPY awstats-update.sh /usr/local/bin/awstats-update.sh
COPY httpd-foreground /usr/local/bin/httpd-foreground
COPY container.conf /etc/httpd/conf.d/home.conf
COPY awstats.conf /etc/rsyslog.d/awstats.conf

RUN chmod +rx  /usr/local/bin/rsyslog.sh /etc/rsyslog.d/awstats.conf /usr/local/bin/rotate-log.sh /usr/local/bin/awstats-update.sh /usr/local/bin/httpd-foreground /etc/httpd/conf.d/home.conf && \
    chgrp -R 0 /usr/local/bin/rsyslog.sh /etc/rsyslog.d/awstats.conf /usr/local/bin/rotate-log.sh /usr/local/bin/awstats-update.sh /usr/local/bin/httpd-foreground /etc/httpd/conf.d/home.conf && \
    sed -i "s/Listen 80/Listen 8080/" /etc/httpd/conf/httpd.conf  && \
    httpd -v && \
    mkdir -m 777 -p /run/php-fpm && \
    chmod 777 /run/httpd /var/log/httpd
    
USER 1001

CMD [ "/usr/local/bin/rsyslog.sh" ]
