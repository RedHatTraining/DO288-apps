#!/bin/bash

cd ~/DO288/labs/compreview-todo
helm create todo-list
cd todo-list

cat <<EOF>> Chart.yaml
dependencies:
  - name: mariadb
    version: 11.3.3
    repository: http://helm.ocp4.example.com/charts
EOF

helm dependency update

sed -i "s/repository: nginx/repository: registry.ocp4.example.com:8443\/redhattraining\/todo-backend/g" values.yaml
sed -i "s/pullPolicy: IfNotPresent/pullPolicy: Always/g" values.yaml
sed -i 's/tag: ""/tag: "release-46"/g' values.yaml
sed -i "s/port: 80/port: 3000/g" values.yaml

cat <<EOF>> values.yaml

mariadb:
  auth:
    username: todouser
    password: todopwd
    database: tododb
  primary:
    podSecurityContext:
      enabled: false
    containerSecurityContext:
      enabled: false
  global:
    imageRegistry: "registry.ocp4.example.com:8443"
  image:
    repository: redhattraining/mariadb
    tag: 10.5.10-debian-10-r0

env:
  - name: DATABASE_NAME
    value: tododb
  - name: DATABASE_USER
    value: todouser
  - name: DATABASE_PASSWORD
    value: todopwd
  - name: DATABASE_SVC
    value: todo-list-mariadb
EOF

sed -i '43i\          env:\n            {{- range .Values.env }}\n          - name: {{ .name }}\n            value: {{ .value }}\n            {{- end }}' templates/deployment.yaml

oc login -u developer -p developer https://api.ocp4.example.com:6443

oc project compreview-todo

helm install todo-list .

oc expose svc/todo-list
