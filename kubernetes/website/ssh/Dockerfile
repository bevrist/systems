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

RUN printf "SSH SHARE SERVER\n- /www/brettevrist.net/share\n- /www/brettevrist.net/ios\n\n" > /etc/motd

RUN /usr/bin/ssh-keygen -A
CMD ["/sbin/tini", "-v", "--", "/usr/sbin/sshd", "-De"]

EXPOSE 22
