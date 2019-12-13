#!/bin/bash

oc new-app --name quotesdb -i mysql:5.7 -o name \
    -e MYSQL_USER=quoteapp \
    -e MYSQL_PASSWORD=redhat \
    -e MYSQL_DATABASE=quotesdb
