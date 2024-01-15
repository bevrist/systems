#!/bin/bash
export IP="192.168.1.22"
export INSTALL_K3S_VERSION="v1.29.0+k3s1"

# run as root
if [ $USER != "root" ]; then
  echo "must run script as root..."
  exit 1
fi
cd $(dirname "$0")

# setup k3s config
cp k3s-config.yaml /etc/rancher/k3s/config.yaml

# setup containerd config
cat containerd-config.toml | envsubst > /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl

# install k3s
curl -sfL https://get.k3s.io | sh -s -

# setup kubeconfig
mkdir -p /root/.kube
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
