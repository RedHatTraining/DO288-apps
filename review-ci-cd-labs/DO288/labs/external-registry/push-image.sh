#!/bin/sh

source /usr/local/etc/ocp4.config

skopeo copy \
    oci:/home/student/DO288/labs/external-registry/ubi-sleep \
    docker://quay.io/${RHT_OCP4_QUAY_USER}/ubi-sleep:1.0
    
