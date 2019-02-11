#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)
cd $ROOT

export NODE_LOCAL_SSDS_EXT=1,scsi,fs # attach a scsi disk
$ROOT/hack/e2e.sh -- --up
