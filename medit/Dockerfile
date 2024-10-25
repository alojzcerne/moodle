FROM central-quay-registry.apps.cdiul-iso.uni-lj.si/moodle/moodle:latest

USER root

EXPOSE 2022

RUN dnf -y update && \
    dnf -y \
       install openssh-server passwd nmap-ncat \
       git nano rsync && \
    dnf clean all
COPY files/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
COPY files/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub
COPY run.sh /usr/local/bin/run.sh
RUN echo 'Port 2022' >> /etc/ssh/sshd_config && \
    rm -rf /var/log/* && \
    chmod +x /usr/local/bin/run.sh

VOLUME ["/medit","/moodle","/var/local/cache"]

CMD ["/usr/local/bin/run.sh"]
