#!/bin/bash

REPO="192.168.86.7:5000"

for file in $(find . -name Dockerfile); do
  NAME=$(head -1 $file|cut -d " " -f 2)
  CONTEXT=$(dirname $file)
  podman build -t $REPO/$NAME -f $file $CONTEXT
  podman push $REPO/$NAME --tls-verify=0
done

# run kubernetes rollout restart on all deployments
