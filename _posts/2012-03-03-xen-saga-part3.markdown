---
layout: post
date: 2012-03-03T22:24:00+00:00
title: Xen saga, part 3
---

When building Xen-4.1 on Squeeze, xen-utils-4.1 has this dependency list:

      Depends: e2fslibs (>= 1.41.0), libc6 (>= 2.7), libgnutls26 (>= 2.7.14-0),
      libncurses5 (>= 5.7+20100313), libpci3 (>= 1:3.1.7), libuuid1 (>= 2.16),
      libxen-4.1 (>= 4.1.2), libxenstore3.0 (>= 4.0.1~rc4), zlib1g (>=
      1:1.1.4), python (>= 2.6.6-3+squeeze3~), python (<< 2.6),
      xen-utils-common (>= 3.4.2-4)

Seems to be related to [#644573][bugreport], however, I could not trace it and
fix it properly. For testing I as a workaround I manually removed `python (<<
2.6)` dependency from `xen-utils-4.1_4.1.2-2_amd64.deb`. This rendered
`xen-utils-4.1 installable`.

After successful xen-4.1 stack installation I fired up virt-install:

    motiejus@skveez> virt-install --name=chef-server --nographics --paravirt
    --ram=512 --location=/home/motiejus/stuff/install/debxen/
    --disk=/home/motiejus/stuff/chefDemoServer.dat,size=10,format=raw

    Starting install...
    Retrieving file MANIFEST...
    Retrieving file vmlinuz...
    Retrieving file initrd.gz...
    ERROR    POST operation failed: xend_post: error from xen daemon: (xend.err
        'Device 0 (vif) could not be connected. Hotplug scripts not working.')
        Domain installation does not appear to have been successful.
    If it was, you can restart your domain by running:
      virsh --connect xen:/// start chef-server

Same story with Xen-4.0. Neither solution, nor workaround. Further steps:

1. Try same thing on fresh Debian Testing installation (thanks chroot)
2. Use native Xen utils without libvirt for testing
3. Ping Xen mailing list

Update 2012-03-04 00:17:

Xen in chroot yields exactly the same result. However, quick run of
xen-create-image (from xen-utils) yields a promising result. My suspision is
Xen isn't really libvirt friendly.

Part 4 will be about xen-utils.

P.S. initial KVM setup with Ubuntu Lucid took around 2 hours including:

* Server installation
* First virtual machine installation (virt-install) to an lvm volume
* Simple networking configuration

All using libvirt, around 6 moths ago. Xen apparently needs a bit more fight,
at least with \*deb-based. I suppose it would be less hassle with
CentOS/RHEL/Fedora; Citrix XenServer RHEL based, anyway.

[bugreport]: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=644573
