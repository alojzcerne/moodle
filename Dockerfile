FROM ubi9

RUN dnf -y update && yum install -y httpd

# RUN dnf -y module enable php:8.2
# RUN dnf -y install php php-{fpm,curl,pgsql,xml,ldap,soap,bcmath,bz2,intl,gd,mbstring,zip} php-mysqlnd

# https://access.redhat.com/solutions/5284161
RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf -y install http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y && \
    dnf -y module enable php:remi-8.3 && \
    dnf -y install git php php-{fpm,curl,pgsql,xml,ldap,soap,bcmath,bz2,intl,gd,mbstring,zip} php-mysqlnd php-sodium
     
# iconv mbstring curl openssl tokenizer soap ctype zip zlib gd simplexml spl pcre dom xml xmlreader intl json hash fileinfo sodium exif memory_limit file_uploads opcache.enable mbstring yaml exif xsl
     
     
COPY httpd-foreground /usr/local/bin/httpd-foreground
COPY container.conf /etc/httpd/conf.d/home.conf
COPY container.ini /etc/php.d/99-home.ini
COPY 00-mpm.conf /etc/httpd/conf.modules.d/00-mpm.conf

RUN mkdir /moodle /moodle/app /moodle/data && chmod +w /moodle/app /moodle/data

COPY moodle.tar.gz /moodle-01.tar.gz

RUN chmod +r /moodle-01.tar.gz && \
    chgrp -R 0 /moodle && chmod -R g=u /moodle && \
    chmod +x /usr/local/bin/httpd-foreground && \
    chmod -R g=u /usr/local/bin/httpd-foreground /etc/httpd/conf.d/home.conf /etc/php.d/99-home.ini /etc/httpd/conf.modules.d/00-mpm.conf && \
    sed -i "s/Listen 80/Listen 8080/" /etc/httpd/conf/httpd.conf  && \
    httpd -v
#   dnf clean all

ENV APACHE_RUN_DIR /var/run/apache2

RUN mkdir -m 777 -p /run/php-fpm
RUN chmod 777 /run/httpd /var/log/httpd /run/php-fpm

RUN dnf -y install procps-ng

USER 1001

VOLUME [ "/moodle"]

EXPOSE 8080

CMD ["httpd-foreground"]

