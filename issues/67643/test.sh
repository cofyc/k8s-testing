#!/bin/bash

set -e

go test k8s.io/kubernetes/pkg/volume/cephfs
go test k8s.io/kubernetes/pkg/util/...
