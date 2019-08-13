#!/bin/bash

if ! which jq &>/dev/null; then
    echo "error: jq is required"
    exit
fi

kubectl get pods --all-namespaces -ojson | jq  -C '
.items[] | select(.spec.nodeName) as $pod | .spec.containers[] | select(.resources.requests.cpu) | {name: ($pod.metadata.name + "/" + .name), node: $pod.spec.nodeName, cpu: .resources.requests.cpu}
'
