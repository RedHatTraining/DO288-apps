#!/usr/bin/env bash

IMAGE=quay.io/redhattraining/ocpdev-builds-triggers-hello:v2

podman build -t ${IMAGE} .

podman push ${IMAGE}
