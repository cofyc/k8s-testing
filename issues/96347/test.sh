#!/bin/bash

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

export KUBE_TIMEOUT="--timeout=3600s"
export KUBE_TEST_ARGS="-run TestVolumeCapacityPriority"
export KUBE_TEST_VMODULE="volumebinding*=5"
export GOFLAGS="-v" 

make test-integration WHAT=./test/integration/volumescheduling
