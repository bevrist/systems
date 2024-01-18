# K3S Deployment

## Fresh Install
1) deploy k3s: [_host/README.md](_host/README.md)
2) install local-registry: [local-registry/README.md](local-registry/README.md)
3) install cert-manager: [cert-manager/README.md](cert-manager/README.md)
4) set up skaffold configs:
  1) `skaffold config set default-repo $K3S_IP:5000`  
  2) `skaffold config set insecure-registries $K3S_IP:5000`
  3) `skaffold config set local-cluster true`
5) deploy website: [website/README.md](website/README.md)
8) install all other kube apps


---
# DEBUG
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
