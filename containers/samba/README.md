# Samba container

## Compose
`docker-compose build --pull --no-cache`
`docker-compose up -d`

## Manual Build
`docker build -t samba .`
`docker run --rm -it -v $PWD/data:/share -p 137:137/udp -p 138:138/udp -p 139:139 -p 445:445 samba`
