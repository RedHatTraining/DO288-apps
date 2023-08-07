#!/bin/bash

# get timer and retries from env
if [ "$HOOK_RETRIES" = "" ]; then
  HOOK_RETRIES=0
fi
if [ "$HOOK_SLEEP" = "" ]; then
  HOOK_SLEEP=2
fi

cd /tmp

echo "Trying $HOOK_RETRIES times, sleeping $HOOK_SLEEP sec between tries:"
while [ "$HOOK_RETRIES" != 0 ]; do

  echo -n 'Checking if MySQL is up...'
  if mysqlshow -h$USERS_DB_SERVICE_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD -P3306 $MYSQL_DATABASE &>/dev/null
  then
    echo 'Database is up'
    break
  else
    echo 'Database is down'

    # Sleep to wait for the MySQL pod to be ready
    sleep $HOOK_SLEEP
  fi
  
  let HOOK_RETRIES=HOOK_RETRIES-1
done

if [ "$HOOK_RETRIES" = 0 ]; then
  echo 'Too many tries, giving up'
  exit 1
fi

# Run the SQL script
if mysql -h$USERS_DB_SERVICE_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD -P3306 $MYSQL_DATABASE < /post-deploy/users.sql

then
  echo 'Database initialized successfully'
else
  echo 'Failed to initialize database'
  exit 2
fi

