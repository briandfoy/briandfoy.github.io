---
layout: post
title: Adding Apple mobile icons
categories: web-admin
tags: perl apple iOS
stopwords: png Bynens ico
last_modified:
original_url:
---

iOS devices request special icon files. Besides offering *favicon.ico*, I now need to add other files. But, which ones? I'll look through the web logs to see what the devices are asking for:

{% highlight text %}
$ cd /var/log/httpd
$ grep touch *.log | perl -nE 'm/GET (\/apple-\S+)/&&say $1' | sort -u
/apple-touch-icon-120x120.png
/apple-touch-icon-120x120-precomposed.png
/apple-touch-icon-152x152.png
/apple-touch-icon-152x152-precomposed.png
/apple-touch-icon.png
/apple-touch-icon-precomposed.png
{% endhighlight %}

How many of these did I get today for [www.effectiveperlprogramming.com](https://www.effectiveperlprogramming.com)?

{% highlight text %}
$ $ grep touch *.log | perl -nE 'm/GET (\/apple-\S+)/&&say $1' | sort | uniq -c
   1585 /apple-touch-icon-120x120.png
   1589 /apple-touch-icon-120x120-precomposed.png
    275 /apple-touch-icon-152x152.png
    275 /apple-touch-icon-152x152-precomposed.png
   4773 /apple-touch-icon.png
   4723 /apple-touch-icon-precomposed.png
{% endhighlight %}

What are these files? Matthias Bynens explains it in [Everything you always wanted to know about touch icons](https://mathiasbynens.be/notes/touch-icons).

I don't need to make the `precomposed` versions because iOS will do that for me automatically. That provides the rounded corners and gloss to make them look like iOS icons.

I start to think about how I'm going to make the other files for my book sites, but as I've been doing recently, remember that someone probably has an online thing that will do this for me. Indeed, there's [realfavicongenerator.net](https://realfavicongenerator.net). I upload
a square crop of my book cover and it gives me back some files.

![](https://www.effectiveperlprogramming.com/apple-touch-icon-180x180.png)

But, the newest hotness are larger versions, including *apple-touch-icon-152x152.png*. I don't see that in my logs, but it's easy enough to make. I've been using [Affinity Photo](/goodbye-adobe/) for that stuff and I'm getting used to its interface.
