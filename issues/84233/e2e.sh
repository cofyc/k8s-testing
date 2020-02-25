#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/../.. && pwd)
cd $ROOT

    # --ginkgo.focus="PersistentVolumes-local.*gce-localssd-scsi-fs"

$ROOT/cluster/kind/e2e.sh \
    --provider=skeleton \
    --disable-log-dump=true \
    --minStartupPods=1 \
    --clean-start=true \
    --delete-namespace=false \
    --delete-namespace-on-failure=false \
    --ginkgo.dryRun \
    --ginkgo.v \
    --ginkgo.focus='\[sig-storage\].*\[(Serial|Disruptive)\]' --ginkgo.skip='\[Flaky\]'
