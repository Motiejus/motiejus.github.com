---
layout: post
date: 2012-01-31T19:28:00+00:00
title: Do not listen RADVD on certain interfaces
---

University of Glasgow Computing Science department broadcasts broken ipv6
default route to LAN.  Since the host has a correct ipv6 address and route is
acquired from OpenVPN server, disabling listening of radvd requests on eth0 is
needed.

Easiest solution that works is using ip6tables ([reference]):

`ip6tables -A INPUT -d ff02::1/128 -i eth0 -p ipv6-icmp -j DROP`.


[reference]: http://comments.gmane.org/gmane.comp.security.firewalls.netfilter.general/37227 "How to block DHCPv4/v6, ARP, RADVD with ebtables/iptables on bridge?"
