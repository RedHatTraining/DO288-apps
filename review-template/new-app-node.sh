#!/bin/bash

oc new-app  --as-deployment-config --name todoapp -i nodejs:12 \
    --context-dir todo-single
    --build-env npm_config_registry=\
http://nexus-common.apps.cluster.domain.example.com/repository/nodejs \
    -e DATABASE_NAME=tododb \
    -e DATABASE_USER=todoapp \
    -e DATABASE_PASSWORD=redhat \
    -e DATABASE_SVC=tododb \
    -e DATABASE_INIT=true \
    https://github.com/yourgituser/DO288-apps
