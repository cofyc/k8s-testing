#!/bin/bash

IP=$(kubectl -n kube-system get pods -l app=grafana -ojsonpath='{range .items[*]}{.status.podIP}{end}')

if [ -z "$IP" ]; then
    echo "error: could not get grafana ip."
    exit
fi

ENDPOINT=http://admin:admin@$IP:3000

## datasources
echo ">>> Add datasources"
(
curl -s -XPOST -H 'Content-Type: application/json' -d @- $ENDPOINT/api/datasources <<EOF
{
  "name": "k8s",
  "type": "prometheus",
  "url": "http://prometheus.kube-system:9090",
  "access": "proxy",
  "basicAuth": false
}
EOF
) | python -m json.tool
echo ">>> Add datasources done"

## dashboards
echo ">>> Add dashboards"
for file in $(ls dashboards/*.json); do
    echo ">>> $file..."
    data=$(cat $file | sed 's/${DS_K8S}/k8s/g')
    curl -s -XPOST -H 'Content-Type: application/json' -d @- $ENDPOINT/api/dashboards/db <<EOF
{
  "dashboard": ${data},
  "folderId": 0,
  "overwrite": true
}
EOF
    echo ">>> $file... ok"
done
echo ">>> Add dashboards done"
