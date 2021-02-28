#!/bin/bash

oc set volume dc/myapp --add \
    -t secret -m /opt/app-root/secure \
    --name=myappsec-vol --secret-name=myappfilesec
