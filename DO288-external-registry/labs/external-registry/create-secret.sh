#!/bin/bash

oc create secret generic quayio \
    --from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json \
    --type=kubernetes.io/dockerconfigjson

