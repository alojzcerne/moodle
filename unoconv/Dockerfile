FROM ubi9

RUN dnf -y update && dnf -y install procps-ng && \
    dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf -y install unoconv

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN  chgrp -R 0 /usr/local/bin/entrypoint.sh && chmod +xr /usr/local/bin/entrypoint.sh && mkdir -m 777 /work

USER 1001

ENV HOME /work

WORKDIR /work

EXPOSE 2002
VOLUME ["/work"]

CMD ["entrypoint.sh"]
