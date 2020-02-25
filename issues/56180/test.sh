#!/bin/bash

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

export KUBE_TIMEOUT="--timeout=3600s"
# go test k8s.io/kubernetes/pkg/scheduler/framework/plugins/volumebinder \
    # k8s.io/kubernetes/pkg/scheduler/api/compatibility
# export KUBE_TEST_ARGS="-run '^(TestVolumeBinding)'"
# export KUBE_TEST_VMODULE="scheduler*=5,volumebinder*=5"
# make test-integration WHAT=./test/integration/volumescheduling GOFLAGS="-v" 

# https://prow.k8s.io/view/gcs/kubernetes-jenkins/pr-logs/pull/83726/pull-kubernetes-integration/1182936431899709440/
export KUBE_TEST_ARGS="-run '(TestTaintBasedEvictions|TestSchedulerCreationFromConfigMap)'"
# export KUBE_TEST_ARGS="-run 'TestSchedulerCreationFromConfigMap'"
export GOFLAGS="-v" 
make test-integration WHAT=./test/integration/scheduler
