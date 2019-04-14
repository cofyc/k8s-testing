#!/bin/bash

go test k8s.io/kubernetes/pkg/controller/volume/scheduling

export KUBERNETES_PROVIDER=local
export KUBE_MASTER_URL=https://localhost:6443

../../hack/ginkgo-e2e.sh \
    -b \
    -- \
    --ginkgo.focus="Events\sshould\sbe\ssent\sby\skubelets\sand\sthe\sscheduler\sabout\spods\sscheduling\sand\srunning" \
    $@
