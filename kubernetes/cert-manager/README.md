# Cert-Manager Deployment

1) install cert manager:
  1) `helm repo add jetstack https://charts.jetstack.io && helm repo update`
  2) `helm install cert-manager jetstack/cert-manager --namespace cert-manager --create-namespace --version v1.16.2 --set installCRDs=true`
  > *NOTE!* Upgrading Cert Manager requires slightly different steps: https://cert-manager.io/docs/installation/upgrade/
2) create credentials secret for cert manager, instructions at `cert-manager.yaml`
3) configure cert-manager certificate signers `kubectl apply -f cert-manager.yaml`
4) generate certs for websites `kubectl apply -f cert-manager-certs/`
