# Cert-Manager Deployment

1) install cert manager:
  1) `helm repo add jetstack https://charts.jetstack.io && helm repo update`
  2) `helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.13.3 --set installCRDs=true`
2) create credentials secret for cert manager, instructions at `cert-manager.yaml`
3) configure cert-manager certificate signers `kubectl apply -f cert-manager.yaml`
4) generate certs for websites `kubectl apply -f cert-manager-certs/`
