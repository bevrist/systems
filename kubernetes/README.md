# K3S Deployment

## Fresh Install
1) update vars at the top of `_host/setup-k3s.sh`
2) run `_host/setup-k3s.sh`
3) get kubeconfig from k3s `/etc/rancher/k3s/k3s.yaml`  
> remember to update `server` to point to node ip
4) install local registry `kubectl apply -f local-registry/local-registry.yaml`
5) install cert manager  
  1) create credentials secret for cert manager, instructions at `cert-manager/cert-manager.yaml`
  2) install cert manager `kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml`
  3) configure cert-manager `kubectl apply -f manifests/cert-manager.yaml`
  4) generate certs `kubectl apply -f manifests/cert-manager-certs/`
6) deploy website `cd website/; skaffold run --cache-artifacts=false`
> search for `#! NOTE: update IP` and update relevant IP addresses as needed for external applications
6) install all other kube apps


---
# DEBUG
## Skaffold:
configure registry for cluster (use registry node IP):  
`skaffold config set default-repo <K3S-IP>:5000`  
`skaffold config set insecure-registries <K3S-IP>:5000`
`skaffold config set local-cluster true`

## Traefik Dashboard
`kubectl port-forward -n kube-system $(kubectl get pod -n kube-system --selector=app.kubernetes.io/name=traefik -o jsonpath='{.items[0].metadata.name}') 9000:9000`  
visit: http://localhost:9000/dashboard/


---
# Extra Software 
## Storage
### Longhorn
> Only apply longhorn if `local-storage` is disabled.  
`kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.2.3/deploy/longhorn.yaml`  
watch for successful deployment: `kubectl -n longhorn-system get pod`  
make default storage-class: `kubectl patch storageclass longhorn -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'`

## #Longhorn Dashboard
`kubectl port-forward -n longhorn-system svc/longhorn-frontend 9999:80`  
visit: http://localhost:9999


## Service Mesh/Networking
### Linkerd Install
`linkerd check --pre`
`linkerd install | kubectl apply -f -`
`linkerd check` (may take a few minutes)

### Linkerd Injector
Patch k3s resources (traefik)
`k patch -n kube-system deployment traefik -p='{"spec":{"template":{"metadata":{"annotations":{"linkerd.io/inject":"enabled"}}}}}'`
`k patch -n kube-system daemonsets svclb-traefik -p='{"spec":{"template":{"metadata":{"annotations":{"linkerd.io/inject":"enabled"}}}}}'`
Apply label to each namespace that will use linkerd:  `linkerd.io/inject: enabled`
`k patch ns default -p='{"metadata":{"annotations":{"linkerd.io/inject":"enabled"}}}'`
> Namespaces that need Labels:
> - default
> - longhorn-system
> - cert-manager

### Linkerd Extensions
viz: `linkerd viz install | kubectl apply -f -`
`linkerd viz dashboard`
jaeger: `linkerd jaeger install | kubectl apply -f -`
`linkerd jaeger dashboard`
`linkerd check`


# Celium
> Install k3s without flannel CNI
`curl -sfL https://get.k3s.io | sh -s - --flannel-backend none --disable-network-policy`  
Install celium cli:  
`wget -O- https://github.com/cilium/cilium-cli/releases/download/v0.15.7/cilium-linux-amd64.tar.gz | tar -xzvf - -C /usr/local/bin/ && chmod +x /usr/local/bin/cilium`  
install cilium to cluster:  
`export KUBECONFIG=/etc/rancher/k3s/k3s.yaml ; cilium install`  
verify successful install:  
`cilium status --wait; cilium connectivity test`  
enable hubble web ui:  
`cilium hubble enable --ui`  
