FROM debian:11-slim

# install sshd and subversion
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install locales tini ssh subversion -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen en_US.UTF-8

# configure sshd
COPY --chown=root:root ./ca_key.pub /etc/ssh/ca_key.pub
RUN echo "TrustedUserCAKeys /etc/ssh/ca_key.pub" >> /etc/ssh/sshd_config
RUN echo "ForceCommand /usr/bin/svnserve -t" >> /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN mkdir -p /run/sshd

RUN groupadd svn-writers

# create ssh users
RUN useradd -g svn-writers -ms /bin/bash bevrist
RUN useradd -ms /bin/bash guest

RUN printf '#!/bin/bash  \n\
export GUEST_PASS=${GUEST_PASS:-"guest"}  \n\
echo guest:$GUEST_PASS | chpasswd  \n\
\n\
echo bevrist:$BEVRIST_PASS | chpasswd  \n\
\n\
# copy stored ssh host keys between volume  \n\
cp /ssh-host-keys/* /etc/ssh/ || true  \n\
find /etc/ssh -name "*_host_*" -exec cp {} /ssh-host-keys/ \;  \n\
\n\
/usr/sbin/sshd -De &  \n\
echo "starting svn server"  \n\
/usr/bin/svnserve --daemon --foreground --root /svn  \n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

CMD ["/usr/bin/tini", "-v", "--", "/entrypoint.sh"]

EXPOSE 22

# create repo root directory
RUN mkdir -p /svn
# VOLUME /svn
# ENV GUEST_PASS
# ENV BEVRIST_PASS

#On Container: Create Repository
#   svnadmin create /svn/SampleProject
#   chown -R bevrist:svn-writers /svn/SampleProject
#   chmod -R ug+w /svn/SampleProject

#connect with CLI client:
#edit `~/.subversion/config`:
#   [tunnels]
#   # ssh = $SVN_SSH ssh -q --
#   ssh2222 = $SVN_SSH ssh -p 2222 -q --
#use this to checkout repo
#   svn co svn+ssh2222://bevrist@<IP>/svn/SampleProject dirname-optional

#connect with GUI client
#   svn+ssh://<IP>:2222/svn/SampleProject
