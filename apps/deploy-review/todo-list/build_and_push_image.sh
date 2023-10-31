#!/usr/bin/env bash

IMAGE=quay.io/redhattraining/openshift-dev-deploy-review-todo-list

podman build -t ${IMAGE} .

podman push ${IMAGE}
