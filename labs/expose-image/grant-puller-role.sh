#!/bin/bash

source /usr/local/etc/ocp4.config

oc policy add-role-to-group  \
    -n ${RHT_OCP4_DEV_USER}-common system:image-puller \
    system:serviceaccounts:${RHT_OCP4_DEV_USER}-expose-image 

