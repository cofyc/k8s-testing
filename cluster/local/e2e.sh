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

    # 62102
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(tmpfs|linkdir|dir)\].*Set\sfsGroup\sfor\slocal\svolume --clean-start=true"
    
    #--test_args="--ginkgo.focus=PersistentVolumes-local.*non-existent\spath"
    # --test_args="--ginkgo.focus=should\snot\sprovision\sa\svolume\sin\san\sunmanaged\sGCE\szone"
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\stmpfs\].*Set\sfsGroup\sfor\slocal\svolume --clean-start=true"

if $build; then
    make WHAT=test/e2e/e2e.test
fi

    # --ginkgo-parallel=4 \
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(tmpfs|linkdir|dir)\].*Set\sfsGroup\sfor\slocal\svolume --clean-start=true"
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir-link-bindmounted)\].*Set\sfsGroup\sfor\slocal\svolume.*should\snot\sset\sdifferent\sfsGroups --clean-start=true"
    # --ginkgo-parallel=4 
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir|dir-link|dir-bindmounted|dir-link-bindmounted)\] --clean-start=true"
# export GINKGO_PARALLEL=4
# export GINKGO_PARALLEL_NODES=4
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir|dir-link|dir-bindmounted|dir-link-bindmounted|tmpfs|block)\] --clean-start=true"
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(blockfs)\] --clean-start=true"
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(blockfs)\].*Set\sfsGroup\sfor\slocal\svolume.*should\snot\sset\sdifferent\sfsGroups --clean-start=true"
go run hack/e2e.go -old 240h -- \
    --provider=local \
    --test \
    --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir|dir-link|dir-bindmounted|dir-link-bindmounted|tmpfs|block)\] --clean-start=true"

# export GINKGO_PARALLEL=4
# export KUBERNETES_PROVIDER="local" 
    # ./hack/ginkgo-e2e.sh \
        # '--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(tmpfs|block)\]' \
        # --clean-start=true
