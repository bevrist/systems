# K3S Deployment

## Fresh Install
1) deploy k3s: [_host/README.md](_host/README.md)
2) install local-registry: [local-registry/README.md](local-registry/README.md)
3) install cert-manager: [cert-manager/README.md](cert-manager/README.md)
4) set up skaffold configs:
  0) `export IP="k3s"`
  1) `skaffold config set default-repo $IP:5000`  
  2) `skaffold config set insecure-registries $IP:5000`
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
