#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/../.. && pwd)
cd $ROOT

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

# setting this env prevents ginkgo e2e from trying to run provider setup
export KUBERNETES_CONFORMANCE_TEST='y'
export KUBECONFIG="$(kind get kubeconfig-path --name="k8s-testing")"

echo "KUBECONFIG: $KUBECONFIG"

if test -e _output/local/go/bin/ginkgo; then
    make WHAT="test/e2e/e2e.test"
else
    make WHAT="test/e2e/e2e.test ./vendor/github.com/onsi/ginkgo/ginkgo"
fi

export KUBE_SSH_USER=root
export KUBE_SSH_KEY=$ROOT/cluster/kind/k8s-testing

./hack/ginkgo-e2e.sh "$@"
