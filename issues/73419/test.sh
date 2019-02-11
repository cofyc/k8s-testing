#!/bin/bash

export KUBERNETES_PROVIDER=gce
# export GINKGO_PARALLEL=y

../../hack/ginkgo-e2e.sh -b -- \
    --ginkgo.focus="Stress\swith\slocal\svolumes" \
    $@
