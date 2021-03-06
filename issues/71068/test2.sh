#!/bin/bash
#
# See https://github.com/kubernetes/community/blob/master/contributors/devel/testing.md#integration-tests.
#

set -o errexit
set -o nounset
set -o pipefail

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

# go test k8s.io/kubernetes/pkg/scheduler/...
rm -f /tmp/*.log
for ((i=0; i < 10; i++)); do
    make test-integration WHAT=./test/integration/scheduler GOFLAGS="-v" KUBE_TEST_VMODULE="scheduler*=5,pv*=5,factory*=5,equivalence*=5" KUBE_TEST_ARGS="-run TestVolumeBindingWithAffinity" | tee /tmp/$i.log
done
