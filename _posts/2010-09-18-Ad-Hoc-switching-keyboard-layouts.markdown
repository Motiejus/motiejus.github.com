---
layout: post
date: 2010-09-18T17:46:00+01:00
title: Ad-hoc switching keyboard layouts
---

When:

* GNOME or something else does not allow you to switch keyboard layout in Xorg.conf (or udev) way
* You have 2 or more different keyboard layouts

Insert to some keyboard shortcut:

{% highlight sh %}
setxkbmap -print | perl -ne 'print $1 eq "lt" ? "us" : "lt" if $_ =~ /\+(lt|us)\+/' | xargs setxkbmap
{% endhighlight %}

Oh, and this helps on Debian based systems (tested on squeeze):

    $ cat /etc/default/keyboard 
    # Check /usr/share/doc/keyboard-configuration/README.Debian for
    # documentation on what to do after having modified this file.

    # The following variables describe your keyboard and can have the same
    # values as the XkbModel, XkbLayout, XkbVariant and XkbOptions options
    # in /etc/X11/xorg.conf.

    XKBMODEL="pc105"
    XKBLAYOUT="lt,lt"
    XKBVARIANT="us,"
    XKBOPTIONS="grp:alt_shift_toggle,grp_led:scroll"

    # If you don't want to use the XKB layout on the console, you can
    # specify an alternative keymap.  Make sure it will be accessible
    # before /usr is mounted.
    # KMAP=/etc/console-setup/defkeymap.kmap.gz
