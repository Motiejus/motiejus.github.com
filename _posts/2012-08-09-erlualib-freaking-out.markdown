---
layout: post
date: 2012-08-09T00:59:30+00:00
title: Erlualib -- freaking out
---

As [promised], [I implemented][announcement] a way to implement arbitrary
behaviours in Lua.

So why don't we do erlualerlng?

{% highlight lua %}
function start_server(Args)
    Server = erlang.atom("beer_server")
    Pid = gen_server:start_link(Server, {"bottles" : 99}, {})
    BottlesLeft = gen_server:call(Pid, "minus_one_bottle")
{% endhlighlight %}

This is possible. And with not-so-much C. It will be slow (every call-to-erlang
will send a bunch of messages to linked-in driver). But talking about speed..
~10µs/call is not _that_ awful.

Is it useful? Probably not. Fun? Oh yes, don't tell me. Not sure if I will
implement this soon (or will).. But this freaks me out.

[_Winter is coming..._](http://google.com/ "Uhm, interview")

[promised]: /tech/2012/06/erlang-behaviours-in-lua
[announcement]: http://erlang.org/pipermail/erlang-questions/2012-July/068244.html
