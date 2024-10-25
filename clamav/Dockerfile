FROM ubi9

RUN dnf -y update && dnf -y install procps-ng && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf -y install clamav-server clamav-data clamav-update clamav-filesystem clamav

RUN sed -i -e "s/^#TCPSocket/TCPSocket/" /etc/clamd.d/scan.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN  chmod +x /usr/local/bin/entrypoint.sh && \
     sed -i -e "s/^#TCPSocket/TCPSocket/"  /etc/clamd.d/scan.conf && \
     sed -i '/MaxFileSize/a MaxFileSize 2000M' /etc/clamd.d/scan.conf && \
     sed -i '/MaxScanSize/a MaxScanSize 2000M' /etc/clamd.d/scan.conf && \
     sed -i '/StreamMaxLength/a StreamMaxLength 2000M' /etc/clamd.d/scan.conf && \
     chgrp -R 0 /var/lib/clamav /usr/local/bin/entrypoint.sh && \
     chmod -R g=u /etc/freshclam.conf /etc/clamd.d/scan.conf /var/lib/clamav /usr/local/bin/entrypoint.sh && \
     rm -f /var/lib/clamav/*
     
USER 1001

EXPOSE 3310

VOLUME ["/var/lib/clamav"]

CMD ["entrypoint.sh"]
