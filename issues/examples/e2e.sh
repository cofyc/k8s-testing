#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

cluster/kubectl.sh config set-cluster local --server=https://localhost:6443 --certificate-authority=/var/run/kubernetes/server-ca.crt
cluster/kubectl.sh config set-credentials myself --client-key=/var/run/kubernetes/client-admin.key --client-certificate=/var/run/kubernetes/client-admin.crt
cluster/kubectl.sh config set-context local --cluster=local --user=myself
cluster/kubectl.sh config use-context local

make WHAT=test/e2e/e2e.test

export KUBERNETES_PROVIDER=local
export KUBE_MASTER_URL=https://localhost:6443

# ./hack/ginkgo-e2e.sh --ginkgo.focus="\[Volume\s+type:\s+dir-link\]\s+Set\sfsGroup\sfor\slocal\svolume"
./hack/ginkgo-e2e.sh --ginkgo.focus="\[sig-xxx\]"
