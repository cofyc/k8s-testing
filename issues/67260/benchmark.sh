#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

./hack/print-workspace-status.sh | grep '^gitCommit'
grep -o -P 'EnableEquivalenceClassCache=(true|false)' test/integration/util/util.go
#make test-integration WHAT=./test/integration/scheduler_perf GOFLAGS="-v=1" KUBE_TEST_VMODULE="''" KUBE_TIMEOUT="--timeout 3600s" KUBE_TEST_ARGS="-bench=BenchmarkScheduling -cpuprofile=cpu-5000n-10000p.txt" | tee benchmark.log | grep -P '^(BenchmarkScheduling|ok)'
make test-integration WHAT=./test/integration/scheduler_perf GOFLAGS="-v=1" KUBE_TEST_VMODULE="''" KUBE_TIMEOUT="--timeout 3600s" KUBE_TEST_ARGS="-bench=BenchmarkScheduling" | tee benchmark.log | grep -P '^(BenchmarkScheduling|ok)'
