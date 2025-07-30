#!/bin/bash

oc login -u developer -p developer https://api.ocp4.example.com:6443

oc project compreview-todo

oc new-app \
  https://git.ocp4.example.com/developer/DO288-apps \
  --name todo-ssr --context-dir=/apps/compreview-todo/todo-ssr --build-env \
  npm_config_registry="http://nexus-infra.apps.ocp4.example.com/repository/npm"

oc create configmap todo-ssr-host --from-literal API_HOST="http://todo-list:3000"
oc set env deployment/todo-ssr --from cm/todo-ssr-host
oc expose svc/todo-ssr