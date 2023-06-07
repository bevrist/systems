# qBittorrent Container

> Requires building and loading the `qbittorrent` docker image on the target machine first  
1) Update `docker-compose.yaml` volumes
2) copy config: `mkdir -p /var/qbittorrent/config && cp qBittorrent.conf /var/qbittorrent/config/`  
3) create other dirs: `mkdir -p /var/qbittorrent/downloads`  
4) ENSURE IP IS CORRECT BEFORE STARTING

4) *** `docker-compose up -d` ***  

5) add watched folders and rss feeds after starting for first time
