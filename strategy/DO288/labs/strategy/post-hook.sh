#!/bin/bash

oc patch dc/mysql --patch '{"spec":{"strategy":{"recreateParams":{"post":{"failurePolicy": "Abort","execNewPod":{"containerName":"mysql","command":["/bin/sh","-c","curl -L -s https://github.com/RedHatTraining/DO288-apps/releases/download/OCP-4.1-1/import.sh -o /tmp/import.sh&&chmod 755 /tmp/import.sh&&/tmp/import.sh"]}}}}}}'
