#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

go run hack/e2e.go -old 240h -- \
    --provider=gce \
    --test_args="--ginkgo.focus=PersistentVolumes-local.*\[Volume\stype:\s(dir-bindmounted)\].*should\snot\sset\sdifferent\sfsGroups.* --clean-start=true" \
    --test \
