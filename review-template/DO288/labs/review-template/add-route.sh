#!/bin/bash

oc expose svc/todoapp \
    --hostname youruser-todo.apps.cluster.domain.example.com
