FROM ubi9

RUN dnf config-manager --set-enabled codeready-builder-for-rhel-9-x86_64-rpms && \
    dnf -y module enable postgresql:16 && \
    rpm -i https://ftp.postgresql.org/pub/pgadmin/pgadmin4/yum/pgadmin4-redhat-repo-2-1.noarch.rpm && \
    dnf -y update --nogpgcheck && \
    dnf -y install procps-ng httpd postgresql --nogpgcheck && \
    dnf -y install pgadmin4-web --nogpgcheck

COPY httpd-foreground /usr/local/bin/httpd-foreground
COPY container.conf /etc/httpd/conf.d/home.conf

RUN chmod +rx  /usr/local/bin/httpd-foreground /etc/httpd/conf.d/home.conf && \
    chgrp -R 0 /usr/local/bin/httpd-foreground /etc/httpd/conf.d/home.conf && \
    sed -i "s/Listen 80/Listen 8080/" /etc/httpd/conf/httpd.conf  && \
    dnf clean all && \
    httpd -v && \
    mkdir -m 777 -p /run/php-fpm && \
    chmod 777 /run/httpd /var/log/httpd

ENV PGADMIN_SETUP_EMAIL     pgadmin@uni-lj.si
ENV PGADMIN_SETUP_PASSWORD  ;5jy$.*[+_C@whb%P@

USER 1001

CMD [ "httpd-foreground" ]
