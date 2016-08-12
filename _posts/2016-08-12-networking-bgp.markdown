---
layout: post
date: 2016-08-12T10:07:00+00:00
title: My learnings on how internet routing works
---

During a dinner with a bunch of hackers, we started talking about intricacies
of virtual networking, and I realized I know almost nothing about routing. :(
So I spent some time reading BGP, and another 30 minutes summarizing it.

Background: life of a Packet
---

Let's say you are sending packet from host h1 (10.0.1.100/24) to host h2
(10.0.2.100/24). There are routers r1 (10.0.1.1/24) and r2 (10.0.2.1/24), which
are directly connected over L2 network (that is, there can be switches in
between, but routes are "direct").

h1: OS looks at the destination of the packet: it is outside of my network
(i.e. not in 10.0.1.0/24), so intends to send it to the "default route" which
is r1 over eth0. OS sends the ARP packet through eth0 to find out the MAC
address of the router, gets a reply, and constructs an IP packet like this:

    dst mac: mac of r1
    dst ipport: 10.0.2.100:80
    src mac: mac of h1
    src ipport: 10.0.1.100:60000

`r1` receives the packet, notices that it has a static route to 10.0.2.0/24,
and rewrites the packet to:

    dst mac: mac of r2
    dst ipport 10.0.2.100:80
    src mac: mac of r1
    src ipport 10.0.1.100:60000

`r2` receives the packet, notices that it's in it's local network, and rewrites
the packet to:

    dst mac: mac of h2
    dst ipport 10.0.2.100:80
    src mac: mac of r2
    src ipport 10.0.1.100:60000

`h2` receives the packet! Note that src ip (and port, but omitted) is still
there, so it can send a reply like this:

   dst mac: mac of r2
   dst ipport 10.0.1.100:60000
   src mac: mac of h2
   src ipport 10.0.2.100:80
   
We are interested in configuration between r1 and r2. Both routers know they
can reach each other directly though some kind of "eth5" (there is a static
route). Things get a little more complex when there can be also r3, which is
reachable only through r2:

    r1 <-> r2 directly.
    r1 <-> r3 through r2.
    r2 <-> r1 directly.
    r2 <-> r3 directly.

Without BGP or another routing protocol, these routes "who goes from where
through what" would need to be configured manually. If you have <5 routers, it
is fine, but quickly goes out of hand. That's where BGP comes into play: given
a set of direct router connections (in this example, input for BGP: r1 <-> r2,
r2 <-> r3), it figures out for r1 that there is a route to r3 through r2, and
makes all the participants aware of it. There are 347'604 distinct
[prefixes][1] on the internet as of 2016-08-12.

Remember: BGP only gossips information on who is connected to who, and updates
the operating system's routing tables. BGP does not do routing: it's just a
gossip protocol, which means, it can be implemented in anything.

BGP
---

From [source][2]: BGP is the routing protocol that runs the Internet. It is an
increasingly popular protocol for use in the data center as it lends itself
well to the rich interconnections in a Clos topology (circuit switching. I.e.
no ring, but just a bunch of connected links, just like current internet looks
like. See an image in [wikipedia][3] -- real mess).

Glossary:

* AS -- Autonomous Zone -- let's say an Internet Service Provider.
* ASN -- Autonomous Zone Number. 32-bit integer globally uniquely identifying
  the AS. ASNs between 64512 and 65535 are reserved for private use.
* iBGP -- internal BGP. Usually used for internal traffic within AS.
* eBGP -- external BGP. Used in Internet.
* CIDR ip block, e.g. 10.0.0.0/8, 192.168.0.1/24.

Main differences between iBGP and eBGP:

* in iBGP, the ASN is the same for all peers.
* in iBGP, no routing information is forwarded, routers are expected to send
  all routing information to all other routers (there are ways around it in a
  large network by using layers, aka Route Reflectors, but that's performance
  optimization/implementation details).
* The rest should be about the same.

BGP setup
---

Remember, inputs to BGP are a direct connections between routers. BGP figures
out the rest itself by gossiping the route information to other peers.

BGP is exchanged over TCP, so an existing ip network between routers is
required before the gossip can start.

Before a BGP route is established, two admins (one for each AS) go to IRC and
agree a /30 CIDR (4 addresses in total) in from one of the sides.

For each router in each AS:

* Assign the "self" ASN and the advertised CIDR(s). E.g. 101 and 102.
* Assign a static IP from the /30 of one of the ASs.
* Configure the ASN and IP of the peer.
* Start.
* Done.

As you can see, the router gossip connection and the advertised CIDRs are
completely decoupled, thus allowing advertisement of overlay networks and
further jazz.

Remember, I just learned this myself about this 20 minutes ago, so exercise
caution. [Cumulus networks published a good reading on this][2].

Hopefully next to learn: given a set of routes (say, you can reach a CIDR via
leg A, B, C, D), how does the router choose where to send traffic through?

Motiejus

[1]: http://www.cidr-report.org/as2.0/
[2]: https://docs.cumulusnetworks.com/display/DOCS/Border+Gateway+Protocol+-+BGP
[3]: https://en.wikipedia.org/wiki/Clos_network
