#!/bin/bash

cd ~/DO288/labs/compreview-todo/todo-frontend

sed -i '29i\\nEXPOSE 8080\n\nUSER nginx' Containerfile

podman login -u developer -p developer registry.ocp4.example.com:8443
podman build . -t registry.ocp4.example.com:8443/developer/todo-frontend:latest
podman push registry.ocp4.example.com:8443/developer/todo-frontend

oc login -u developer -p developer https://api.ocp4.example.com:6443

oc project compreview-todo

oc new-app registry.ocp4.example.com:8443/developer/todo-frontend
oc expose svc/todo-frontend