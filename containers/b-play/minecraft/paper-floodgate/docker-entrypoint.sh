#!/bin/bash
# startup script to copy initial config files into /paper dir if empty

if [ ! -e "/paper/server-properties" ]; then
  echo "server.properties file not found, copying initial configs"
  cp -r /paper-init/* /paper
fi

java -jar -Xms256m -Xmx4g ./paper.jar --nogui
