#!/bin/bash

export KUBERNETES_PROVIDER=gce

../../hack/ginkgo-e2e.sh \
    -b \
    -- \
    --ginkgo.focus="\[Driver:\scsi-hostpath-v0\].*Dynamic\s+PV\s+\(default\s+fs\).*subPath\s+should\s+unmount\s+if\s+pod\s+is\s+gracefully\s+deleted\s+while\s+kubelet\sis\s+down" \
    $@
