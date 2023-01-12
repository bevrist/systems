# Samba container

`docker build -t samba .`

`docker run --rm -it -v $PWD/data:/share -p 137:137/udp -p 138:138/udp -p 139-445:139-445/tcp samba`
