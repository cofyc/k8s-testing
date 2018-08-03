#!/bin/bash
#
# See https://github.com/kubernetes/community/blob/master/contributors/devel/testing.md#integration-tests.
#

set -o errexit
set -o nounset
set -o pipefail

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

export KUBE_TEST_ARGS="-run '^(TestVolumeBinding|TestPVAffinityConflict)'"
export KUBE_TEST_VMODULE="scheduler*=5,pv*=5"
make test-integration WHAT=./test/integration/scheduler GOFLAGS="-v" 
