#!/bin/bash

H1=10.1.0.2
H3=10.2.0.2

# Create file on H3
ssh student@${H3} 'echo "NETCAT Transfer" > NETCAT3.txt'

# Create listener on H1
nc -l -p 1234 > NETCAT1.txt &
LISTENER=$!

# Send file
ssh student@${H3} 'nc -w3 10.1.0.2 1234 < NETCAT3.txt'

wait $LISTENER

# Check file
ls -l NETCAT1.txt
cat NETCAT1.txt
