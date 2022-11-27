# Run github runner

## Build
`docker build -t github-runner[1-3] .`  

## Create github-runner user on host
`useradd -ms /bin/bash github-runner`  
`sudo usermod -aG docker github-runner`  

## Edit Dockerfile uid, gid, and runner token
`id -u github-runner`  
`getent group docker | cut -d: -f3`  

## Run
`docker run -d --restart always -v /var/run/docker.sock:/var/run/docker.sock github-runner`  

## docker-compose
`docker-compose up -d`  
