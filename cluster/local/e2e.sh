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

    # https://github.com/kubernetes/kubernetes/issues/61456
    # https://github.com/kubernetes/kubernetes/pull/61489
    # --test_args="--ginkgo.focus=\[sig-storage\]\s+HostPath\s+should\s+support\s+subPath --clean-start=true" \

    # --test_args="--ginkgo.focus=PersistentVolumes-local" \

    # --test_args="--ginkgo.focus=\[Volume\stype:\s+tmpfs\]\s+.*should\s+be\s+able\s+to\s+mount\s+volume\s+and\s+read\s+from\s+pod" \
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*should\s+fail\s+due\s+to\s+non-existent\s+path" \
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*should\s+set\s+fsGroup\s+for\s+local\s+volume" \
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*should\s+set\s+fsGroup\s+for\s+local\s+volume"

if $build; then
    make WHAT=test/e2e/e2e.test
fi

go run hack/e2e.go -- \
    --provider=local \
    --test \
    --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir|tmpfs)\].*Set\sfsGroup\sfor\slocal\svolume --clean-start=true" \
    --timeout=1h \
