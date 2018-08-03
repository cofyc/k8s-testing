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
    # -E is used to preserve environments
    # env "PATH=$PATH" is used to preserve PATH, see https://unix.stackexchange.com/a/83194/206361.
    #sudo -E env "PATH=$PATH" make WHAT=test/e2e/e2e.test
    make WHAT=test/e2e/e2e.test
fi

if [[ "$UID" != "0" ]]; then
    # let non-root user can access auth files
    sudo chmod o+r /var/run/kubernetes/*
fi

    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir|dir-link|dir-bindmounted|dir-link-bindmounted|tmpfs|block|blockfs)\] --clean-start=true" \
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir|dir-link|dir-bindmounted|dir-link-bindmounted|tmpfs|block|blockfs)\] --clean-start=true --minStartupPods=1" \

    # test all PersistentVolumes-local
    # --test_args="--ginkgo.focus=PersistentVolumes-local.* --clean-start=true"
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir|dir-link|dir-bindmounted|dir-link-bindmounted|tmpfs|block)\] --clean-start=true"
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir-bindmounted|dir-link-bindmounted)\].*should\s+set\s+fsGroup\s+for\s+one\s+pod --clean-start=true"
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir-bindmounted)\].*should\snot\sset\sdifferent\sfsGroups.* --clean-start=true" \
    #--test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir-link|dir-link-bindmounted)\] --clean-start=true" \
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir-link|block|blockfs)\]\sTwo\spods\smounting\sa\slocal\svolume\sone\safter\sthe\sother --clean-start=true" \

    #--test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir-bindmounted)\].*should\sset\sdifferent\sfsGroup\sfor\ssecond\spod.* --clean-start=true" \

# export GINKGO_PARALLEL=y
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(block)\] --clean-start=true --minStartupPods=1" \
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(.*)\].*should\sset\sdifferent\sfsGroup\sfor\s+second\spod\sif\sfirst\spod\sis\sdeleted.* --clean-start=true --minStartupPods=1" \
    # --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(tmpfs|blockfs)\].*should\s+not\s+set\s+different\s+fsGroups\sfor\stwo.* --clean-start=true --minStartupPods=1" \
    #--test_args="--ginkgo.skip=.*Feature:BlockVolume.* --ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir|dir-link|dir-bindmounted|dir-link-bindmounted|tmpfs|block|blockfs)\] --clean-start=true --minStartupPods=1" \
#export GINKGO_PARALLEL_NODES=6

go run hack/e2e.go -old 240h -- \
    --provider=local \
    --test_args="--ginkgo.focus=PersistentVolumes-local.*StatefulSet\swith\spod\saffinity.* --clean-start=true --minStartupPods=1" \
    --test
