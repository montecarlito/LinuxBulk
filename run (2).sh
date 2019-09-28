#!/bin/bash

H3=10.2.0.2

h1_iptables() {
    echo password | sudo -S -p '' iptables $@
}

h3_iptables() {
    ssh $H3 "echo password | sudo -S -p '' iptables $@"
}

h1_iptables -F
h3_iptables -F


# H1 client should be allowed to initiate new telnet and SSH connections.
h1_iptables -A OUTPUT -m state --state NEW -p tcp -m multiport --dports 22,23 -j ACCEPT

# H1 should also allow connections outbound to tcp/udp ports 1234, 9001, 9002, 1111, 2222 and 9050.
h1_iptables -A OUTPUT -p tcp -m multiport --dports 1234,9001,9002,1111,2222,9050 -j ACCEPT
h1_iptables -A OUTPUT -p udp -m multiport --dports 1234,9001,9002,1111,2222,9050 -j ACCEPT

# Established communications should also be allowed to ensure communications are successful.
h1_iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT

# The H3 client should be allowed to initiate new SSH, HTTP, and TCP 9001-9002 connections.
# Established communications should also be allowed to ensure communications are successful.
h3_iptables -A OUTPUT -m state --state NEW -p tcp -m multiport --dports 22,80,9001:9002 -j ACCEPT
h3_iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT

# Both H1 and H3 clients should never allow traffic to/from TCP/UDP ports 7777 and 9999.
h1_iptables -A INPUT -p tcp -m multiport --sports 7777,9999 -j DROP
h1_iptables -A INPUT -p udp -m multiport --sports 7777,9999 -j DROP
h1_iptables -A OUTPUT -p tcp -m multiport --dports 7777,9999 -j DROP
h1_iptables -A OUTPUT -p udp -m multiport --dports 7777,9999 -j DROP

h3_iptables -A INPUT -p tcp -m multiport --sports 7777,9999 -j DROP
h3_iptables -A INPUT -p udp -m multiport --sports 7777,9999 -j DROP
h3_iptables -A OUTPUT -p tcp -m multiport --dports 7777,9999 -j DROP
h3_iptables -A OUTPUT -p udp -m multiport --dports 7777,9999 -j DROP

# Deny ping (ICMP) operations on H1 and H3 hosts. (Remember ping is a two part transaction.
# You should be thorough and filter both parts)
h1_iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
h1_iptables -A INPUT -p icmp --icmp-type echo-reply -j DROP
h1_iptables -A OUTPUT -p icmp --icmp-type echo-request -j DROP
h1_iptables -A OUTPUT -p icmp --icmp-type echo-reply -j DROP

h3_iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
h3_iptables -A INPUT -p icmp --icmp-type echo-reply -j DROP
h3_iptables -A OUTPUT -p icmp --icmp-type echo-request -j DROP
h3_iptables -A OUTPUT -p icmp --icmp-type echo-reply -j DROP

# Ensure your Policy for the INPUT, OUTPUT, and FORWARD tables default policy is ACCEPT.
for policy in INPUT OUTPUT FORWARD; do
    h1_iptables -P $policy ACCEPT
    h3_iptables -P $policy ACCEPT
done

# Test Condition: Attempt to SSH between the H1 and H3 Clients (you can use non-standard
# ports such as 9999 or 7777 to test and verify the DROP rules). Ensure your IPTables
# rules are enforcing the above requirements.

