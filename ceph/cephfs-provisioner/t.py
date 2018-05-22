#!/usr/bin/env python

import cephfs
import rados

conf_path ="/etc/ceph/ceph.conf"
cluster_name="ceph"
auth_id = "admin"
rados = rados.Rados(
    name="client.{0}".format(auth_id),
    clustername=cluster_name,
    conffile=conf_path,
    conf={}
)
rados.connect()

fs = cephfs.LibCephFS(rados_inst=rados)
fs.init()
fs.mount()

#path = "/volumes/kubernetes/kubernetes-dynamic-pvc-3f412768-28cf-11e8-a68d-92b2949f6327"
path = "/volumes/kubernetes/kubernetes-dynamic-pvc-5a490697-28ee-11e8-bb2e-0242ac110002"

print("print pool")
pool = fs.getxattr(path, "ceph.dir.layout.pool")
print(type(pool), ",", pool)
print("print namespace")
namespace = fs.getxattr(path, "ceph.dir.layout.pool_namespace")
print(type(namespace), ",", namespace)
#print(fs.setxattr(path, "ceph.dir.layout.pool_namespace", "", 0))
#namespace = fs.getxattr(path, "ceph.dir.layout.pool_namespace")
#print(namespace)
