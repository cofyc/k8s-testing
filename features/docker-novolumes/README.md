# Docker Volume in Kubernetes

如果用户在 Dockerfile 中指定了 Volume，那么如果这个 Volume 没有被 pvc
所挂载，这个目录就会以 volume 的形式挂载到这台机器的 /var/lib/docker/volumes
目录下面，脱离了 rootfs 的限制，并且有写爆 docker 业务盘的风险。

## Solution

See https://github.com/cofyc/docker-novolume-plugin

## References

- https://forums.mobyproject.org/t/is-it-possible-to-disable-local-volume-plugin/308/3
