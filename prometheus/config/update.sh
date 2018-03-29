#!/bin/bash

kubectl -n kube-system create configmap prometheus-config --from-file=prometheus.yml=prometheus.yml --dry-run -o yaml | kubectl -n kube-system apply -f -
