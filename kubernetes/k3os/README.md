# Kube Instructions

# Skaffold:
configure registry for cluster (use registry node IP):  
`skaffold config set default-repo 192.168.86.7:5000`  
`skaffold config set insecure-registries 192.168.86.7:5000`


# K3OS Server
> https://github.com/rancher/k3os  
> Tested with K3OS release `21.5`

## Download
https://github.com/rancher/k3os/releases/latest

## Install
> Update `k3os-config.yaml` to point to private registry  

https://github.com/rancher/k3os#installation  
use `k3os-config.yaml` when installing

## Usage
login through ssh as user `rancher`, kubeconfig can be found at:  
`/etc/rancher/k3s/k3s.yaml`  
> remember to change `server:` address in kubeconfig for connecting from another machine

## Config
some config can be written after bootstrap at:  
`/var/lib/rancher/k3os/config.yaml`


# Storage
## Longhorn
> Only apply longhorn if `local-storage` is disabled.  
`kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.2.3/deploy/longhorn.yaml`  
watch for successful deployment: `kubectl -n longhorn-system get pod`  
make default storage-class: `kubectl patch storageclass longhorn -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'`


# Service Mesh
## Linkerd Install
`linkerd check --pre`
`linkerd install | kubectl apply -f -`
`linkerd check` (may take a few minutes)

## Linkerd Injector
Patch k3s resources (traefik)
`k patch -n kube-system deployment traefik -p='{"spec":{"template":{"metadata":{"annotations":{"linkerd.io/inject":"enabled"}}}}}'`
`k patch -n kube-system daemonsets svclb-traefik -p='{"spec":{"template":{"metadata":{"annotations":{"linkerd.io/inject":"enabled"}}}}}'`
Apply label to each namespace that will use linkerd:  `linkerd.io/inject: enabled`
`k patch ns default -p='{"metadata":{"annotations":{"linkerd.io/inject":"enabled"}}}'`
> Namespaces that need Labels:
> - default
> - longhorn-system
> - cert-manager

## Linkerd Extensions
viz: `linkerd viz install | kubectl apply -f -`
`linkerd viz dashboard`
jaeger: `linkerd jaeger install | kubectl apply -f -`
`linkerd jaeger dashboard`
`linkerd check`


# Registry
## Local Registry
Local registry only meant to run on single node cluster  
Enables in-cluster building and usage of images.
> If multi node cluster, need to configure nodeAffinity  

## Start Registry:
`kubectl apply -f registry.yaml`


# Cert-Manager
## Installation:
`kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml`

## Apply:
refer to the [cert-manager manifest](./cert-manager.yaml).  
create secret first, then apply: `cert-manager.yaml`

## Generate Certificates
`kubectl apply -f cert-manager-certs/`


# Applications
> Search for `# FIXME: update IP` and update relevant IP addresses as needed

---

# DEBUG
## Traefik Dashboard
`kubectl port-forward -n kube-system $(kubectl get pod -n kube-system --selector=app.kubernetes.io/name=traefik -o jsonpath='{.items[0].metadata.name}') 9000:9000`  
visit: http://localhost:9000/dashboard/

## Longhorn Dashboard
`kubectl port-forward -n longhorn-system svc/longhorn-frontend 9999:80`  
visit: http://localhost:9999

## Linkerd Viz & Jaeger
[Check 'Linkerd Extensions' section](##Linkerd-Extensions).
