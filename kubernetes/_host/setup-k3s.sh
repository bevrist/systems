#!/bin/bash
set -e

# k3s install variables
# https://github.com/k3s-io/k3s/releases/latest
export INSTALL_K3S_VERSION="v1.29.0+k3s1"

# export IP="$(ip a | grep -oP 'inet\s\S+' | grep -oP '192\.168\.\d+\.\d+')"  # k3s host ip address
export IP="k3s"  # use magicDNS

# run as root
if [ $USER != "root" ]; then
  echo "must run script as root..."
  exit 1
fi
cd $(dirname "$0")

# setup k3s config
mkdir -p /etc/rancher/k3s/
cp k3s-config.yaml /etc/rancher/k3s/config.yaml

# setup containerd config
mkdir -p /var/lib/rancher/k3s/agent/etc/containerd/
cat containerd-config.toml | envsubst > /var/lib/rancher/k3s/agent/etc/containerd/config.toml.tmpl

# install k3s (env vars above will be utilized)
wget -qO- https://get.k3s.io | sh -s -

# setup kubeconfig
mkdir -p /root/.kube
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config
