#!/bin/bash

# kubectl patch controllerrevisions web-6fb9776868 -p '{"metadata": {"ownerReferences":null}}'
# kubectl label controllerrevisions web-6fb9776868 app-
curl -H "Accept: application/json" -H "Content-Type: application/json" -X DELETE localhost:8080/apis/apps/v1/namespaces/default/statefulsets/web -d '{"kind":"DeleteOptions","apiVersion":"v1","propagationPolicy":"Orphan"}'
