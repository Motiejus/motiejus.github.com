---
layout: post
date: 2012-06-26T17:35:00+01:00
title: Erlang behaviours in Lua
---

Ever wanted to abuse Erlang for distribution & whatnot, and use something
easier and wider adopted for the business-side implementation?

We are creating on-line games. We have wonderful flash programmers responsible
for front-end. But for some games server-side logic is required. And we want
game devs to write it.

Erlang is a bit alien for game devs, so we opted for something much lighter for
server-side game implementation: Lua. Game Devs will write game backend in Lua
and front-end in flash, and it will all be wrapped in Erlang. 

I recently started writing a behaviour wrapper for Lua. See an example how it
will look like. Example implements a server in the most familiar behaviour -
`gen_server`.

`beer_server_lua.erl`:

{% highlight erlang %}
-behaviour(gen_server).
-compile({parse_transform, implemented_in_lua}).
-backing_module('beer_server.lua').
{% endhighlight %}

`implemented_in_lua.erl` will on compile time create all `init/1`,
`handle_call/3`, etc. These functions will just be wrappers to lua interface to
`backing_module`.

`beer_server.lua`:
{% highlight lua %}
function init(Bottles)
    return {"ok", {bottles=Bottles}}
end

function handle_call(Request, From, State)
    if Request == "minus_one_bottle"
        if State.bottles > 0
            State.bottles = State.bottles - 1
        else
            return {"reply", "out_of_bottles", State}
        end
    end
    return {"reply", "ok", State}
end

...
{% endhighlight %}

You will be able to start and call this gen_server like any other gen_server:

{% highlight erlang %}
{ok, Pid} = gen_server:start_link(beer_server_lua, [1], []),
<<"ok">> = gen_server:call(Pid, minus_one_bottle),
<<"out_of_bottles">> = gen_server:call(Pid, minus_one_bottle),
...
{% endhighlight %}

Types Erlang->Lua
-----------------

Erlang types supersets Lua types, so conversion is easy. Terms from Erlang to
Lua will be converted according to these rules:

<table>
<tr><th>Erlang</th><th>Lua</th></tr>
<tr><td>atom, binary</td><td>string</td></tr>
<tr><td>number</td><td>number</td></tr>
<tr><td>tuple, list</td><td>number-indexed table</td></tr>
</table>

Types Lua->Erlang
-----------------

This is more tricky. When Lua returns a string, how do we know if it is a
binary or atom? Modified [Sheriff] will take care of this. It will inspect what
can be returned by the function, and alter the return value accordingly.

For example, if `handle_call/3` was defined this way:

{% highlight erlang %}
-callback handle_call(Request :: term(), {pid(), term()}, State :: term()) ->
    {reply, ok | out_of_bottles, NewState :: term()}
{% endhighlight %}

Then the previous example would look like:
{% highlight erlang %}
{ok, Pid} = gen_server:start_link(beer_server_lua, [1], []),
ok = gen_server:call(Pid, minus_one_bottle),
out_of_bottles = gen_server:call(Pid, minus_one_bottle),
...
{% endhighlight %}

Note the return values are of type `atom` now.

Benefits
--------

* **Implement any behaviour** in Lua with only 3 lines of Erlang boilerplate.
* Make people who don't do middleware happy.
* The whole thing will be _fast_ (via port driver, so there will be no OS
  context switches).

Facts
-----

You will be able to write wrappers yourself instead of doing `parse_transform`s
all over the place, if you want more control for certain methods. Something
like this:

{% highlight erlang %}
init(Bottles) ->
    lua:call('beer_server.lua', [Bottles], ?TYPES());
{% endhighlight %}
Or even more control:
{% highlight erlang %}
init(Bottles) ->
    lua:call('beer_server.lua', [Bottles],
        "{reply, ok | out_of_bottles, term()}");
{% endhighlight %}

Stay tuned.

[Sheriff]: https://github.com/extend/sheriff
