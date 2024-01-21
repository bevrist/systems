FROM ubuntu:20.04
# install dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install wget openjdk-16-jre -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# install Geyser Standalone
WORKDIR /root
RUN wget -nv https://ci.opencollab.dev//job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/target/Geyser.jar
COPY ./config.yml .

CMD ["/usr/bin/java", "-Xms1g", "-jar", "Geyser.jar"]

EXPOSE 19132
