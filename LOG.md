
# 

Rook 1.3.4
https://github.com/rook/rook/releases/tag/v1.3.0
Integration tests are run on 1.11, 1.13-1.18

https://github.com/kubernetes/dashboard/releases/tag/v2.0.1
1.18

https://docs.projectcalico.org/getting-started/kubernetes/requirements
Calico v3.14 test against 1.16, 1.17, and 1.18

```shell script
BOX_OS="ubuntu" NODE_COUNT="3" K8S_DASHBOARD_VERSION="2.0.1" KUBERNETES_VERSION="1.18.0" make up -j4
```

```shell script
kubeadm token list

#swapoff -a
#modprobe br_netfilter
#cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
#net.bridge.bridge-nf-call-ip6tables = 1
#net.bridge.bridge-nf-call-iptables = 1
#EOF
#sudo sysctl --system
```

```shell script
### Docker installation
apt-get remove docker docker-engine docker.io containerd runc
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io
### Kubeadm installation
swapoff -a
modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system
apt-get install -y apt-transport-https curl gnupg2
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
### Post install
kubeadm init --control-plane-endpoint kubectl
[kkonst@kube-master01:~]$                                                    # Non privileged user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml  # https://kubernetes.io/docs/concepts/cluster-administration/addons/
kubectl get pods --all-namespaces                                            # check core-dns is in running state, calico is present
You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:
  kubeadm join kubectl:6443 --token ya2kjj.hvg32ryp7nhmnkls \
    --discovery-token-ca-cert-hash sha256:485be4a0e835e1608e52defa7813966b07dd85b90006e8bc7ec2c86901891453 \
    --control-plane
Then you can join any number of worker nodes by running the following on each as root:
kubeadm join kubectl:6443 --token ya2kjj.hvg32ryp7nhmnkls \
    --discovery-token-ca-cert-hash sha256:485be4a0e835e1608e52defa7813966b07dd85b90006e8bc7ec2c86901891453
### Rook installation
cd rook/cluster/examples/kubernetes/ceph
kubectl create -f common.yaml
kubectl create -f operator.yaml
kubectl create -f cluster.yaml
# Force replace, delete and then re-create the resource. Will cause a service outage.
kubectl replace --force -f common.yaml
###
```