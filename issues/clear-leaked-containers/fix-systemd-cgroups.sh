#!/bin/bash

echo "info: cgroup status at the begning"
cat /proc/cgroups

for d in $(find /sys/fs/cgroup/cpu/system.slice -name 'run-docker-runtime*.mount' -mindepth 1 -maxdepth 1 -type d); do
     unit="$(basename $d)"
     echo systemctl stop "$unit"
     systemctl stop "$unit"
done

echo "info: cgroup status at the end"
cat /proc/cgroups
