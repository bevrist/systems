FROM debian:11-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && sed -i 's/bullseye/testing/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install qbittorrent-nox -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/qbittorrent-nox", "--webui-port=8080"]

EXPOSE 8080

# docker run --rm -it -v $PWD/data:/downloads -p 8080:8080 qbittorrent