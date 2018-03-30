#!/bin/bash

set -e

./gen.sh > prometheus.yml
kubectl -n kube-system create configmap prometheus-config --from-file=prometheus.yml=prometheus.yml --dry-run -o yaml | kubectl -n kube-system apply -f -

# try to reload
pod=$(kubectl -n kube-system get pods -l app=prometheus --no-headers | cut -d ' ' -f 1)
md5sum=$(md5sum prometheus.yml | cut -d ' ' -f 1)
while true; do
   echo "Checking file is up to update..."
   podmd5sum=$(kubectl -n kube-system exec $pod -- /bin/md5sum /etc/prometheus/config/prometheus.yml | cut -d ' ' -f 1)
   if [[ "$podmd5sum" == "$md5sum" ]]; then
       echo "updated, try to reload promethues"
       podmd5sum=$(kubectl -n kube-system exec $pod -- kill -HUP 1 )
       echo "reloaded"
       break
   else
       echo "expected md5: $md5sum, got: $podmd5sum, not match, sleep a while, then retry"
       sleep 1
   fi
done

rm prometheus.yml
