#!/bin/bash

export KUBERNETES_PROVIDER=gce

    # -b \
../../hack/ginkgo-e2e.sh \
    -- \
    --ginkgo.focus="In-tree\sVolumes\s\[Driver:\slocal\]\[LocalVolumeType:\s+gce.*\].*should\s+unmount.*" \
    $@
