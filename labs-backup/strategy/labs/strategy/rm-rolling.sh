#!/bin/bash

oc patch dc/mysql --type=json \
    -p='[{"op":"remove", "path": "/spec/strategy/rollingParams"}]'
