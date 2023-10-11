#!/bin/bash
VM_NAME=bretts-podman-vm

echo $VM_NAME

# create machine if it doesnt exist
if [ $(podman machine list | grep -P "^${VM_NAME}\*?\s" | wc -l) -ne 1 ]; then
  podman machine init ${VM_NAME} \
    --volume ${HOME}:${HOME} \
    --cpus 2 \
    --memory 2048
    # --image-path stable
fi

# Start podman vm
podman machine start ${VM_NAME}
