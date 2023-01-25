FROM ubuntu:20.04

# install sshd and subversion
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install locales tini ssh subversion -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8

# configure sshd
COPY --chown=root:root ./ca_key.pub /etc/ssh/ca_key.pub
RUN echo "TrustedUserCAKeys /etc/ssh/ca_key.pub" >> /etc/ssh/sshd_config
RUN echo "ForceCommand /usr/bin/svnserve -t" >> /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

RUN groupadd svn-writers

# create ssh users
RUN useradd -g svn-writers -ms /bin/bash bevrist
RUN useradd -ms /bin/bash guest
# TODO make passwords env vars set at startup
RUN echo 'bevrist:Apassword1!' | chpasswd
RUN echo 'guest:guest' | chpasswd

RUN mkdir -p /run/sshd
RUN mkdir -p /svn

RUN printf '#!/bin/bash  \n\
/usr/sbin/sshd -De &  \n\
echo "starting svn server"  \n\
/usr/bin/svnserve --daemon --foreground --root /svn  \n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

CMD ["/usr/bin/tini", "-v", "--", "/entrypoint.sh"]

EXPOSE 22

# VOLUME /svn

#On Container: Create Repository
#   svnadmin create /svn/SampleProject
#   chown -R bevrist:svn-writers /svn/SampleProject
#   chmod -R ug+w /svn/SampleProject

#connect with CLI client:
#edit `~/.subversion/config`:
#   [tunnels]
#   # ssh = $SVN_SSH ssh -q --
#   ssh2500 = $SVN_SSH ssh -p 2500 -q --
#use this to checkout repo
#   svn co svn+ssh2500://bevrist@<IP>/svn/SampleProject dirname-optional

#connect with GUI client
#   svn+ssh://<IP>:2500/svn/SampleProject
