#!/bin/bash

H1=10.1.0.2
H3=10.2.0.2
DMZ=10.3.0.2
PROXY_PORT=1234
SCAN_PORTS="22 23 21 80"

# Create tunnel
ssh -NT -D ${PROXY_PORT} student@${H3} 2>/dev/null &
TUNNEL=$!
sleep 1

# Scan ports
for port in $SCAN_PORTS; do
  # Fedora
  # nc --proxy localhost:${PROXY_PORT} --proxy-type socks5 -vz ${DMZ} ${port}

  # Ubuntu
  output=$(nc -x localhost:${PROXY_PORT} -X 5 -vz ${DMZ} ${port} 2>&1)
  if [[ $? == 0 ]] && [[ "$output" =~ "succeeded" ]]; then
    echo "$output"
  fi
done

# Kill tunnel
kill ${TUNNEL}
wait ${TUNNEL} 2>/dev/null
