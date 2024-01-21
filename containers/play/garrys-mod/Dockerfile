FROM ubuntu:20.04
# install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install software-properties-common -y \
    && add-apt-repository multiverse \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get upgrade -y \
    && echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && apt-get install lib32gcc-s1 steamcmd -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/games/steamcmd /usr/local/sbin/steamcmd

# update SteamCMD
RUN steamcmd +quit

COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

RUN useradd -ms /bin/bash -d /app gmod
USER gmod

EXPOSE 27005-27015
