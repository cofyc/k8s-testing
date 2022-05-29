# registry

## containerd

e.g.

```
[plugins."io.containerd.grpc.v1.cri".registry]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
       endpoint = ["http://172.17.0.1:5000"]
```

note that `http://` is required.

## docker

```
cat <<EOF > /etc/docker/daemon.json.tmp
{
    "registry-mirrors": ["$DOCKER_IO_MIRROR"]
}
EOF
```

Note that, quay.io, gcr.io cannot be mirrored in docker, see https://docs.docker.com/registry/recipes/mirror/#gotcha.

```
It’s currently not possible to mirror another private registry. Only the central
Hub can be mirrored.
```
