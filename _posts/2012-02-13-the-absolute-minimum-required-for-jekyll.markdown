---
layout: post
date: 2012-02-13T19:38:30+00:00
title: The absolute minimum to bootstrap Jekyll
---

### Motivation

So I wanted a Jekyll powered note engine, and I wanted to bootstrap quickly.
While [Jekyll Bootstrap](http://jekyllbootstrap.com/) fits for most, I am more
like an LFS-guy. Do things in small steps from the start understanding what is
going on.

I assume you have read the [introduction] and know *what* Jekyll is. This post
will help you to bootstrap the bare minimal system.

### Setup

So [install] it first. Then create some self-explanatory files:

<table border="1">
<tr>
  <th>_layouts/base.html</th>
  <th>_layouts/page.html</th>
</tr>
<tr>
<td>
{% highlight html %}
<!DOCTYPE html>
<html>
  <head><title>{{ "{{ page.title" }} }}</title></head>
  <body>{{ "{{ content" }} }}</body>
</html>
{% endhighlight %}
</td>
<td>
{% highlight html %}
---
layout: base
---
<h3><a href="/">{{"{{ page.title" }} }}</a></h3>
<div id="content">{{"{{ content" }} }}</div>
{% endhighlight %}
</td>
</tr>
<tr>
<th>index.html</th>
<th>_config.yml</th>
</tr>
<tr>
<td>
{% highlight html %}
---
layout: base
---
{{"{% for post in site.posts "}} %}
  <h3><a href="{{"{{ post.url" }} }}">{{" {{ post.title"}} }}</a></h3>
  {{"{{ post.content"}} }}
  <hr/>
{{"{% endfor"}} %}
{% endhighlight %}
</td>
<td>{% highlight yaml %}permalink: /:year/:month/:title{% endhighlight %}</td>
</tr>
</table>

### Add some content

<table border="1">
<tr>
<th>_posts/2012-02-13-playing-around.markdown</th>
<th>_posts/2012-02-12-hello-jekyll.markdown</th>
</tr>
<tr>
<td>
{% highlight html %}
---
layout: page
title: Playing Around
---
To see if forloop really works
{% endhighlight %}
</td>
<td>
{% highlight html %}
---
layout: page
title: Hello, Jekyll!
---
Hello, Jekyll!
{% endhighlight %}
</td>
</tr>
</table>

### Done

    jekyll --server
    firefox http://127.0.0.1:4000/

These are the basics which you can have at hand simply working, and go from
here. Next things you would like to do:

* Create `/css/base.css` and link from `index.html`.
* Read the [introduction] and [wiki] while already understanding of what's going on.

[install]: https://github.com/mojombo/jekyll/wiki/Install
[introduction]: http://jekyllbootstrap.com/lessons/jekyll-introduction.html
[wiki]: https://github.com/mojombo/jekyll/wiki
