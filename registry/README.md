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
