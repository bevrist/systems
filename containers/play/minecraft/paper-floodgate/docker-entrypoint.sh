#!/bin/bash
# startup script to copy initial config files into /paper dir and start server
set -e

echo "copying initial paperMC configs:"
ls -la /paper-init
cp -r /paper-init/* /paper

echo echo "starting server: $(date)" | tee ./startLog.txt
java -jar -Xms256m -Xmx4g ./paper.jar --nogui
