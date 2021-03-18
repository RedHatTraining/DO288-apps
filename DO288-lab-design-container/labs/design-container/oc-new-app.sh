#!/bin/sh

source /usr/local/etc/ocp4.config

oc new-app  --as-deployment-config --name elvis \
    "https://github.com/${RHT_OCP4_GITHUB_USER}/DO288-apps#design-container" \
    --context-dir hello-java
