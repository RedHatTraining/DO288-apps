#!/bin/bash

source scl_source enable rh-nginx18
exec nginx -g "daemon off;"
