# B-Web Setup Instructions

## setup certbot
go [here](./certbot/credentials/README.md) and follow the readme to create the certbot credentials file.

## setup site
`docker-compose build --pull --no-cache && docker-compose --compatibility up -d` to run site 
> do this once without `-d` or check certbot logs to ensure certs are generated correctly  

connect to internal site at `http://<IP>:8080`
connect to external site at `https://<URL>`

## ssh
ssh to <host>:2220 and all shared folders are at `/var/b-web`
> populate `/var/b-web/share` with ssh_cert.pub and keepass backup
