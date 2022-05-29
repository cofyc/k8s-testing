# Examples

## Operations

### discovery apis and resources

```
kubectl --v=10 api-resources
```

### list all hostnames of nodes

```
kubectl get nodes -ojsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'
```

### list all internal addresses of master nodes

```
kubectl get nodes -l 'node-role.kubernetes.io/master' -ojsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{"\n"}{end}'
```

### List all taints of nodes

```
kubectl get nodes -o go-template-file="./files/nodes-taints.tmpl"
```

or

```
kubectl get nodes -ogo-template='{{- range .items}}
    {{- if $taint := (index .spec "taints") }}
        {{- .metadata.name }}{{ "\t" }}
        {{- range $taint }}
            {{- .key }}={{ .value }}:{{ .effect }}{{ "\t" }}
        {{- end }}
        {{- "\n" }}
    {{- end}}
{{- end}}'
```

### List all resources of containers

```
kubectl get pods --all-namespaces -ogo-template='{{- range .items}}
    {{- $node := .spec.nodeName }}
    {{- $name := .metadata.name }}
    {{- range .spec.containers }}
       {{- $node }}{{ "\t" }}{{ $name }}{{ "\t" }}{{ .name }}{{ "\t" }}{{ .resources }}
       {{- "\n" }}
       {{- "\n" }}
    {{- end }}
{{- end}}'
```

### List all addresses of nodes

```
kubectl get nodes -ogo-template='{{- range .items}}
      {{- .metadata.name }}{{ "\t" }}
      {{- range .status.addresses }}
          {{- .type }}={{ .address }}{{ "\t" }}
      {{- end }}{{"\n"}}
{{- end}}'
```

### List pods with uid

Useful to get grep pods by uid.

```
kubectl get pods --all-namespaces -ojsonpath='{range .items[*]}{.metadata.name} {.metadata.uid}{"\n"}{end}'
```

### list all control-plane information

```
kubectl -n kube-system get pods -l tier=control-plane -ojsonpath='{range .items[*]}{.spec.nodeName}/{.metadata.name}/{.status.phase}: {.spec.containers[0].image} {.status.containerStatuses[0].state.running.startedAt}{"\n"}{end}' | grep nb2329
```

### Get `services.nodeports` quota

```
kubectl -n ava get resourcequota quota -ojsonpath="{.spec.hard['services\.nodeports']}"
```

You need to escape dot, see https://github.com/kubernetes/kubernetes/issues/23386.

### Get node memory capacity & allocatable

```
kubectl get node -ojsonpath='{range .items[*]}{.metadata.name} {.status.capacity.memory} {.status.allocatable.memory}{"\n"}{end}'  | perl -lne 'BEGIN {my $a=0, $b=0; print "node", "\t", "capacity", "\t", "allocatable"} if (/^([^ ]+) (\d+)[^ ]+ (\d+)/) {print $1, "\t", $2/1024, "\t", $3/1024; $a += $2; $b += $3;} END { print "total\t", $a/1024, "\t", $b/1024 }'
```

### Get node cpu capacity & allocatable

```
kubectl get node -ojsonpath='{range .items[*]}{.metadata.name}{.status.capacity.cpu} {.status.allocatable.cpu}{"\n"}{end}'
```

### List persistent volumes

```
kubectl get pv -ojsonpath='{range .items[*]}{.metadata.name} {.spec.rbd.image}{"\n"}{end}'
```

for local pvs:

```
kubectl get pv -ojsonpath='{range .items[*]}{.metadata.name} {.spec.storageClassName} {.spec.nodeAffinity.required.nodeSelectorTerms[0].matchExpressions[0].values[0]} {.status.phase} {.spec.local.path} {"\n"}{end}' 
```

### Specify api groups and versions

```
kubectl get deployments.apps test-nginx
kubectl get deployments.v1.apps test-nginx
```

See
https://github.com/kubernetes/kubernetes/issues/58131#issuecomment-356823588.

### get raw files from secrets

```
kubectl get secrets selfsigned-ca-cert  -ojsonpath="{.data['ca\.crt']}" | base64 -d > selfsigned.ca.crt
kubectl get secrets selfsigned-ca-cert  -ojsonpath="{.data['tls\.crt']}" | base64 -d > selfsigned.tls.crt
kubectl get secrets selfsigned-ca-cert  -ojsonpath="{.data['tls\.key']}" | base64 -d > selfsigned.tls.key
```

## Notes

If a object/array key has a '.', it should be escaped by '\'. For example:

  {.spec.hard['requests\.memory']}

In command line, you need to write as this:

  kubectl -n ava get quota quota -ojsonpath="{.spec.hard['requests\.memory']}"

## References

- https://kubernetes.io/docs/user-guide/jsonpath/.
