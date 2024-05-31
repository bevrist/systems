# syncthing container

install: `kubectl apply -f kube/`

### access web UI:
`kubectl port-forward -n syncthing $(kubectl get pod -n syncthing --selector=app=syncthing -o jsonpath='{.items[0].metadata.name}') 8384:8384`  
visit: http://localhost:8384/

Shares are mounted in the container at `/share`


### First time setup:
1) Set GUI user/password
2) General: Set "Device Name": `kube-syncthing`
3) edit "Folder Defaults" > "Advanced": enable `Ignore Permissions`
4) edit "Folder Defaults" > "Advanced" > "Folder Type": `Receive Only`
5) "connections": disable `Enable Relaying`
