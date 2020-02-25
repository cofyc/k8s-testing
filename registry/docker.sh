#!/bin/bash

docker run --rm -p 5000:5000 --name docker-registry-proxy -v `pwd`/config.yml:/etc/docker/registry/config.yml registry:2
