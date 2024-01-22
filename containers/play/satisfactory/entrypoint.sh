#!/bin/bash

set -e

if [ ! -z $UPDATE ] || [ ! -d "/app/satisfactory" ]; then
  steamcmd +force_install_dir /app/satisfactory +login anonymous +app_update 1690800 -beta public validate +quit
  exit
fi

echo "starting: $(date)" | tee /app/satisfactory/startLog.txt
/app/satisfactory/FactoryServer.sh -log -unattended
