#!/bin/bash

oc set volume dc/quotesdb --add --overwrite \
    --name quotesdb-volume-1 -t pvc --claim-name quotesdb-claim \
    --claim-size 300Mi --claim-mode ReadWriteOnce
