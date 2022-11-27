# Minecraft Paper Server

## To connect to server terminal:
- `docker exec -it <MINECRAFT-SERVER-CONTAINER> rcon`

## To update server version:
- bump server version download in [Dockerfile](./Dockerfile)
- verify server.properties has not updated

# TODO:
- make note about docker cpu/memory limits somewhere
- edit RUN command in dockerfile to work with memory limits
- edit dockerfile to use new files
- edit dockerfile to detect when changes to config files happens and alert on startup
