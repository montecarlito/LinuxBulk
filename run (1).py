#!/usr/bin/env python

import netifaces
from scapy.all import *

# Ref: https://stackoverflow.com/a/159150
src_nic = "enp0s3"
src_mac = netifaces.ifaddresses(src_nic)[netifaces.AF_LINK][0]['addr']
src_ip = netifaces.ifaddresses(src_nic)[netifaces.AF_INET6][0]['addr'].split('%')[0]

# Ref: http://www.packetlevel.ch/html/scapy/scapyipv6.html
#      https://samsclass.info/ipv6/proj/projL3-scapy-ra.html
#      https://en.wikipedia.org/wiki/Multicast_address
a = IPv6(dst="ff02::1", src=src_ip)
b = ICMPv6ND_RA()
c = ICMPv6NDOptSrcLLAddr(lladdr=src_mac)
d = ICMPv6NDOptMTU()
e = ICMPv6NDOptPrefixInfo(prefix="cc5f::", prefixlen=64)

send(a/b/c/d/e, iface=src_nic)
