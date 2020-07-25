#!/bin/bash

oc new-app --name mysql \
    -e MYSQL_USER=test -e MYSQL_PASSWORD=redhat -e MYSQL_DATABASE=testdb \
    --docker-image registry.access.redhat.com/rhscl/mysql-57-rhel7
