#!/bin/bash

set -e

# install minecraft bedrock server
if [ ! -z $UPDATE ] || [ ! -f "/app/bedrock_server" ]; then
  cd /tmp
  ## get specific Server Version
  # RUN curl -O https://minecraft.azureedge.net/bin-linux/bedrock-server-1.17.11.01.zip
  ## get latest Minecraft Bedrock Server
  curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.33 (KHTML, like Gecko) Chrome/90.0.123.212 Safari/537.33" https://minecraft.net/en-us/download/server/bedrock/ -o /tmp/minecraft-download.html
  grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' /tmp/minecraft-download.html > /tmp/minecraft-link.txt
  # only update if version is out of date
  if ! cmp -s /tmp/minecraft-link.txt /app/minecraft-link.txt ; then
    curl -O $(cat /tmp/minecraft-link.txt)
    cd /app
    cp /tmp/minecraft-link.txt /app/minecraft-link.txt
    unzip -o /tmp/bedrock-server-*.zip -d .
  else
    echo "Bedrock server already up to date."
  fi
  exit
fi

cd /app
cp -f /config/* ./

echo $(date) Docker Image Minecraft Version: $(grep -o "bedrock-server.*" /app/minecraft-link.txt) | tee ./bedrock_server/startLog.txt
LD_LIBRARY_PATH=. ./bedrock_server
