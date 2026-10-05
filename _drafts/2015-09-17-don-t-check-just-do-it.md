---
layout: post
status: _drafts
title: Don't check; just do it
categories: programming
tags:
stopwords:
last_modified:
original_url:
---

In various things, you can simplfy programming with idempotent interfaces.


<!--more-->

* idempotency

{% highlight perl %}
make_path( $backup_dir, { mode => 0700 } unless -d $backup_dir;
{% endhighlight %}

