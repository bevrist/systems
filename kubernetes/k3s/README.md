# K3S Install

> Assuming a Debian 12 host system

## Base Install
1) Add local registry config to `/etc/rancher/k3s/registries.yaml`  
`mkdir -p /etc/rancher/k3s/` & `cat ./registries.yaml > /etc/rancher/k3s/registries.yaml`

2) install k3s from https://k3s.io  
`curl -sfL https://get.k3s.io | sh -`

3) get kubeconfig from k3s `/etc/rancher/k3s/k3s.yaml`  
> remember to update `server` to point to node ip

4) install local docker registry `kubectl apply -f manifests/local-registry.yaml`
> push to registry with `podman push --tls-verify=false 192.168.1.18:5000/image-name`

5) install cert manager  
  1) install cert manager `kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml`
  2) update this file and apply credentials `manifests/cert-manager.yaml`
  3) generate certs `kubectl apply -f manifests/cert-manager-certs/`


# DEBUG
## Traefik Dashboard
`kubectl port-forward -n kube-system $(kubectl get pod -n kube-system --selector=app.kubernetes.io/name=traefik -o jsonpath='{.items[0].metadata.name}') 9000:9000`  
visit: http://localhost:9000/dashboard/


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

