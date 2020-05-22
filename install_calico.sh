
curl -sSL -o calico_3.14.yaml "https://docs.projectcalico.org/v3.14/manifests/calico.yaml"

#export K8S_POD_CIDR="$(kubeadm config view | grep podSubnet | awk -F: '{print $2}' | xargs)"
#sed -i "s|# Disable file logging so \`kubectl logs\` works.|- name: CALICO_IPV4POOL_CIDR\n              value: \"${K8S_POD_CIDR}\"\n            # Disable file logging so \`kubectl logs\` works.|" calico_3.14.yaml
#sed -i "s|# Disable file logging so \`kubectl logs\` works.|- name: IP_AUTODETECTION_METHOD\n              value: \"eth1\"\n            # Disable file logging so \`kubectl logs\` works.|" calico_3.14.yaml
kubectl apply -f calico_3.14.yaml

# check core-dns is in running state, calico is present
kubectl get pods --all-namespaces
