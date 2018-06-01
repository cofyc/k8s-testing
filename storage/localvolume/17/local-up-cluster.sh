#!/bin/bash

cd $GOPATH/src/k8s.io/kubernetes
export KUBE_FEATURE_GATES="PersistentLocalVolumes=true"
ALLOW_PRIVILEGED=true LOG_LEVEL=5 FEATURE_GATES=$KUBE_FEATURE_GATES hack/local-up-cluster.sh
