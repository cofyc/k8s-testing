#!/usr/bin/env python

import cephfs
import rados
import sys

conf_path = "/etc/ceph/ceph.conf"
cluster_name = "ceph"
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

keys = [
    "ceph.dir.layout.pool",
    "ceph.dir.layout.pool_namespace",
    "ceph.quota.max_bytes",
    "ceph.quota.max_files"
]

for arg in sys.argv[1:]:
    for key in keys:
        print("print {}@{}".format(key, arg))
        try:
            value = fs.getxattr(arg, key)
            print(type(value), ",", value)
        except cephfs.NoData:
            print(type(value), ",", "<no data>")
