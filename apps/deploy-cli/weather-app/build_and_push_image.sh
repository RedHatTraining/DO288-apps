#!/usr/bin/env bash

IMAGE=quay.io/redhattraining/openshift-dev-deploy-cli-weather:1.0

podman build -t ${IMAGE} .

podman push ${IMAGE}
