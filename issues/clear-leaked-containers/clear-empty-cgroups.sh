#!/bin/bash
cgroups=$(cat /proc/cgroups | tail -n +2 | awk '{print $1}')

echo "cgroups: $cgroups"

function clear_cgroups_recursively() {
    local d=$1
    if [ ! -d "$d" ]; then
        echo "$(date) info: '$d' does not exist, skipped"
        return
    fi
    local directories=$(find "$d" -mindepth 1 -maxdepth 1 -type d)
    for subd in $directories; do
        if ! clear_cgroups_recursively $subd; then
            return 1
        fi
    done
    rmdir $d
}

function is_container_empty() {
    for sub in $cgroups; do
        local procs=$(find "/sys/fs/cgroup/$sub/docker/$c" -name 'cgroup.procs' | xargs cat)
        if [ -n "$procs" ]; then
            return 1
        fi
    done
    # check again after 10 seconds, if it is still empty, we think the container is ok to remove
    sleep 10
    for sub in $cgroups; do
        local procs=$(find "/sys/fs/cgroup/$sub/docker/$c" -name 'cgroup.procs' | xargs cat)
        if [ -n "$procs" ]; then
            return 1
        fi
    done
    return 0
}

function clear_container() {
    local c=$1
    if is_container_empty "$c"; then
        echo "$(date) info: $c is empty, trying to clear"
        for sub in $cgroups; do
            if ! clear_cgroups_recursively "/sys/fs/cgroup/$sub/docker/$c"; then
                echo "$(date) info: cannot clear $c, skipped"
                break
            fi
        done
    else
        echo "$(date) info: $c is not empty, skipped"
    fi
}

while true; do
    # fix "too many open files"
    # https://github.com/kubernetes-sigs/kind/blob/21dbe8351cbefffd0815fde5516bfbc23fb438ea/site/content/docs/user/known-issues.md#pod-errors-due-to-too-many-open-files
    echo "$(date) info: configure sysctl -w fs.inotify.max_user_watches=1048576"
    sysctl -w fs.inotify.max_user_watches=1048576
    echo "$(date) info: configure sysctl -w fs.inotify.max_user_instances=512"
    sysctl -w fs.inotify.max_user_instances=512
    echo "$(date) info: cgroup status at the begning"
    cat /proc/cgroups 

    for d in $(find /sys/fs/cgroup/memory/docker -mindepth 1 -maxdepth 1 -type d); do
        clear_container $(basename $d)
    done

    echo "$(date) info: cgroup status at the end"
    cat /proc/cgroups
    sleep 1800
done
