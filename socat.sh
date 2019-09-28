#!/bin/bash

H1=10.1.0.2
H3=10.2.0.2

echo "SOCAT Transfer" > SOCAT1.txt

# Ref: https://artkond.com/2017/03/23/pivoting-guide/#socat
#      http://www.bitkistl.com/2016/03/socat-by-example.html

# Create server
socat tcp-l:1234,reuseaddr,fork file:SOCAT1.txt &
LISTENER=$!

# Create client
ssh student@${H3} "socat tcp:${H1}:1234 file:SOCAT3.txt,create"

# Kill server
kill $LISTENER

# Check file
ssh student@${H3} "ls -l SOCAT3.txt; cat SOCAT3.txt"
