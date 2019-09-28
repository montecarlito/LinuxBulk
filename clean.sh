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
