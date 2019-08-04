#!/bin/sh

curl -siu admin:admin123 http://localhost:8081/service/metrics/healthcheck | grep healthy | grep true
RESPONSE=$?

if [ "$RESPONSE" = "0" ] ; then
  echo "******** liveness is Alive ********"
  exit 0;
else
  echo "******** liveness is Dead ********"
  exit 1;
fi

