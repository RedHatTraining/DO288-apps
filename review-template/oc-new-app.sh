#!/bin/bash

source /usr/local/etc/ocp4.config

oc new-app  --as-deployment-config --name todo --file todo-template.yaml \
    -p APP_GIT_URL=https://github.com/ibmbcajshemi/DO288-apps \
    -p HOSTNAME=ajs-todo.c106-e-us-south-containers-cloud-ibm-com \
    -p CLEAN_DATABASE="true"
    # ADD MISSING PARAMETERS AND CHANGE PARAMETER VALUES IF NEEDED
