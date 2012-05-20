---
layout: post
date: 2012-05-20T22:48:00+02:00
title: Dual architecture on Debian Live
---

[System Rescue CD][sysrescuecd] has a feature which I other "live"
distributions are lacking: amd64 and i386 dual booting. It means you can boot
both amd64 and i386 userspace from a single disk without having 2 copies of all
the programs.

But why on earth would you need to run 64-bit kernel while rescuing the system?
Because if it already has 64-bit Linux installed, you would appreciate
chrooting. This is why System Rescue CD flexibility helps.

How does this work? Well, you just boot a 64 bit kernel and run 32-bit
programs. Not a big deal, because all you want from amd64 is chroot. And you
can do it.

This is how to do it with debian-live. Just add `linux-image-2.6-amd64` to
`--packages`. So `lb_config` looks like this:

<code>lb config --distribution squeeze --packages-list "rescue lxde" --packages "linux-image-2.6-amd64 kpartx" --architecture i386 -b net --mirror-bootstrap http://ftp.lt.debian.org/debian --apt-http-proxy http://127.0.0.1:3142</code>

Then take 64-bit vmlinuz and initrd from the squashfs filesystem image, and
boot them. Tested, it works. Enjoy! :)

[sysrescuecd]: http://www.sysresccd.org
