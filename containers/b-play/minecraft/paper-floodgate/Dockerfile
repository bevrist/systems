FROM debian:12
# install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install wget openjdk-17-jre -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# install PaperMC server
WORKDIR /paper
# update this url to get the version of paper you want
RUN wget -nv -O ./paper.jar https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/102/downloads/paper-1.20.1-102.jar
RUN echo "eula=true" > ./eula.txt

# install Geyser and Floodgate Plugins
RUN mkdir -p ./plugins
RUN wget -nv https://download.geysermc.org/v2/projects/geyser/versions/2.1.1/builds/247/downloads/spigot -O ./plugins/geyser.jar
RUN wget -nv https://download.geysermc.org/v2/projects/floodgate/versions/2.2.2/builds/59/downloads/spigot -O ./plugins/floodgate.jar

# copy config files into init folder
RUN mkdir /paper-init
COPY . /paper-init

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]

EXPOSE 25565 19132/udp
