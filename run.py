#!/usr/bin/env python

import netifaces
from scapy.all import Ether, ARP, sendp

# Ref: https://stackoverflow.com/a/159150
src_nic = "enp0s3"
src_mac = netifaces.ifaddresses(src_nic)[netifaces.AF_LINK][0]['addr']
src_ip = netifaces.ifaddresses(src_nic)[netifaces.AF_INET][0]['addr']

e = Ether(src=src_mac, dst="ff:ff:ff:ff:ff:ff", type=0x0806)
a = ARP(op=0x01, hwsrc=src_mac, psrc=src_ip, pdst="10.1.0.3")

sendp(e/a, iface=src_nic)
