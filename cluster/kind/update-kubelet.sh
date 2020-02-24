#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/../.. && pwd)
cd $ROOT

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

make WHAT=cmd/kubelet

export KUBECONFIG="$(kind get kubeconfig-path --name="k8s-testing")"

nodes=$(kind get nodes --name k8s-testing)
for n in $nodes; do
    docker exec $n bash -c '
md5sum /kind/bin/kubelet
systemctl stop kubelet
'
    docker cp _output/local/bin/linux/amd64/kubelet $n:/kind/bin/kubelet
    docker exec $n bash -c '
systemctl start kubelet
md5sum /kind/bin/kubelet
'
done
