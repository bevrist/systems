FROM debian:12
# install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install wget openjdk-17-jre -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# install rcon-cli
RUN mkdir -p /tmp/rcon && cd /tmp/rcon \
    && wget -nv https://github.com/itzg/rcon-cli/releases/download/1.6.2/rcon-cli_1.6.2_linux_amd64.tar.gz \
    && tar -xzf rcon-cli_1.6.2_linux_amd64.tar.gz \
    && mv /tmp/rcon/rcon-cli /usr/sbin/rcon \
    && rm -rf /tmp/rcon
WORKDIR /root
RUN printf 'host: localhost \nport: 25575 \npassword: mypassword \n' > .rcon-cli.yaml

# install PaperMC server
WORKDIR /root
# update this url to get the version of paper you want
RUN wget -nv -O paper.jar https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/102/downloads/paper-1.20.1-102.jar
RUN echo "eula=true" > eula.txt

# install Geyser and Floodgate Plugins
WORKDIR /root/plugins
RUN wget -nv https://download.geysermc.org/v2/projects/geyser/versions/2.1.1/builds/247/downloads/spigot
RUN wget -nv https://download.geysermc.org/v2/projects/floodgate/versions/2.2.2/builds/59/downloads/spigot
RUN mkdir -p /root/plugins/Geyser-Spigot
COPY ./geyser-config.yml /root/plugins/Geyser-Spigot/config.yml

# copy config files into folder
WORKDIR /root
COPY . .

CMD ["/usr/bin/java", "-Xms1g", "-Xmx8g", "-jar", "./paper.jar", "nogui"]

EXPOSE 25565 19132/udp
