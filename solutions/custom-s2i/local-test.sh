#!/bin/sh

sudo podman run --name go-test -u 1234 \
    -p 8080:8080 -d s2i-go-app
