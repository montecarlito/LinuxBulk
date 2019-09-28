#!/bin/bash

# Check if root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

if ! grep -q '^iface enp0s3 inet6 static'; then
    echo -e ''
fi
