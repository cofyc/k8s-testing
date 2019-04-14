#!/bin/bash

export KUBERNETES_PROVIDER=gce

../../hack/ginkgo-e2e.sh \
    -b \
    -- \
    --ginkgo.focus="Pods\ssharing\sa\ssingle\slocal\sPV" \
    $@
