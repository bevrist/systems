FROM alpine
RUN apk add openssh-server tini
RUN apk add openssh rsync

# configure sshd
COPY --chown=root:root ./ca_key.pub /etc/ssh/ca_key.pub
RUN echo "TrustedUserCAKeys /etc/ssh/ca_key.pub" >> /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# create ssh users
RUN addgroup share
RUN adduser -DG share bevrist
RUN echo "bevrist:pass" | chpasswd

RUN printf "SSH SHARE SERVER\n\
- /www/brettevrist.net/share\n\
- /www/brettevrist.net/ios\n\n\
" > /etc/motd

RUN /usr/bin/ssh-keygen -A

RUN printf '#!/bin/sh  \n\
# copy stored ssh host keys between volume  \n\
cp /ssh-host-keys/* /etc/ssh/ || true  \n\
find /etc/ssh -name "*_host_*" -exec cp {} /ssh-host-keys/ \;  \n\
\n\
/usr/sbin/sshd -De  \n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

CMD ["/sbin/tini", "-v", "--", "/entrypoint.sh"]

EXPOSE 22
# TODO run ssh on a high port number as non-root user
