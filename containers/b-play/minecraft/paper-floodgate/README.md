# Minecraft Paper Server

## To start server:
`docker-compose up -d --build`

## To connect to server terminal:
`docker attach --detach-keys=ctrl-a <MINECRAFT-SERVER-CONTAINER>`

## To update server version:
- bump server version download in [Dockerfile](./Dockerfile)
- check if any configuration file have changed with new version
