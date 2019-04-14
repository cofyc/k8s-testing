#!/bin/bash

export KUBERNETES_PROVIDER=local
# export KUBERNETES_PROVIDER=gce
# export GINKGO_PARALLEL=y

../../hack/ginkgo-e2e.sh \
    -b \
    -- \
    --ginkgo.skip="\[Disruptive\]" \
    --ginkgo.focus="\[Volume\s+type:\s+dir-link\]\s+Set\sfsGroup\sfor\slocal\svolume" \
    $@
