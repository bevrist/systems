FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install qbittorrent-nox -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*


# create qBittorrent config
RUN mkdir -p /torrents/
RUN mkdir -p /downloads/incomplete/
# RUN mkdir -p ~/.config/qBittorrent/
# RUN printf '[AutoRun] \n\
# enabled=false \n\
# program= \n\
#  \n\
# [LegalNotice] \n\
# Accepted=true \n\
#  \n\
# [Preferences] \n\
# Connection\\UPnP=false \n\
# Connection\\PortRangeMin=6881 \n\
# Downloads\\SavePath=/downloads/ \n\
# Downloads\\TempPath=/downloads/incomplete/ \n\
# WebUI\\Address=* \n\
# WebUI\\ServerDomains=* \n\
# ' > ~/.config/qBittorrent/qBittorrent.conf
COPY qBittorrent.conf ~/.config/qBittorrent/qBittorrent.conf

CMD cat ~/.config/qBittorrent/qBittorrent.conf
# CMD ["/usr/bin/qbittorrent-nox", "--webui-port=8080"]

EXPOSE 8080
