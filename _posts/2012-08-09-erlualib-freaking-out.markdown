---
layout: post
date: 2012-08-09T00:59:30+00:00
title: Erlualib, freaking out
---

As [promised], [I implemented][announcement] a way to implement arbitrary
Erlang behaviours in Lua.

So why don't we do erlualerlng?

{% highlight lua %}
function start_counting_bottles(Initially)
    Server = erlang:list_to_atom("beer_server")
    "ok", Pid = gen_server:start_link(Server, {"bottles" : Initially}, {})
    BottlesLeft = gen_server:call(Pid, "minus_one_bottle")
end
{% endhighlight %}

This is possible, and with not-so-much C. It will be slower, of course (every
call-to-erlang will exchange a couple of messages with linked-in driver). But
talking about speed.. ~10-15µs/call is not _that_ awful.

Is it useful? Probably not. Fun? Oh, yes. Not sure if I will implement this
soon (or will).. But this freaks me out.

[promised]: /tech/2012/06/erlang-behaviours-in-lua
[announcement]: http://erlang.org/pipermail/erlang-questions/2012-July/068244.html
