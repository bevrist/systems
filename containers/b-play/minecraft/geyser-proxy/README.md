# Geyser Standalone Minecraft Proxy

> Remember to set server ip and account password in config.yml

- Run With: 
```
docker build -t geyser . && \
docker run --rm -d --name geyser -p 19132:19132/udp \
    -v /var/b-play/minecraft/geyser/locales:/root/locales \
    -v /var/b-play/minecraft/geyser/logs:/root/logs \
    geyser
```
