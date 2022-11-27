FROM ubuntu:20.04

# install sshd
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install tini ssh -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# configure sshd
COPY --chown=root:root ./ca_key.pub /etc/ssh/ca_key.pub
RUN echo "TrustedUserCAKeys /etc/ssh/ca_key.pub" >> /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# create shared directory for all users
RUN mkdir -p /var/b-web/
RUN groupadd share
RUN chgrp -R share /var/b-web/
RUN chmod -R 2775 /var/b-web/

# create ssh users
RUN useradd -g share -ms /bin/bash bevrist
RUN useradd -g share -ms /bin/bash sshuser
# RUN echo "bevrist:pass" | chpasswd

# RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd
RUN mkdir -p /run/sshd

CMD ["/usr/bin/tini", "-v", "--", "/usr/sbin/sshd", "-De"]

EXPOSE 22
