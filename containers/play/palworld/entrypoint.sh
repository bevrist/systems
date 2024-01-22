#!/bin/bash

set -e

mkdir -p /app/palworld/Pal/Saved/Config/LinuxServer/
cp -f /config/PalWorldSettings.ini /app/palworld/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini

if [ ! -z $UPDATE ] || [ ! -d "/app/palworld" ]; then
  steamcmd +force_install_dir /app/palworld +login anonymous +app_update 2394010 validate +quit
  # fix `steamclient.so: cannot open shared object file: No such file or directory` error
  mkdir -p ~/.steam/sdk64/
  steamcmd +force_install_dir /tmp/steamworks +login anonymous +app_update 1007 +quit
  cp /tmp/steamworks/linux64/steamclient.so ~/.steam/sdk64/
  exit
fi

echo "starting: $(date)" | tee /app/palworld/startLog.txt
/app/palworld/PalServer.sh -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS
