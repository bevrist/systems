#!/bin/bash

set -e

mkdir -p /app/gmod/garrysmod/cfg/
mkdir -p /app/gmod/garrysmod/lua/autorun/server/

cp -f /config/mount.cfg /app/gmod/garrysmod/cfg/mount.cfg
cp -f /config/server.cfg /app/gmod/garrysmod/cfg/server.cfg

cp -f /config/AddWorkshop.lua /app/gmod/garrysmod/lua/autorun/server/AddWorkshop.lua

if [ ! -z $UPDATE ] || [ ! -d "/app/gmod" ]; then
  steamcmd +force_install_dir /app/css +login anonymous +app_update 232330 validate +quit
  steamcmd +force_install_dir /app/gmod +login anonymous +app_update 4020 validate +quit
  exit
fi

/app/gmod/srcds_run -console -game garrysmod +maxplayers 50 +host_workshop_collection 779196126 -authkey 759CFCE4302E24D8F83A9E078FEF35A7 +gamemode murder +map mu_abandoned
