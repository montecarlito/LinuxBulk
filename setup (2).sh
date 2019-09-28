#!/bin/bash

# Check if root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if [[ "$(cat /proc/sys/net/ipv4/conf/all/arp_accept)" -eq 0 ]]; then
    echo 1 > /proc/sys/net/ipv4/conf/all/arp_accept
fi

if (arp -a | grep -q "10\.1\.0\.3"); then
    arp -d 10.1.0.3
fi
#./run.py
