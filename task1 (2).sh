#!/bin/bash

# Send secretstuff.txt from H1 to the DMZ Client. H3 will be the relay. You
# CANNOT make outbound connections on H3.
#
# Create a file named "secretstuff.txt" on the H1 host. Write the message
# "This is important information" into the file. You will be sending this to
# the DMZ host through a relay at H3.
#
# For the transfer of "secretstuff", H3 cannot make outbound connections.

set -x

H1=10.1.0.2
H3=10.2.0.2
DMZ=10.3.0.2

FILE=secretstuff.txt
SNDPORT=1234
RCVPORT=4321

# Create file
echo "This is important information" > ${FILE}

# Create relay on H3
ssh student@${H3} "nc -l -p ${SNDPORT} | nc -l -p ${RCVPORT}" &
H3_RELAY=$!
sleep 1

# Send file
nc -w3 ${H3} ${SNDPORT} < ${FILE}

# Receive file
ssh student@${DMZ} "nc -w3 ${H3} ${RCVPORT} > ${FILE}"

# Kill relay
kill $H3_RELAY 2>/dev/null

# Check file
ssh student@${DMZ} "ls -l ${FILE}; cat ${FILE}"
