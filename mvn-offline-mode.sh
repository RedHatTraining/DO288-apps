#!/bin/bash

rm -rf /home/student/DO288

mkdir /home/student/DO288

cd /home/student/DO288

git clone https://git.ocp4.example.com/developer/DO288-apps.git

cd /home/student/DO288/DO288-apps

find . -name "pom.xml" \
        -execdir /opt/apache-maven/bin/mvn clean dependency:go-offline test -Dmaven.test.failure.ignore=true package \;
