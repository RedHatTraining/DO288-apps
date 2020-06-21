#!/bin/bash

source /usr/local/etc/ocp4.config

cd /home/student/DO288-apps/nexus3

sudo podman build -t nexus3 .

sudo podman login -u ${RHT_OCP4_QUAY_USER} quay.io

sudo skopeo copy \
       containers-storage:localhost/nexus3  \
       docker://quay.io/${RHT_OCP4_QUAY_USER}/nexus3

