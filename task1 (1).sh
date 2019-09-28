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

ssh -NT -L 9001:localhost:80 student@${H3} &
TUNNEL=$!
sleep 1

curl http://localhost:9001

kill $TUNNEL
wait $TUNNEL 2>/dev/null
