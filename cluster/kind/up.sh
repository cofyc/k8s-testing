#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/../.. && pwd)
cd $ROOT

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

NAME=k8s-testing

kind build node-image

tmpfile=$(mktemp)

trap "rm -f $tmpfile" EXIT

# TODO: set -v=5 to kubelet
cat <<EOF > $tmpfile
kind: Cluster
apiVersion: kind.sigs.k8s.io/v1alpha3
networking:
  ipFamily: ipv4
nodes:
- role: control-plane
- role: worker
- role: worker
kubeadmConfigPatches:
- |
  apiVersion: kubeadm.k8s.io/v1beta2
  kind: InitConfiguration
  metadata:
    name: config
  nodeRegistration:
    kubeletExtraArgs:
      v: "5"
- |
  apiVersion: kubeadm.k8s.io/v1beta2
  kind: JoinConfiguration
  metadata:
    name: config
  nodeRegistration:
    kubeletExtraArgs:
      v: "5"
EOF

echo "info: begin of kind configuration"
cat $tmpfile
echo "info: end of kind configuration"

kind create cluster \
    --image kindest/node:latest \
    --name ${NAME} \
    --wait 1m \
    --config $tmpfile \
	--loglevel debug

echo "info: prepare nodes for e2e"
nodes=$(kind get nodes --name k8s-testing)
for n in $nodes; do
    (
    docker exec $n bash -c '
apt-get update
apt-get install -y sudo
apt-get install -y openssh-server 
systemctl start sshd
mkdir /root/.ssh
'
    docker cp $ROOT/cluster/kind/k8s-testing.pub $n:/root/.ssh/authorized_keys
    docker exec $n bash -c '
chmod 0600 /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys
'
    )
done

wait
