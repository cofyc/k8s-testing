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

export GINKGO_PARALLEL=y
export KUBERNETES_PROVIDER=local
export GINKGO_PARALLEL_NODES=8

rm -f /tmp/issue71570-*.log

for ((i=0; i < 100; i++)); do

./hack/ginkgo-e2e.sh \
    --minStartupPods=1 \
    --ginkgo.focus="PersistentVolumes-local.*should\s+not\s+set\s+different\s+fsGroups\s+for\s+two\s+pods\s+simultaneously" \
    | tee /tmp/issue71570-$i.log

done
