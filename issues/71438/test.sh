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

# go run hack/e2e.go -old 240h -- \
    # --provider=local \
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*should\s+use\s+be\s+able\s+to\s+process\s+many\s+pods\s+and\s+reuse\s+local\svolume --clean-start=true --minStartupPods=1" \
    # --test

export GINKGO_PARALLEL=y
export KUBERNETES_PROVIDER=local
export GINKGO_PARALLEL_NODES=8

rm -f /tmp/issue71438-*.log

for ((i=0; i < 100; i++)); do

./hack/ginkgo-e2e.sh \
    --minStartupPods=1 \
    --ginkgo.focus="PersistentVolumes-local.*Two\s+pods\s+mounting\s+a\s+local\s+volume\s+one\s+after\s+the\s+other\s+should\s+be\s+able\s+to\s+write\s+from\s+pod1\s+and\s+read\s+from\s+pod2" \
    | tee /tmp/issue71438-$i.log

done
