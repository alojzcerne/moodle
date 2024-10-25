FROM ubi9

RUN dnf -y update && yum install -y httpd procps-ng postfix ghostscript poppler-utils glibc-all-langpacks graphviz && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf -y install http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y && \
    dnf -y module enable php:remi-8.2 && \
    dnf -y install php php-{fpm,curl,pgsql,xml,ldap,soap,bcmath,bz2,intl,gd,mbstring,zip,mysqlnd,sodium,tidy} php-pecl-yaml && \
    dnf -y install http://rpmfind.net/linux/centos-stream/9-stream/CRB/x86_64/os/Packages/aspell-0.60.8-8.el9.x86_64.rpm aspell-sl && \
    dnf -y install clamav

COPY httpd-foreground /usr/local/bin/httpd-foreground
COPY mdle_cj.sh /usr/local/bin/mdle_cj.sh
COPY mdle_init.sh /usr/local/bin/mdle_init.sh
COPY container.conf /etc/httpd/conf.d/home.conf
COPY container.ini /etc/php.d/99-home.ini
COPY 00-mpm.conf /etc/httpd/conf.modules.d/00-mpm.conf
COPY scan.conf /etc/clamd.d/scan.conf

RUN chmod +x /usr/local/bin/httpd-foreground /usr/local/bin/mdle_cj.sh /usr/local/bin/mdle_init.sh && \
    chmod -R g=u /usr/local/bin/httpd-foreground /usr/local/bin/mdle_cj.sh /usr/local/bin/mdle_init.sh /etc/httpd/conf.d/home.conf /etc/php.d/99-home.ini /etc/httpd/conf.modules.d/00-mpm.conf /etc/clamd.d/scan.conf && \
    sed -i "s/Listen 80/Listen 8080/" /etc/httpd/conf/httpd.conf && \
    rm -rf /var/lib/clamav/* && \
    dnf clean all && \
    httpd -v && \
    mkdir -m 777 -p /run/php-fpm && \
    chmod 777 /run/httpd /var/log/httpd /run/php-fpm

USER 1001

VOLUME ["/moodle","/var/local/cache"]

EXPOSE 8080

CMD ["httpd-foreground"]
