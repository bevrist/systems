# Perforce Server

comment out `./p4dctl.conf.d:/etc/perforce/p4dctl.conf.d` in docker-compose.yml before initialization
comment out `./perforce-data:/perforce-data` in docker-compose.yml before initialization

```
mkdir -p p4dctl.conf.d
mkdir -p perforce-data
mkdir -p dbs
mkdir -p setup
docker-compose run -T --rm perforce tar czf - -C /etc/perforce/p4dctl.conf.d  . | tar xvzf - -C p4dctl.conf.d/
```
uncomment `./p4dctl.conf.d:/etc/perforce/p4dctl.conf.d` in docker-compose.yml
add `P4PORT    =	1666` below the `P4ROOT` line

change the `CMD` line in Dockerfile to match system user and group: `id -u; id -g` : `usermod -u 501 -g 20 perforce`

`docker-compose run --rm perforce bash -c "/opt/perforce/sbin/configure-helix-p4d.sh && cp -r /perforce-data /setup"`

- Configure the server name as `master`, 
- ensure that the server root is set to `/perforce-data`, 
- and that the port is set to `1666`. 
- also set up superuser credentials for your server during this step.

uncomment `./perforce-data:/perforce-data` in docker-compose.yml

`mv setup/perforce-data/* perforce-data`

`docker-compose up --build -d` 
