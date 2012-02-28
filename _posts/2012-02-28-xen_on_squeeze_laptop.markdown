---
layout: post
date: 2012-02-28T19:41:00+00:00
title: Xen on squeeze laptop
---

Motivation
----------

This is the first series of adventures trying to run Xen on a stable Squeeze
machine, doing as few work as possible. My final goal is:

* bootstrap new VMs using virt-install
* have some kind of networking (ideally, a bridge in the hypervisor so I
  can manually configure iptables masquerading)

As few work as possible -- no compiling, as few as possible configuration file
changes, no hacks. I am aiming for a clean installation, since will have to
create a chef script for that.

Process
-------

Since Linux 3.0 you do not need an other kernel, everything's merged well
enough. Just install xen and friends:

    xen-hypervisor-4.0 xen-tools xen-utils-4.0 xenstore-utils virtinst xen-docs-4.0 libvirt-bin

Short [configuration reference][config]. Configure this line:

    (xend-unix-server yes)

So we can use xen from libvirt. Default libvirt network suits fine, so change this as well:

    (vif-script 'vif-bridge bridge=virbr0')

Download bootstrap images:

     wget -rl0 -np ftp://ftp.lt.debian.org/debian/dists/squeeze/main/installer-amd64/

And install:

    virt-install --name=chef-server --file-size=10 --nographics --paravirt --ram=512 \
                        --file=/install/debian-6.0.4-amd64-businesscard.iso \
                        --location=/install/debxen/installer-amd64/

Hacks
-----

Haha.

* Install libvirt-bin from squeeze-backports while trying to work around this:
    
    ERROR    POST operation failed: xend_post: error from xen daemon: (xend.err 'Device 0 (vif) could not be connected. Hotplug scripts not working.')

* then new libvirt mangles up the paths. mkdir /var/lib/xen/ because of

    ERROR    Could not start storage pool: cannot open path '/var/lib/xen': No such file or directory

* apt-get install -t sid xen-utils-common because of:

    Feb 28 21:24:37 skveez udevd-work\[6494\]: '/etc/xen/scripts/block' (stderr) '/etc/xen/scripts/xen-hotplug-common.sh: line 20: /etc/xen/scripts/hotplugpath.sh: No such file or directory'

After that I realized I was looking to the wrong direction. My syslog pointed me:

    /etc/xen/scripts/block: Writing backend/vbd/11/51712/hotplug-error Path closed or removed during hotplug add: backend/vbd/11/51712 state: 1 backend/vbd/11/51712/hotplug-status error to xenstore.

Well.. quick googling found [this][2]. I do not want to upgrade to xen-4.1 [why not?][3].

[To be continued...][bugreport]

[config]: http://blog.penumbra.be/2010/02/xen-libvirt-debian-lenny/
[2]: http://lists.fedoraproject.org/pipermail/xen/2011-February/005369.html
[3]: http://lists.debian.org/debian-devel/2012/02/msg00159.html
[bugreport]: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=644573
