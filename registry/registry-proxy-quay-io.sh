#!/bin/bash

docker run --rm -p 5000:5000 --name registry-proxy-quay.io -v `pwd`/config-quay-io.yml:/etc/docker/registry/config.yml registry:2
