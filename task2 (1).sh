#!/bin/bash

# Send supersecretstuff.txt from H1 to the DMZ Client. H3 will be the relay.
# You can ONLY make outbound connections on H3.
#
# Create a file on the H1 client named "supersecretstuff.txt" and write the
# message "passwords should be complex" into the file. You will be sending this
# to the DMZ client through a relay on H3.
#
# For the transfer of "supersecretstuff", H3 can only make outbound connections.

set -x

H1=10.1.0.2
H3=10.2.0.2
DMZ=10.3.0.2

FILE=supersecretstuff.txt
SNDPORT=1234
RCVPORT=4321

# Create file
echo "passwords should be complex" > ${FILE}

# Create listener on H1
nc -l -p ${SNDPORT} < ${FILE} &
H1_LISTENER=$!
sleep 2

# Create listener on DMZ
ssh student@${DMZ} "nc -l -p ${RCVPORT} > ${FILE}" &
DMZ_LISTENER=$!
sleep 2

# Create relay on H3
ssh student@${H3} "nc -w5 ${H1} ${SNDPORT} | nc -w5 ${DMZ} ${RCVPORT}"

# Kill relay
kill $H1_LISTENER $DMZ_LISTENER 2>/dev/null || :
wait $H1_LISTENER 2>/dev/null
wait $DMZ_LISTENER 2>/dev/null

# Check file
ssh student@${DMZ} "ls -l ${FILE}; cat ${FILE}"
