#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/../.. && pwd)
cd $ROOT

# --ginkgo.focus="\[Driver:\ local\].*\[LocalVolumeType:\ block\].*\[Testpattern:\sPre-provisioned\sPV\s\(block\svolmode\)\].*disruptive\[Disruptive\].*Should\stest\sthat\spv\sused\sin\sa\spod\sthat\sis\sforce\sdeleted\swhile\sthe\skubelet\sis\sdown\scleans\sup\swhen\sthe\skubelet\sreturns"
    # --ginkgo.focus="\[Testpattern:\ Pre-provisioned\ PV\ \(default\ fs\)\].*should\ unmount\ if\ pod\ is\ force\ deleted\ while\ kubelet\ is\ down"
    # --ginkgo.dryRun \
    # --ginkgo.v \

$ROOT/cluster/kind/e2e.sh \
    --provider=skeleton \
    --disable-log-dump=true \
    --minStartupPods=1 \
    --clean-start=true \
    --delete-namespace=false \
    --delete-namespace-on-failure=false \
    --ginkgo.focus="\[Driver:\ local\].*\[LocalVolumeType:\ block\]\ \[Testpattern:\ Pre-provisioned\ PV\ \(default\ fs\)\].*should\ unmount\ if\ pod\ is\ force\ deleted\ while\ kubelet\ is\ down"
