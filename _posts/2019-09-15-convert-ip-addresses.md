---
layout: post
title: IPv4 conversion aliases
categories: programming command-line
tags: ipv4 perl bash
stopwords: ipv PostgreSQL
---

I made a couple of bash aliases to convert IPv4 addresses between integers and dotted decimals since I had to deal with both in a database. The [Socket](https://perldoc.perl.org/Socket.html) module that comes with Perl does most of the work:

<!--more-->

{% highlight text %}
alias ip_aton="perl -MSocket=inet_aton -le 'print unpack q(N), inet_aton(shift)'"
alias ip_ntoa="perl -MSocket=inet_ntoa -le 'print inet_ntoa(pack q(N), shift)'"
{% endhighlight %}

PostgreSQL has some [network address types](https://www.postgresql.org/docs/9.1/datatype-net-types.html) that would have made this simpler.
