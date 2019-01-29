#!/bin/bash
#
# https://kubernetes-csi.github.io/docs/Example.html
#

# CRDs
kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/manifests/csidriver.yaml --validate=false
kubectl create -f https://raw.githubusercontent.com/kubernetes/csi-api/master/pkg/crd/manifests/csinodeinfo.yaml --validate=false

# RABC
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-provisioner/1cd1c20a6d4b2fcd25c98a008385b436d61d46a4/deploy/kubernetes/rbac.yaml
kubectl create -f
# fix for external-provisioner
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-provisioner/3aa7a5d8067b030c42374210b0766de394062000/deploy/kubernetes/rbac.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-attacher/9da8c6d20d58750ee33d61d0faf0946641f50770/deploy/kubernetes/rbac.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/driver-registrar/87d0059110a8b4a90a6d2b5a8702dd7f3f270b80/deploy/kubernetes/rbac.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/01bd7f356e6718dee87914232d287631655bef1d/deploy/kubernetes/rbac.yaml

# programs
function apply() {
    local file=$1
    wget -q -O - "$file" | sed 's/imagePullPolicy: Always/imagePullPolicy: IfNotPresent/g' | kubectl apply -f -
}

apply https://raw.githubusercontent.com/kubernetes/kubernetes/f40a5d1155aae95105a4e9bb8933d750c666e350/test/e2e/testing-manifests/storage-csi/hostpath/hostpath/csi-hostpathplugin.yaml 
apply https://raw.githubusercontent.com/kubernetes/kubernetes/f40a5d1155aae95105a4e9bb8933d750c666e350/test/e2e/testing-manifests/storage-csi/hostpath/hostpath/csi-hostpath-provisioner.yaml
apply https://raw.githubusercontent.com/kubernetes/kubernetes/f40a5d1155aae95105a4e9bb8933d750c666e350/test/e2e/testing-manifests/storage-csi/hostpath/hostpath/csi-hostpath-attacher.yaml
apply https://raw.githubusercontent.com/kubernetes-csi/docs/387dce893e59c1fcf3f4192cbea254440b6f0f07/book/src/example/snapshot/csi-hostpath-snapshotter.yaml
