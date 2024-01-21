FROM ubuntu:20.04

# install sshd and subversion
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install tini ssh subversion -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# configure sshd
COPY --chown=root:root ./ca_key.pub /etc/ssh/ca_key.pub
RUN echo "TrustedUserCAKeys /etc/ssh/ca_key.pub" >> /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

RUN groupadd svn

# create ssh users
RUN useradd -g svn -ms /bin/bash bevrist
RUN useradd -ms /bin/bash guest
RUN echo 'bevrist:Apassword1!' | chpasswd
RUN echo 'guest:guest' | chpasswd


RUN mkdir -p /run/sshd
RUN mkdir -p /svn

RUN printf '#!/bin/bash  \n\
/usr/sbin/sshd -De &  \n\
echo "starting svn"  \n\
/usr/bin/svnserve --daemon --foreground --root /svn  \n\
' > /entrypoint.sh && chmod +x /entrypoint.sh

CMD ["/usr/bin/tini", "-v", "--", "/entrypoint.sh"]

EXPOSE 22
# EXPOSE 3690

# VOLUME /svn
# svnadmin create /svn/SampleProject
# chgrp -R svn /svn
# chmod ug+w /svn
# chmod o-w /svn

#connect with client:
# svn+ssh://<IP>:2222/svn/SampleProject
