#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)
cd $ROOT

build=false
while getopts "b" opt; do
    case "$opt" in
        b)
        build=true
        ;;
    esac
done
shift $((OPTIND -1))

source "$ROOT/hack/env.sh"

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

if $build; then
    make WHAT=test/e2e/e2e.test
fi

./hack/ginkgo-e2e.sh \
    --minStartupPods=1 \
    "$@"
