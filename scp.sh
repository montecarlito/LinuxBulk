#!/bin/bash

H1=10.1.0.2
H3=10.2.0.2

# Copy file
echo "SCP Transfer" > SCP1.txt
scp SCP1.txt student@${H3}:SCP3.txt

# Check file
ssh student@${H3} 'ls -l SCP3.txt; cat SCP3.txt'
