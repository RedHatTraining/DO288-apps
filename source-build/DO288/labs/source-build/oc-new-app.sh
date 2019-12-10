#!/bin/sh
source /usr/local/etc/ocp4.config

oc new-app --name greet \
    --build-env npm_config_registry=\
http://${RHT_OCP4_NEXUS_SERVER}/repository/nodejs \
    "nodejs:10~https://github.com/${RHT_OCP4_GITHUB_USER}/DO288-apps#source-build" \
    --context-dir nodejs-helloworld
