#!/bin/bash

source /usr/local/etc/ocp4.config

oc new-app --file=quotes-template.yaml \
    -p APP_GIT_URL=https://github.com/${RHT_OCP4_DEV_USER}/DO288-apps \
    -p PASSWORD=mypass
