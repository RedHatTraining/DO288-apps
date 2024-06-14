#!/bin/bash

rm -rf /home/student/DO288

mkdir /home/student/DO288

cd /home/student/DO288

git clone https://git.ocp4.example.com/developer/DO288-apps.git

cd /home/student/DO288/DO288-apps

find . -name "pom.xml" \
   -execdir podman run --rm -v ./:/app:z -v ${HOME}/.m2/repository:/m2:z \
   -w /app docker.io/library/maven:3.8.1-openjdk-17 \
   mvn  -Dmaven.repo.local=/m2 -Dmaven.test.failure.ignore=true -T2 clean dependency:go-offline package \;
