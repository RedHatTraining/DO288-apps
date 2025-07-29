#!/bin/bash

oc login -u developer -p developer https://api.ocp4.example.com:6443

oc apply -f basic-user-pass.yaml
oc secret link pipeline basic-user-pass
tkn pipeline start --use-param-defaults words-cicd-pipeline -p APP_PATH=apps/compreview-cicd/words -w name=shared,volumeClaimTemplateFile=volume-template.yaml
