#!/bin/bash

source /usr/local/etc/ocp4.config

oc new-app --name quotesapi -o name \
    -e DATABASE_USER=quoteapp \
    -e DATABASE_PASSWORD=redhat \
    -e DATABASE_NAME=quotesdb \
    -e DATABASE_SERVICE_NAME=quotesdb \
    "php:7.2~https://github.com/${RHT_OCP4_GITHUB_USER}/DO288-apps" \
    --context-dir quotes
