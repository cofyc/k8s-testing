#!/bin/bash
#
# See https://github.com/kubernetes/community/blob/master/contributors/devel/testing.md#integration-tests.
#

set -o errexit
set -o nounset
set -o pipefail

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

# make test-integration WHAT=./test/integration/volumescheduling GOFLAGS="-v" KUBE_TEST_VMODULE="scheduler*=5" KUBE_TEST_ARGS="-run ^TestVolumeProvision/.*/wait_one_bound,_one_provisioned$" | tee > /tmp/integration.log
# make test-integration WHAT=./test/integration/volumescheduling GOFLAGS="-v" KUBE_TEST_VMODULE="scheduler*=5" KUBE_TEST_ARGS="-run ^TestVolumeProvision/.*/wait_one_pv_prebound,_one_provisioned$" | tee > /tmp/integration.log
make test-integration WHAT=./test/integration/volumescheduling GOFLAGS="-v" KUBE_TEST_VMODULE="scheduler*=5" KUBE_TEST_ARGS="-run ^TestVolumeProvision$" | tee /tmp/integration.log
