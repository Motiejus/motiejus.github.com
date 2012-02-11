---
date: 2010-09-17T03:45:00+01:00
---

I live in Murano Street Student Village (MSSV). Internet is great here, but,
unfortunately, there is one annoying thing: every time you turn on your
computer, in order to have internet, you have to:

* Open up your browser
* Take your mouse (or move a finger to touchpad)
* Aim to the "log in" button
* Press the button

It's too much for me.

This is how to avoid it. Create an executable script in /etc/network/if-up.d/
(or something like that) with contents like this:

{% highlight sh %}
#!/bin/sh
USERNAME="your_username" # urlencoded
PASSWORD="your_password" # urlencoded
if [ "$IP4_NAMESERVERS" = "109.246.240.1" ]; then
  curl http://login.keycom.co.uk:8080/goform/HtmlLoginRequest \
    -d"login=Sign%20in&amp;password=${PASSWORD}&amp;username=${USERNAME}" 2>&1 | logger
fi
{% endhighlight %}

If it doesn't work, check your DNS server and adjust the script. See
/var/log/messages for more information.
