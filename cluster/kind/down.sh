#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/../.. && pwd)
cd $ROOT

NAME=k8s-testing

if kind get clusters | grep "^${NAME}$"; then
    kind delete cluster --name ${NAME}
else
    echo "info: cluster '${NAME}' does not exist"
fi
