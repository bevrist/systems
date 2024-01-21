FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install curl sudo git jq iputils-ping libicu66 wget docker.io -y && rm -rf /var/lib/apt/lists/*

# edit uid and gid to match host system
RUN useradd -u 1001 -ms /bin/bash github-runner
RUN groupmod -g 113 docker
RUN usermod -aG docker github-runner

WORKDIR /actions-runner
RUN chown -R github-runner /actions-runner
USER github-runner

RUN wget https://github.com/actions/runner/releases/download/v2.273.4/actions-runner-linux-x64-2.273.4.tar.gz && tar -xzf actions-runner-linux-x64-2.273.4.tar.gz && rm -f actions-runner-linux-x64-2.273.4.tar.gz

# customize this per repo
RUN ./config.sh --labels docker --url https://github.com/bevrist/workout-site --token ABQBW64ZBPJL3GLRB62H2LK7TZIOK

# TODO add runtime check that docker works here

RUN echo './run.sh ||:; tail -f /dev/null' > ./docker-entrypoint.sh && chmod +x ./docker-entrypoint.sh

CMD ["/bin/bash", "./docker-entrypoint.sh"]
