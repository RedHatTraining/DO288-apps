#!/bin/bash

source /usr/local/etc/ocp4.config

oc new-app --name nexus3 --f ~/nexus-template.yaml \
    -p HOSTNAME=nexus-${RHT_OCP4_DEV_USER}.${RHT_OCP4_WILDCARD_DOMAIN}

