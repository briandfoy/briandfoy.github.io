---
layout: post
title: Make your LeanPub Table of Contents
tags:
stopwords: culted toc
---

A reader suggested that I add a Table of Contents to the LeanPub page
for my latest book, [Mojolicious Web Clients](https://leanpub.com/mojo_web_clients).
I hadn't thought about it, but once he suggested it, I thought "Why doesn't
LeanPub extract this from my ePub automatically?". Maybe is does, but it
has no instructions of what to do to make that happen. I'll make that
much easier for you.

It the book details page, I can add HTML that LeanPub will insert into
my book's summary page. It's instructions tell you to look at the HTML
source for other book pages, but also that they can change their rules
at any time (screenshot at the end).

Rather than comb through the HTML of other book's details pages, here's
what I did. I have a nested `ul` lists:

{% highlight html %}
<ul class="toc no-parts mojo-web-clients-toc">
<li>Preface
	<ul>
	<li>Some eBook Notes</li>
	<li>Installing Mojolicious</li>
	<li>Getting Help</li>
	<li>Acknowledgments</li>
	<li>Perl School</li>
	</ul></li>
<li>Introduction
	<ul>
	<li>The Mojo Philosophy</li>
	<li>Be Nice to Servers</li>
	<li>How HTTP Works</li>
	<li>Add to the Request</li>
	<li>httpbin</li>
	</ul></li>
...
</ul>
{% endhighlight %}

If you like your browser's version of "View Source" (Safari's is designed
to make you not want to do that), fine. I downloaded the page source
locally so I could view it in BBEdit:

{% highlight html %}
$ curl --silent https://leanpub.com/mojo_web_clients | bbedit
{% endhighlight %}

That sucks though. Here a Mojolicious one-liner to get as close to the
Table of Contents as I can. This CSS selector is obviously fragile, and
would have been much shorter if they had added `id` elements. If you are telling
people to extract something from HTML source, you should label it so make
that easy:

{% highlight html %}
$ perl -Mojo -E 'say g(shift)->dom->at(
    q(#scroll-wrapper > div > article > section:nth-child(9) > div > div > div > div > div > div )
    )' https://leanpub.com/mojo_web_clients
{% endhighlight %}

Since I added a special class to my `ul` (LeanPub strips any `id` element),
you can extract my Table of Contents with a class selector:

{% highlight html %}
$ perl -Mojo -E 'say g(shift)->dom->at(
	q( ul.mojo-web-clients-toc )
	)' https://leanpub.com/mojo_web_clients
{% endhighlight %}

The `toc` class might work, but I'm not confident it wouldn't be repurposed
from something else. It's only there because I cargo-culted it from another
book's page. I don't know if it's common for other book pages to use it:

{% highlight html %}
$ perl -Mojo -E 'say g(shift)->dom->at( q( ul.toc )
	)' https://leanpub.com/mojo_web_clients
{% endhighlight %}

![Table of Contents instructions](/images/leanpub_toc_instructions.png)

