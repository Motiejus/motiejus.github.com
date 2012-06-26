---
layout: post
date: 2012-06-26T17:35:00+01:00
title: Erlang behaviours in Lua
---

Ever wanted to abuse Erlang for distribution & whatnot, and something use
something easier and wider adopted for the business-side implementation?

In Spil Games, we are creating games (duh) and whole infrastructure to handle
it. Middleware is in Erlang. Erlang is a bit alien for game devs, so we opted
for something much lighter: Lua.

So Game Devs will write game backend in Lua, and it will be wrapped in Erlang. 

This is how you will be able to write a `gen_server` in Lua:

`beer_server_lua.erl`:

{% highlight Erlang %}
-behaviour(gen_server).
%% Creates init/1, handle_call/3, handle_cast/2, ... These functions will
%% pass execution to Lua.
-compile({parse_transform, implemented_in_lua}).

-type bottles() :: integer().
-spec init(bottles()) -> {ok, term()}.

%% Module which requests should be forwarded
-export([backing_module/0]).
backing_module() -> <<"beer_server.lua">>.
{% endhighlight %}

And Lua part:

`beer_server.lua`:
{% highlight lua %}
function init(Bottles)
   return {"ok", {bottles=Bottles}}
end

function handle_call(...)
...
{% endhighlight %}

You will be able to call the gen_server normally:

{% highlight erlang %}
gen_server:start_link(beer_server, [100], []).
{% endhighlight %}

Modified [Sheriff] will take care of the conversion from Lua to Erlang.
Reference for types will be -callback and -spec. Terms from Erlang to Lua will
be converted according to these rules:

* `atom`, `binary` -> `string`
* `number` -> `number`
* `tuple`, `list` -> number-indexed table

Notice there are no strings on Erlang side? Yes, because these are **lists of
numbers**.

!http://cdn.memegenerator.net/instances/400x/22541635.jpg!

Benefits

* Implement any behaviour in Lua with only 4 lines of boilerplate Erlang code.
* Make guys who don't do middleware happy.
* It will be _really_ fast (it will be via BIFs).

Stay tuned.

[Sheriff]: https://github.com/extend/sheriff
