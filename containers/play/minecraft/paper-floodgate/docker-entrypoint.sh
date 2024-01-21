#!/bin/bash
# startup script to copy initial config files into /paper dir and start server
set -e

echo "copying initial paperMC configs:"
ls -la /paper-init
cp -r /paper-init/* /paper

echo "Starting Server."
java -jar -Xms256m -Xmx4g ./paper.jar --nogui
