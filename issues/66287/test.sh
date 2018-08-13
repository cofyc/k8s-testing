#!/bin/bash
#
# See https://github.com/kubernetes/community/blob/master/contributors/devel/testing.md#integration-tests.
#

set -o errexit
set -o nounset
set -o pipefail

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

make test-integration WHAT=./test/integration/scheduler GOFLAGS="-v" KUBE_TEST_VMODULE="attachdetach*=10,util*=10,pv*=4" KUBE_TEST_ARGS='-run TestVolumeBindingWithControllerRace'
