#!/bin/bash

oc patch dc/mysql --patch \
    '{"spec":{"strategy":{"type":"Recreate"}}}'
