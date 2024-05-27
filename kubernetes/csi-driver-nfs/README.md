# Csi-Driver-NFS Deployment

1) install nfs csi driver:
  1) `helm repo add csi-driver-nfs https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/charts`
  2) `kubectl create namespace nfs-csi`
  3) `helm install csi-driver-nfs csi-driver-nfs/csi-driver-nfs --namespace nfs-csi --version v4.7.0 --set externalSnapshotter.enabled=true`
2) create nfs storage class: `kubectl apply storage-class.yaml`
3) test nfs storage: 
  1) create test deployment: `kubectl apply -f test-nfs.yaml`
  2) verify nfs is working: `kubectl logs deployment/deployment-nfs-test`
  3) delete test deployment: `kubectl delete -f test-nfs.yaml`
