---
layout: post
title: Watching web redirects
categories: sysadmin
tags: http perl ruby python mojolicious
stopwords: Mojolicious's
---

I've been working with some tricky web stuff where I need to see that everything redirects to the right addresses through multiple steps of third party tools and services. If I let the user-agents handle it, they just handle it (and that's what I prefer). If I program all the redirections myself, well, I have to program it all myself.

It's not as simple as sending a HEAD request to the server to see if it gives me a Location header. Some of these services don't respond to HEAD, and some respond without a Location header.

But, I can make a tiny tool that can do it for me. I call it [3xx](https://github.com/briandfoy/3xx):

{% highlight text %}
$ python3.7 python/3xx http://127.0.0.1:3000/three
http://127.0.0.1:3000/two
http://127.0.0.1:3000/one
http://127.0.0.1:3000/none
{% endhighlight %}

That local server is a little Mojolicious program to spit out redirects.

Just for giggles, I did it in Perl ([Mojolicious](https://mojolicious.org)), Ruby ([net/http](https://ruby-doc.org/stdlib-2.7.0/libdoc/net/http/rdoc/Net/HTTP.html), and Python ([requests](https://2.python-requests.org)) to see how they compare. I still like Mojolicious's design built around transactions so I can inspect the requests easily, although that wasn't part of this problem.

