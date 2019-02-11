#!/bin/bash

export KUBERNETES_PROVIDER=local
# export KUBERNETES_PROVIDER=gce
# export GINKGO_PARALLEL=y

../../hack/ginkgo-e2e.sh \
    -b \
    -- \
    --ginkgo.skip="\[Disruptive\]" \
    --ginkgo.focus="In-tree\sVolumes\s\[Driver:\slocal\]\[VolumeType:\s+gce.*\].*Pre-provisioned.*should\ssupport\screating\smultiple\ssubpath\sfrom\ssame\svolumes" \
    $@
