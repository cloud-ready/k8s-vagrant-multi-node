
git clone https://github.com/rook/rook.git
git checkout tags/v1.3.4 -b release/v1.3.4
cd rook/cluster/examples/kubernetes/ceph || exit
kubectl create -f common.yaml
kubectl create -f operator.yaml
kubectl create -f cluster.yaml
