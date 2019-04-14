#!/bin/bash

export KUBERNETES_PROVIDER=local

../../hack/ginkgo-e2e.sh \
    -b \
    -- \
    --ginkgo.focus="CSI\sVolumes\s\[Driver:\scsi-hostpath\]\s\[Testpattern:\sDynamic\sPV\s\(block\svolmode\)\]\svolumeMode\sshould\screate\ssc,\spod,\spv,\sand\spvc,\sread/write\sto\sthe\spv,\sand\sdelete\sall\screated\sresources" \
    $@
