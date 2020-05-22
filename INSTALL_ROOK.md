
```shell script
BOX_OS="ubuntu" NODE_COUNT="3" K8S_DASHBOARD_VERSION="2.0.1" KUBERNETES_VERSION="1.18.0" make -j4
NODE_COUNT="3" make snapshot-push
NODE_COUNT="3" make snapshot-list

kubectl get pod --all-namespaces -o wide

make kubectl-master
make install-calico
make install-rook

make ssh-master
```
