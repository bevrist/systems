FROM ubuntu:20.04

# install subversion
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install tini subversion -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd svn

# create ssh users
RUN useradd -g svn -ms /bin/bash bevrist
RUN useradd -ms /bin/bash guest
# RUN echo 'bevrist:Apassword1!' | chpasswd
# RUN echo 'guest:guest' | chpasswd

RUN printf 'bevrist = rw  \n\
guest = r  \n\
' > /authz


RUN mkdir -p /run/sshd
RUN mkdir -p /svn

CMD ["/usr/bin/tini", "-v", "--", "/usr/bin/svnserve", "--daemon", "--foreground", "--root", "/svn"]

EXPOSE 3690

# VOLUME /svn
# svnadmin create /svn/SampleProject
# cp /authz /svn/SampleProject/conf/authz

#connect with client:
# svn://<IP>/svn/SampleProject
