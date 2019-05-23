#!/bin/sh

curl -si localhost:8081/nexus/service/local/repositories | grep Central
RESPONSE=$?

if [ "$RESPONSE" = "0" ] ; then
  echo "******** readiness is Alive ********"
  exit 0;
else
  echo "******** readiness is Dead ********"
  exit 1;
fi

