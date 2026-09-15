#!/bin/bash

cd ~/DO288/labs/compreview-todo/todo-frontend

sed -i '29i\\nEXPOSE 8080\n\nUSER nginx' Containerfile

podman login -u developer -p developer registry.lab.example.com:8443
podman build . -t registry.lab.example.com:8443/developer/todo-frontend:latest
podman push registry.lab.example.com:8443/developer/todo-frontend

oc login -u developer -p developer https://api.lab.example.com:6443

oc project compreview-todo

oc new-app registry.lab.example.com:8443/developer/todo-frontend
oc expose svc/todo-frontend