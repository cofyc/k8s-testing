# Work flow

## dynamic provisioning local storage

- [scheduler] create a PVC with WaitForFirstConsumer
- [scheduler] find no matching volumes
- [scheduler] choose a node and set it in PVC
  - problem: how to choose a node 
- [provisioner] provision a PV on this node for this PVC and bind them together
- [scheduler] find all PVCs are bound, assign pod onto node

## how to choose a node

### with storage capacity

nodes (drivers on nodes) report to scheduler available storage capacity

scheduler choose a node which has enough storage capacity

provisioner create a PV for PVC

if failed, clear annSelectedNode annotation, let scheduler to retry

### without storage capacity


nodes (drivers on nodes) report to provisioner available storage capacity to provisioner

PV creation phase:

scheduler choose a node without considering storage capacity

provisioner create a PV with NodeAffinity for all possible nodes for PVC

in next try, scheduler will choose a node in all possible nodes because it will consider bound PV's NodeAffinity

PV attachment phase:

do real space allocation for PV

xref: https://github.com/intel/pmem-CSI/issues/92#issuecomment-442742369

## how to report storage capacity

### reporting in node status

### reporting in CSINodeInfo 

CSINodeInfo is not builtin resource yet, users need to install CSI CRDs, but we
plan to implement CSI driver to do local storage dynamic provisioning. It's not
a big problem.

### reporting like volume attach limit feature

xref: https://github.com/kubernetes/kubernetes/issues/69502
