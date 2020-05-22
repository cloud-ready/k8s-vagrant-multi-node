export CLUSTER_NAME="k8s-vagrant-multi-node"
if [ -z "${CLUSTERCERTSDIR}" ]; then export CLUSTERCERTSDIR="$(mktemp -d)"; fi
export MASTER_IP="192.168.26.10"

echo "CLUSTER_NAME: ${CLUSTER_NAME}"
echo "CLUSTERCERTSDIR: ${CLUSTERCERTSDIR}"
echo "MASTER_IP: ${MASTER_IP}"

sudo cat /etc/kubernetes/pki/ca.crt > "${CLUSTERCERTSDIR}"/ca.crt
sudo grep -P "client-certificate-data:" /root/.kube/config | \
    sed -e "s/^[ \t]*//" | \
    cut -d" " -f2 | \
    base64 -d -i \
    > "${CLUSTERCERTSDIR}"/client-certificate.crt
sudo grep -P "client-key-data:" /root/.kube/config | \
    sed -e "s/^[ \t]*//" | \
    cut -d" " -f2 | \
    base64 -d -i \
    > "${CLUSTERCERTSDIR}"/client-key.key

# kubectl create cluster
kubectl \
    config set-cluster \
    ${CLUSTER_NAME} \
    --embed-certs=true \
    --server=https://${MASTER_IP}:6443 \
    --certificate-authority="${CLUSTERCERTSDIR}"/ca.crt

# kubectl create user
kubectl \
    config set-credentials \
    ${CLUSTER_NAME}-kubernetes-admin \
    --embed-certs=true \
    --username=kubernetes-admin \
    --client-certificate="${CLUSTERCERTSDIR}"/client-certificate.crt \
    --client-key="${CLUSTERCERTSDIR}"/client-key.key

rm -rf "${CLUSTERCERTSDIR}"

# kubectl create context
kubectl \
    config set-context \
    ${CLUSTER_NAME} \
    --cluster=${CLUSTER_NAME} \
    --user=${CLUSTER_NAME}-kubernetes-admin

# kubectl switch to created context
kubectl config use-context ${CLUSTER_NAME}

echo
echo "kubectl has been configured to use started k8s-vagrant-multi-node Kubernetes cluster"
kubectl config current-context
