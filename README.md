# Setup Instructions

### [Diagram Link](https://jamboard.google.com/d/1pkwU_UkmgpaK4JpXp_8qj7HtILJte2UyIiuDW-216mk/edit?usp=sharing)

## Setup Docker
`systemctl enable docker` so docker starts on boot  

## Setup Site
`docker-compose down && docker-compose --compatibility up -d --build` to run site  
connect to internal site at `http://<IP>:8080`  
connect to external site at `https://<URL>`  

set up `/ios` and `/share` folders on host at `/var/b-web`  

TODO: set up cronjob for docker rebuilding site daily `docker-compose build --no-cache --pull && docker-compose --compatibility up -d`   

## SSH
ssh to pull files from `/var/b-web/<folder>`
