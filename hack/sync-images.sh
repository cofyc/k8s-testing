#!/bin/bash
#
# This script is used to sync images via a public registry.
#

images=(
    gcr.io/google_containers/kube-apiserver-amd64:v1.9.6
    gcr.io/google_containers/kube-proxy-amd64:v1.9.6
    gcr.io/google_containers/kube-controller-manager-amd64:v1.9.6
    gcr.io/google_containers/kube-scheduler-amd64:v1.9.6
    gcr.io/google_containers/etcd-amd64:3.1.11
    gcr.io/google_containers/pause-amd64:3.0
    gcr.io/google_containers/pause-amd64:3.1
    gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.7
    gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.7
    gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.7
    gcr.io/google_containersk8s.gcr.io/kube-cross:v1.10.1-1
    # ingress
    gcr.io/google_containers/defaultbackend:1.0
    gcr.io/google_containers/nginx-ingress-controller:0.9.0-beta.15
    # for e2e
    gcr.io/kubernetes-e2e-test-images/serve-hostname-amd64:1.0
    gcr.io/kubernetes-e2e-test-images/mounttest-amd64:1.0
    # prometheus
    quay.io/prometheus/prometheus:v2.2.1
    # external storage
    quay.io/external_storage/local-volume-provisioner:v2.0.0
)

function get-normalized-image() {
    tr -s '/' '-' <<< "$1"
}

function get-full-image() {
    printf "reg.qiniu.com/sync/%s" $(get-normalized-image $1)
}

trap "kill 0" EXIT

PIPE=$(mktemp -u)
mkfifo $PIPE
exec 99<>$PIPE
rm $PIPE

if [ -n "${DOCKER_USERNAME}" -a -n "${DOCKER_PASSWORD}" ]; then
    docker login reg.qiniu.com -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
else
    docker login reg.qiniu.com
fi

if [ $# -gt 0 ]; then
	images=($@)
fi

(
for img in ${images[*]}; do
    logfile="/tmp/sync-images-$(get-normalized-image $1).log"
    (
    echo "====== syncing $img, log file: $logfile" >&99
    rurl=$img
    lurl=$(get-full-image $img)
    docker pull $rurl
    docker tag $rurl $lurl
    docker push $lurl
    echo "====== syncing $img done" >&99
    ) 0>&- &>$logfile &
done
wait
echo "done" >&99
) &

(
	while IFS= read -r line; do
		[[ "$line" == "done" ]] && break
		echo "$line"
	done <&99
) &

wait

echo "Now you can use following commands to get all images:"

for img in ${images[*]}; do
    rurl=$img
    lurl=$(get-full-image $img)
    echo docker pull $lurl
    echo docker tag $lurl $rurl
done
