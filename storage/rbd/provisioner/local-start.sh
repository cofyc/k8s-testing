#!/bin/bash

PATH=${PATH}:`pwd`

if [[ "$KUBECONFIG" == "" ]]; then
	KUBECONFIG=/root/.kube/config
fi

cd $GOPATH/src/github.com/kubernetes-incubator/external-storage/ceph/rbd
./rbd-provisioner -id=rbd-provisioner-1 -master=http://127.0.0.1:8080 -kubeconfig=${KUBECONFIG} -logtostderr -v=4
