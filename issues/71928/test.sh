#!/bin/bash
#
# See https://github.com/kubernetes/community/blob/master/contributors/devel/testing.md#integration-tests.
#

set -o errexit
set -o nounset
set -o pipefail

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

go test k8s.io/kubernetes/pkg/scheduler/...
go test k8s.io/kubernetes/pkg/controller/volume/persistentvolume/...

rm -f /tmp/integration-*.log
for ((i=0; i < 100; i++)); do
        # KUBE_TEST_ARGS="-run '(TestVolumeBindingDynamicStressFast|TestVolumeBindingDynamicStressSlow)'"  \
    make test-integration WHAT=./test/integration/scheduler KUBE_TEST_VMODULE="scheduler*=5,pv*=5,factory*=5,equivalence*=5" \
        KUBE_TEST_ARGS="-run '(TestVolumeProvision|TestVolumeBindingDynamicStressFast|TestVolumeBindingDynamicStressSlow)'"  \
        GOFLAGS="-v"  \
        | tee /tmp/integration-$i.log
done
