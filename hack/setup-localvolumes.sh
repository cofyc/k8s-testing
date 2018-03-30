#!/bin/bash

action=${1:-setup}

function usage() {
    echo "Usage: $(basename $0) [setup|teardown]"
    echo ""
}

case $action in
    "setup" | "teardown")
        ;;
    *)
        usage
        ;;
esac

test -d /mnt/disks || mkdir /mnt/disks
for i in $(seq 1 600); do
    vol=vol$i
    dir=/mnt/disks/$vol
    if [[ "$action" == "setup" ]]; then
        test -d $dir || mkdir $dir
        mount -t tmpfs $vol -osize=10240000 $dir
    else
        test -d $dir && umount $dir
        test -d $dir && rmdir $dir
    fi
done
