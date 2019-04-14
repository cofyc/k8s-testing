#!/bin/bash

export KUBERNETES_PROVIDER=gce

    # -b \
../../hack/ginkgo-e2e.sh \
    -- \
    --ginkgo.focus="\[Driver:\spd.csi.storage.gke.io\].*Dynamic\s+PV\s+\(default\s+fs\).*subPath\s+should\s+unmount\s+if" \
    $@
