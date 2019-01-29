#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

build=false

while getopts "h?b" opt; do
    case "$opt" in
        h|\?)
            usage
            exit 0
            ;;
        b)
            build=true
            ;;
        esac
done

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

if $build; then
    make WHAT=test/e2e/e2e.test
fi

# export GINKGO_PARALLEL=y
export KUBERNETES_PROVIDER=local
# export GINKGO_PARALLEL_NODES=8

./hack/ginkgo-e2e.sh \
    --minStartupPods=1 \
    --ginkgo.focus="Stress\swith\slocal\svolumes"
