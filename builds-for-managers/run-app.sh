#!/bin/sh

echo "Starting wildfly swarm app..."
echo "JVM options => $JAVA_OPTIONS"
echo

java $JAVA_OPTIONS -jar /opt/app-root/bin/builds-for-managers.jar
