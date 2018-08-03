# 64474

logs are from
https://k8s-gubernator.appspot.com/build/kubernetes-jenkins/logs/ci-kubernetes-e2e-gci-gce/25975.

## how to reproduce issue

See https://github.com/kubernetes/kubernetes/compare/15cd3552819367...cofyc:reproduc64474.


Step 1: Add pod

```
kubectl apply -f test-pod.yaml
```

Step 2: Delete pod

```
kubectl delete -f test-pod.yaml
```

Step 3: Check kubelet logs

You will see volume will be remounted again.
