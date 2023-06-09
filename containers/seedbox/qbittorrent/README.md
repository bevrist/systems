# qBittorrent Container

> Requires building and loading the `qbittorrent` docker image on the target machine first  
1) copy config: `mkdir -p /var/qbittorrent/config && cp qBittorrent.conf /var/qbittorrent/config/`  
2) create store directory: `mkdir -p /var/qbittorrent/share`
3) ENSURE IP IS CORRECT BEFORE STARTING  
4) Update container volume mounts and start container (command in Dockerfile)  

5) `podman generate systemd --new --name qbittorrent > /etc/systemd/system/qbittorrent.service`  
6) update systemd service to wait for wireguard and SMB mounts  
7) `systemctl daemon-reload && systemctl enable qbittorrent`

8) add watched folders and rss feeds  
