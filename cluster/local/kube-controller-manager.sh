#!/bin/bash
#
# Used to access kube-controller-manager APIs.
#

    # -H "Authorization: Bearer $TOKEN"
all_flags=(
    --cacert /var/run/kubernetes/kube-controller-manager.crt
    https://localhost:10257${1}
    )
    
echo sudo curl "${all_flags[@]}"
sudo curl "${all_flags[@]}"
