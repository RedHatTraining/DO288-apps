#!/bin/env bash

oc new-app --name vertx-site \
  --build-env MAVEN_MIRROR_URL=http://nexus-infra.apps.ocp4.example.com/repository/java \
  -i redhat-openjdk18-openshift:1.8 \
  --context-dir builds-applications/apps/vertx-site \
  https://git.ocp4.example.com/developer/DO288-apps
