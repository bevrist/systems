IP=$(ip route get 8.8.8.8 | awk '{print $7;exit}')
k3d cluster create bae --k3s-arg "--tls-san=$IP@server:*" $@
k3d kubeconfig get bae | sed "s,server: https://0.0.0.0:,server: https://$IP:,g" | tee k3s-kubeconfig
echo "# kubeconfig written to 'k3s-kubeconfig'"
