# kubectl patch

## examples

### Update PV's reclaim policy

```
kubectl get pv -ojsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' | xargs kubectl patch pv -p '{"spec":{"persistentVolumeReclaimPolicy":"Delete"}}'
```
