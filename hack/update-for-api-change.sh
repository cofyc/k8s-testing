#!/bin/bash

KUBE_ROOT=$GOPATH/src/k8s.io/kubernetes
cd $KUBE_ROOT

./hack/update-generated-runtime.sh 
