---
layout: post
date: 2012-04-30T10:39:00+03:00
title: erlmpc and awesomeness of PIQI
---

Piqi is the second most awesome thing in Erlang (after Proper).
---

Disclaimer: a "guy" in this post can be both woman and man. Just sounds better
when spoken about programmer folk.

How it started
---

This year I sold my summer to Netherlands, those guys seem to be pretty cool.
My start of work is approaching, and I asked for some homework in order to get
into the problem domain and familiarize myself with the tools. However, didn't
get any (for whatever reason. Either didn't want to bother, or I seem to be
overqualified). So I had to think some by myself.

Since there is reasonably large infrastructure and there are many teams working
on different things (database guys, UI guys, gamer guys, money guys...), it is
necessary to separate concerns. Now I am most interested in separating gamer
guys (game UI) from programmers (game backend). We don't really want to know if
they are using flash, HTML5 or whatever else.  From their perspective, they
don't even want to know Erlang exists (in reality, they are using flash, and we
are using Erlang). The transport layer is JSON.

A formal schema definition, a parser and validator for it are needed. In this
case, plain and naive JSON is worse than XML, because it doesn't have:

* XSD
* WSDL

Both these are horrible, but _can_ do their job when asked nicely. And they are
only for XML. We needed some data definition language and parser which would
work for JSON as well, and would be capable to convert to/from JSON and XML.

I invented this in my previous job. Given a schema, it was able to convert from
Erlang to JSON and XML and vice-versa. In my previous job we needed to support
both XML (for "enterprise" clients who connect to our system via SOAP) and JSON
for communication with browser. I implemented and tested the initial version in
3-4 weeks. While this Data Definition Language (DDL) had much love and time
invested, was tested [PropEr]ly, it didn't feel right. A home-brewn solution
for such an important thing.

Getting to the truth
---

Before writing my DDL I was looking for something what is already there.
Erlangers suggested piqi. I looked at it, liked it, but somehow thought that it
needs OCaml at run-time. I thought: "an Erlang port running alongside just to
(de)serialize our stuff? Operations will get infinitely more complicated, so
this will never happen". This is how piqi was crossed out.

However, when I was at the Dutch guys, they were amazed about piqi. For
whatever unknown reason. So I thought to try it out myself.

Here is the gist of this post: _piqi does not require OCaml at run-time. In
fact, plain Erlang is sufficient_. I will make an effort to get this this
explicitly included into erlang-piqi documentation. I think, this gist could
have saved me a lot of time.

A bit about piqi
---

It is a data definition language. In a nutshell, a formal agreement: "I will
send you a record which will have one field: volume, and volume will be an
integer". I create a record in Erlang with data I want to send, and pass it to
piqi. Piqi converts it to whatever (now whatever can be xml, json, Google
protocol buffers, or piqi itself) and sends it over the wire.

If I get JSON from JavaScript, I pass it to piqi. Piqi validates it and
converts to native Erlang type. The advantages are:

* Data type validation. Is `5` a binary, integer, float or uint32?
* Complex data types and escaping. I can trust output processed by piqi.

This is not a full overview of piqi features. It can do much more. I present
only the angle of it I used it for my Sunday project.

Here is an example piqi data definition and corresponding generated `.hrl`
file:

<table>
  <tr>
    <th>erlmpc.piqi</th>
    <th>erlmpc_piqi.hrl</th>
  </tr>
  <tr>
    <td>
    <pre>
    .variant [
        .name request
        .option [ .name setvol .type int ]
        .option [ .name seek .type int ]
        .option [ .name next ]
        .option [ .name prev ]
        .option [ .name pause .type bool ]
        .option [ .name status ]
        .option [ .name currentsong ]
        .option [ .name statuscurrentsong ]
    ]
    </pre>
    </td>
    <td>
      {% highlight erlang %}
      -type(erlmpc_request() :: 
            {setvol, integer()}
          | {seek, integer()}
          | next
          | prev
          | {pause, boolean()}
          | status
          | currentsong
          | statuscurrentsong
      ).
      -endif.
      {% endhighlight %}
    </td>
  </tr>
</table>

`request` defines a request from user to the music player. If you had a look at
[full files], there are some custom types defined, like:

    .enum [
        .name state
        .option [ .name play ]
        .option [ .name stop ]
        .option [ .name pause ]
    ]

And they are used like first-class citizens like `int` or `string`. Piqi DDL is
powerful.

All Erlang files are **generated**. You need OCaml and the whole stack only for
generating .erl and .hrl files (this is why I included them to the repo. I
don't want to be rough and force erlmpc users to have OCaml just to run my
music player interface).

I encourage using piqi if you have two systems that have to speak to each
other. I was very impressed with its support for Erlang.

Other buzzwords
---

I knew mochiweb from the past pretty well, so wanted to try another buzzword
for web server. Tried cowboy. Amazing tool. This is the way libraries/tools
should be written. I will not get into big details here.

[erlmpd] is a very, very nicely written library as for Erlang R13 (now is
R15B1).  Documentation is great. Type specs, though optional at that time (and
were visible only by edoc, since there were no good type checkers then), are
very nice and helpful. This guy certainly knew what he is doing. It was trivial
to convert his library (3 years old) to OTP application, add rebar and use
straight away.

WebSockets. It would be too much hassle to implement server-browser
communication via long-polling (the only way not using WebSockets to get a
close to real time feeling). So I chose WebSockets and didn't bother. And I am
happy I did it. Ability to push from server makes things so much easier! What
is more, you do not need to implement any session support. For every
connection, you get `State`. Single connection is a single client. In this
`State` variable I hold a connection to MPD server. No cookies, no manual
routing user requests to processes, handling disconnects and etcetra. It just
works.

Of course, if you are writing software for general public or organizations
which use IE7, this will yet not work. But future is there.

Thoughts about the product
---

The initial version 0.1 took a long Sunday.

While small and limited, this the best web-based MPD client from set-up
perspective. Looks like this:

1. Install Erlang
2. Get sources
3. `make run`
4. Profit!

No `sudo make install`, no web server configurations. Nothing! Enjoyable, isn't
it?

UI JavaScript part is the only ugly part in the whole codebase. For now, it's
understandable. But it has to be rewritten if we want to extend this client. If
I will continue this project, I suspect Backbone.js will be a good candidate
for that. We need proper pub/sub for UI. Otherwise, it's ugly.

All in all, things learned:

* how piqi works, from absolutely nothing to something usable
* music player communicates with server through WebSockets (only)
* [cowboy] was the chosen web server, which I was really happy with. I should
  dedicate another post for awesomeness of cowboy.

Oh, and here is the screenshot:

![Version 0.1](https://github.com/Motiejus/erlmpc/raw/0.1/priv/static/screenshot-0.1.png "erlmpc running in Google Chrome 18")

Are you a UI designer, MPD user or Erlanger? Contributors are very welcome!

[full files]: https://github.com/Motiejus/erlmpc/tree/0.1/priv/piqi
[cowboy]: https://github.com/extend/cowboy
[erlmpd]: https://github.com/caolan/erlmpd
[PropEr]: http://proper.softlab.ntua.gr/
