#!/bin/bash

export KUBERNETES_PROVIDER=gce

    # -b \
../../hack/ginkgo-e2e.sh \
    -- \
    --ginkgo.focus="\[Driver:\spd.csi.storage.gke.io\]\[Serial\]\s\[Testpattern:\sDynamic\sPV\s\(default\sfs\)\]\ssubPath\sshould\sunmount\sif\spod\sis\sforce\sdeleted\swhile\skubelet\sis\sdown\s\[Disruptive\]\[Slow\]" \
    $@
