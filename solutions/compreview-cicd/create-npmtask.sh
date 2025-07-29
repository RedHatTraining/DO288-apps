#!/bin/bash

oc login -u developer -p developer https://api.ocp4.example.com:6443
oc project compreview-cicd

cd ~/DO288/labs/compreview-cicd
oc apply -f npm-task.yaml

sed -i '0,/# TODO/ s/# TODO/taskRef:\n        resolver: cluster\n        params:\n          - name: kind\n            value: task\n          - name: name\n            value: git-clone\n          - name: namespace\n            value: openshift-pipelines/' pipeline.yaml
sed -i '0,/# TODO/ s/# TODO/- name: URL\n          value: \$\(params.GIT_REPO\)\n        - name: REVISION\n          value: \$\(params.GIT_REVISION\)/' pipeline.yaml
sed -i '0,/# TODO/ s/# TODO/- name: output\n          workspace: shared/' pipeline.yaml

sed -i '0,/# TODO/ s/# TODO/taskRef:\n        name: npm\n        kind: Task\n      workspaces:\n        - name: source\n          workspace: shared\n      params:\n        - name: CONTEXT\n          value: \$\(params.APP_PATH\)\n        - name: ARGS\n          value: install --no-package-lock\n      runAfter:\n        - fetch-repository/' pipeline.yaml
sed -i '0,/# TODO/ s/# TODO/taskRef:\n        name: npm\n        kind: Task\n      workspaces:\n        - name: source\n          workspace: shared\n      params:\n        - name: CONTEXT\n          value: \$\(params.APP_PATH\)\n        - name: ARGS\n          value: test\n      runAfter:\n        - npm-install/' pipeline.yaml
sed -i '0,/# TODO/ s/# TODO/taskRef:\n        name: npm\n        kind: Task\n      workspaces:\n        - name: source\n          workspace: shared\n      params:\n        - name: CONTEXT\n          value: $(params.APP_PATH)\n        - name: ARGS\n          value: run lint\n      runAfter:\n        - npm-install/' pipeline.yaml
sed -i '0,/# TODO/ s/# TODO/taskRef:\n        resolver: cluster\n        params:\n          - name: kind\n            value: task\n          - name: name\n            value: buildah\n          - name: namespace\n            value: openshift-pipelines\n      params:\n        - name: IMAGE\n          value: \$\(params.IMAGE_REGISTRY\)\/\$\(context.pipelineRun.namespace\)\/\$(params.IMAGE_NAME\)\:\$\(context.pipelineRun.uid\)\n        - name: DOCKERFILE\n          value: \.\/Containerfile\n        - name: CONTEXT\n          value: \$\(params.APP_PATH\)\n      workspaces:\n        - name: source\n          workspace: shared\n      runAfter:\n        - npm-test\n        - npm-lint/' pipeline.yaml
sed -i '0,/# TODO/ s/# TODO/taskRef:\n        resolver: cluster\n        params:\n          - name: kind\n            value: task\n          - name: name\n            value: openshift-client\n          - name: namespace\n            value: openshift-pipelines\n      workspaces:\n        - name: manifest_dir\n          workspace: shared\n      params:\n        - name: SCRIPT\n          value: |\n            oc process -f \$\(params.APP_PATH\)\/kubefiles\/app.yaml \\\n            -p IMAGE_NAME=\$\(params.IMAGE_REGISTRY\)\/\$\(context.pipelineRun.namespace\)\/\$\(params.IMAGE_NAME\)\:\$\(context.pipelineRun.uid\) \\\n            | oc apply -f -\n      runAfter:\n        - build-push-image/' pipeline.yaml

oc apply -f pipeline.yaml
