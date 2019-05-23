#!/bin/bash

echo '--- Host name:'
#cat /proc/sys/kernel/hostname
hostname
echo
echo '--- Free memory'
free -h
echo
echo '--- Mounted file systems (partial)'
df -h
