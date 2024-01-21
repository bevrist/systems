FROM ubuntu:20.04
# install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install wget openjdk-16-jre -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# install rcon-cli
RUN mkdir -p /tmp/rcon && cd /tmp/rcon \
    && wget -nv https://github.com/itzg/rcon-cli/releases/download/1.4.8/rcon-cli_1.4.8_linux_amd64.tar.gz \
    && tar -xzf rcon-cli_1.4.8_linux_amd64.tar.gz \
    && mv /tmp/rcon/rcon-cli /usr/sbin/rcon \
    && rm -rf /tmp/rcon
WORKDIR /root
RUN printf 'host: localhost \nport: 25575 \npassword: mypassword \n' > .rcon-cli.yaml

# install PaperMC server
WORKDIR /root
# bump this version number to match the minecraft version you want to run
RUN wget -nv -O paper.jar https://papermc.io/api/v1/paper/1.17.1/latest/download
RUN echo "eula=true" > eula.txt

# copy config files into folder
WORKDIR /root
COPY . .

CMD ["/usr/bin/java", "-Xms1g", "-Xmx8g", "-jar", "./paper.jar", "nogui"]

EXPOSE 25565
