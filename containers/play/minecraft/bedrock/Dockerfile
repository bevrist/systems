FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install curl unzip -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

RUN useradd -ms /bin/bash -d /app bedrock
USER bedrock

WORKDIR /app
CMD ["/entrypoint.sh"]

EXPOSE 19132/udp
