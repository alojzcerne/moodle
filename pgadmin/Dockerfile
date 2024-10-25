FROM ubi9

RUN dnf config-manager --set-enabled codeready-builder-for-rhel-9-x86_64-rpms && \
    rpm -i https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-redhat-repo-2-1.noarch.rpm && \
    dnf -y update && dnf -y install procps-ng httpd pgadmin4-web 

COPY httpd-foreground /usr/local/bin/httpd-foreground
COPY container.conf /etc/httpd/conf.d/home.conf
COPY config_local.py /usr/pgadmin4/web/config_local.py


RUN chmod +rx  /usr/local/bin/httpd-foreground /etc/httpd/conf.d/home.conf /usr/pgadmin4/web/config_local.py && \
    chgrp -R 0 /usr/local/bin/httpd-foreground /etc/httpd/conf.d/home.conf /usr/pgadmin4/web/config_local.py && \
    sed -i "s/Listen 80/Listen 8080/" /etc/httpd/conf/httpd.conf  && \
    httpd -v && \
    mkdir -m 777 -p /run/php-fpm && \
    chmod 777 /run/httpd /var/log/httpd
    
ENV PGADMIN_SETUP_EMAIL     pgadmin@uni-lj.si
ENV PGADMIN_SETUP_PASSWORD  ;5jy$.*[+_C@whb%P@


USER 1001

CMD [ "httpd-foreground" ]
