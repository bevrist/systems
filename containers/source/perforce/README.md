# Perforce Server

comment out `./p4dctl.conf.d:/etc/perforce/p4dctl.conf.d` in docker-compose.yml before initialization
comment out `./perforce-data:/perforce-data` in docker-compose.yml before initialization

```
mkdir -p p4dctl.conf.d
mkdir -p dbs
mkdir -p setup
docker-compose build ; docker-compose run -T --rm perforce tar czf - -C /etc/perforce/p4dctl.conf.d  . | tar xvzf - -C p4dctl.conf.d/
```
uncomment ONLY `./p4dctl.conf.d:/etc/perforce/p4dctl.conf.d` in docker-compose.yml
add `P4PORT    =	1666` below the `P4ROOT` line in the file `./p4dctl.conf.d/p4d.template`

change the `CMD` line in Dockerfile to match system user's group: `id -g` ==> `groupadd -g 1234 perf && usermod -u 1234 perforce`

`docker-compose run --rm perforce bash -c "/opt/perforce/sbin/configure-helix-p4d.sh && cp -r /perforce-data /setup"`

- Configure the server name as `master`, 
- ensure that the server root is set to `/perforce-data`, 
- "Perforce Server case-sensitive" `n`,
- and that the port is set to `1666`, 
- also set up superuser credentials for your server during this step.

uncomment `./perforce-data:/perforce-data` in docker-compose.yml

`sudo chown -R bevrist:bevrist . && mv setup/perforce-data .`

`docker-compose up --build -d` 
