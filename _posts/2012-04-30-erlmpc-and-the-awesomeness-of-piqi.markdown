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
guys (game UI) from programmers (game backend).

We don't really want to know if they are using flash, HTML5 or whatever else.
From their perspective, they don't even want to know Erlang exists (in reality,
they are using flash, and we are using Erlang). The transport layer is JSON.
Plain and native JSON is worse than XML, because it doesn't have:

* XSD
* WSDL

Both these are horrible, but _can_ do their job when asked nicely. However, we
still need something for JSON.

I invented a similar thing in my previous job. We needed to support both XML
(for "enterprise" clients) and JSON for real things, i.e. communication with
browser. I implemented and tested the initial version in 3-4 weeks. While this
Data Definition Language (DDL) had much love and time invested, was tested
PropErly, it didn't feel right. A home-brew solution for such an important
thing.

Getting to the truth
---

Before writing my DDL I looked at various solutions. Erlangers suggested Piqi.
I looked at it, liked it, but somehow thought that it needs OCaml at run-time.
I thought: "damn it, an Erlang port running alongside just to (de)serialize our
stuff?  This will **never** happen". This is how Piqi was crossed out.

However, when I was at the Dutch guys, they were amazed about Piqi. For
whatever unknown reason. So I thought to try it out myself.

Here is the gist of this post: _Piqi does not require OCaml at run-time. In
fact, plain Erlang is sufficient_. I will make an effort to write this
explicitly in erlang-piqi documentation.

A bit about Piqi
---

Here is an example Piqi data definition and corresponding Erlang .hrl file:

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

Other buzzwords
---

I knew mochiweb quite well, so wanted to try another buzzword. Tried cowboy.
Amazing tool. However, will not get into details here.

[erlmpd] is a very, very nicely written library as for Erlang R13 (now is
R15B1).  Documentation is great. Type specs, though optional at that time (and
were visible only by edoc, since there were no good type checkers then), are
very nice and helpful. This guy certainly knew what he is doing. It was trivial
to convert his library (3 years old) to OTP, add rebar and use straight away.

WebSockets. It would be too much hassle to implement communication via
long-polling (the only way after WS to get a close to real time feeling). So I
chose WebSockets and didn't bother. And I am happy I did it. Server-side
pushing makes things so much easier! What is more, you do not need to implement
any session support. For every connection, you get `State`. Single connection
is a single client. In this state variable I hold a connection to mpd server.
No cookies, no manual bullshit like routing user requests to processes,
handling disconnects and etcetra. It just works.

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

No `sudo make install`, no web server configurations. Nothing! Enjoyable, isn't it?

UI javascript part is the only ugly part in the whole codebase. For now, it's
understandable. But it has to be rewritten if we want to extend this client. If
I will continue this project, I suspect Backbone.js will be a good candidate
for that. We need proper pub/sub for interfaces. Otherwise it's ugly.

All in all, things learned:

* how Piqi works, from absolutely nothing to something usable
* music player communicates with server through websockets (only)
* [cowboy] was the chosen web server, which I was really happy with. I should
  dedicate another post for awesomeness of cowboy.

Oh, and here is the screenshot:

![Version 0.1](https://github.com/Motiejus/erlmpc/raw/0.1/priv/static/screenshot-0.1.png "erlmpc running in Google Chrome 18")

Are you a UI designer, MPD user or Erlanger? Feel free to contribute!

[full files]: https://github.com/Motiejus/erlmpc/tree/0.1/priv/piqi
[cowboy]: https://github.com/extend/cowboy
[erlmpd]: https://github.com/caolan/erlmpd
