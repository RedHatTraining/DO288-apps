#!/bin/bash

source /usr/local/etc/ocp4.config

skopeo copy \
    oci:/home/student/DO288/labs/expose-image/php-info \
    docker://quay.io/${RHT_OCP4_QUAY_USER}/php-info

