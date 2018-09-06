#!/bin/bash
#
# See https://github.com/kubernetes/community/blob/master/contributors/devel/testing.md#integration-tests.
#

set -o errexit
set -o nounset
set -o pipefail

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

# go test -v k8s.io/kubernetes/pkg/scheduler/core -run TestCacheInvalidationRace$
# go test k8s.io/kubernetes/pkg/scheduler/core/equivalence
# make test-integration WHAT=./test/integration/scheduler GOFLAGS="-v" KUBE_TEST_VMODULE="scheduler*=5,pv*=5,factory*=5,equivalence*=5" KUBE_TEST_ARGS="-run '^(TestInvalidatePredicateInFlight)'"

go test k8s.io/kubernetes/pkg/scheduler/...
make test-integration WHAT=./test/integration/scheduler GOFLAGS="-v" KUBE_TEST_VMODULE="scheduler*=5,pv*=5,factory*=5,equivalence*=5" KUBE_TEST_ARGS="-run ." 
