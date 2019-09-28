#!/bin/bash

#Send secretsquirrelstuff.txt from H1 to the DMZ Client. H3 will be the relay.
# You can ONLY make outbound connections on H1, and you can ONLY make inbound
# connections on the DMZ client.
#
# Create a file on the H1 client named "secretsquirrelstuff.txt" and write the
# message "awww nuts" into the file. You will be sending this to the DMZ client
# through a relay on H3.
#
# For the transfer of "secretsquirrelstuff", the relay for H3 should be
# configured to ensure the H1 is making an outbound connection, while the DMZ
# Client is making an inbound connection.

set -x

H1=10.1.0.2
H3=10.2.0.2
DMZ=10.3.0.2

FILE=secretsquirrelstuff.txt
SNDPORT=1234
RCVPORT=4321

# Create file
echo "awww nuts" > ${FILE}

# Create listener on DMZ
ssh student@${DMZ} "nc -l -p ${RCVPORT} > ${FILE}" &
DMZ_LISTENER=$!
sleep 1

# Create relay on H3
ssh student@${H3} "nc -l -p ${SNDPORT} | nc ${DMZ} ${RCVPORT}" &
H3_RELAY=$!
sleep 1

# Send file
nc -w3 ${H3} ${SNDPORT} < ${FILE}

# Kill relay
kill $DMZ_LISTENER $H3_RELAY
wait $DMZ_LISTENER 2>/dev/null
wait $H3_RELAY 2>/dev/null

# Check file
ssh student@${DMZ} "ls -l ${FILE}; cat ${FILE}"
