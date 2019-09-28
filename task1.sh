#!/bin/bash

H1=10.1.0.2
H3=10.2.0.2
DMZ=10.3.0.2

set -x

# Create tunnel
ssh -NT -L 8080:${DMZ}:80 student@${H3} &
TUNNEL=$!
sleep 1

# Access website
curl http://localhost:8080 2>/dev/null | head

# Kill tunnel
kill ${TUNNEL}
wait ${TUNNEL} 2>/dev/null
