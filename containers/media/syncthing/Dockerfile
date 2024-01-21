FROM ubuntu:20.04

# install sshd
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install tini syncthing -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# USER syncthing

CMD ["/usr/bin/tini", "-v", "--", "/usr/bin/syncthing"]

EXPOSE 8384 22000/tcp 22000/udp 21027/UDP
