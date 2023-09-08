#!/usr/bin/env bash

IMAGE=quay.io/redhattraining/openshift-dev-deploy-console-todo-list

podman build -t ${IMAGE} .

podman push ${IMAGE}
