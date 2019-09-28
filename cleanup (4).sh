#!/bin/bash

# Local cleanup
rm -f SCP1.txt NETCAT1.txt SOCAT1.txt

# Remote cleanup
ssh student@10.2.0.2 'rm -f SCP3.txt NETCAT3.txt SOCAT3.txt'
