#!/bin/bash

oc new-app  --as-deployment-config --name tododb -i mysql:5.7 \
    -e MYSQL_USER=todoapp \
    -e MYSQL_PASSWORD=redhat \
    -e MYSQL_DATABASE=tododb
