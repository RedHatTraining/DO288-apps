#!/bin/env bash

oc new-app --name vertx-site \
  --build-env MAVEN_MIRROR_URL=http://nexus-infra.apps.ocp4.example.com/repository/java \
  --env JAVA_APP_JAR=vertx-site-1.0.0-SNAPSHOT-fat.jar \
  -i redhat-openjdk18-openshift:1.8 \
  --context-dir builds-applications/apps/vertx-site \
  https://git.ocp4.example.com/developer/DO288-apps
