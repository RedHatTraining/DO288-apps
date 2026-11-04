#!/bin/env bash

oc new-app --name fortune-server \
  --image registry.lab.example.com:8443/ubi10/go-toolset:1.26.10 \
  --build-env FORTUNES=Absolutely \
  --context-dir apps/builds-applications/fortune-server \
  https://git.lab.example.com/developer/DO288-apps
