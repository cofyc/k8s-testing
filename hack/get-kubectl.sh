#!/bin/bash
#
# A script to download kubectl by version.
#
# By default, it downloads latest stable version.
#
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-using-curl
#

curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
