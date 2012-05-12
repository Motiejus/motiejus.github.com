---
layout: post
date: 2012-05-12T17:43:45+00:00
title: Goodies in BitTorrent specifications
---

While looking through BitTorrent [specifications], I noticed two parameters
which are sent by leecher/seeder to tracker:

    uploaded
        The total amount uploaded so far, encoded in base ten ascii.
    downloaded
        The total amount downloaded so far, encoded in base ten ascii.

Reminds me freedom of `RCPT FROM:` in SMTP if taken in appropriate context. :-)
I promise you a beer for a patch in libtorrent which (configurably) exploits
this value. Put it on github and write me. :-)

[specifications]: http://www.bittorrent.org/beps/bep_0003.html
