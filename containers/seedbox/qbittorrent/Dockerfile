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

# podman run --name qbittorrent -d \
# -p 8080:8080 \
# -v $PWD/qbittorrent/config/:/root/.config/qBittorrent/ \
# -v $PWD/qbittorrent/share/:/root/.local/share/qBittorrent/ \
# -v $PWD/qbittorrent/downloads:/mnt \
# qbittorrent

# podman run --name qbittorrent -d \
# -p 8080:8080 \
# -v /var/qbittorrent/config/:/root/.config/qBittorrent/ \
# -v /var/qbittorrent/share/:/root/.local/share/qBittorrent/ \
# -v /mnt/DIRECTORY/downloads:/mnt \
# qbittorrent
