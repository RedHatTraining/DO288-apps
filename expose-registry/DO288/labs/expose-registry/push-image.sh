#!/bin/bash

source /usr/local/etc/ocp4.config

INTERNAL_REGISTRY=$( oc get route default-route \
   -n openshift-image-registry -o jsonpath='{.spec.host}' )

TOKEN=$(oc whoami -t)

skopeo copy \
    --dest-creds=${RHT_OCP4_DEV_USER}:${TOKEN} \
    oci:/home/student/DO288/labs/expose-registry/ubi-info \
    docker://${INTERNAL_REGISTRY}/${RHT_OCP4_DEV_USER}-common/ubi-info:1.0
