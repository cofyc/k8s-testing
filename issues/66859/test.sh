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

go run hack/e2e.go -old 240h -- \
    --provider=local \
    --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir|dir-bindmounted|dir-link|dir-link-bindmounted|gce-localssd-scsi-fs|tmpfs)\].*Set\sfsGroup\sfor\slocal\svolume.* --clean-start=true --minStartupPods=1" \
    --test
