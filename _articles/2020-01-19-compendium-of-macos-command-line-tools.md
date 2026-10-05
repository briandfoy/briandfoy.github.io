---
layout: post
status: _posts
title: Compendium of macOS Command-Line Tools
categories: cheatsheet
tags: macOS
stopwords: plist webloc
last_modified:
original_url:
---

There are a variety of macOS commands I can never remember. Sometimes
I forget that they exist and other times I forget how I constructed
their command line. The docs aren't always helpful.

<!--more-->

## Property Lists

Turn a plist into JSON. I often do this with *.webloc* files. The
part I forget is to specify standard output (why isn't that the default?):

{% highlight console %}
$ plutil -convert json -o - foo.webloc
{% endhighlight %}

Along with the, I use *jq* to extract the URL:

{% highlight console %}
$ plutil -convert json -o - foo.webloc | jq -r .URL
{% endhighlight %}

## Software Update

Run Software Update from the command line:

{% highlight console %}
$ softwareupdate -ia --include-config-data
{% endhighlight %}

## Start Screen Sharing

{% highlight console %}
$ open vnc://user:password@host
{% endhighlight %}

## Share a remote volume

Don't use the Unix path for the remote side. It's the name under */Volumes*:

{% highlight console %}
$ open afp://host/VolumeName
{% endhighlight %}

Normal URL encoding doesn't seem to work. Instead of `+` for a space,
use a shell escape or quote that part

{% highlight console %}
$ open afp://host/Volume\ Name
$ open afp://host/'Volume Name'
{% endhighlight %}

Supply credentials:

{% highlight console %}
$ open afp://user:pass@host/VolumeName
{% endhighlight %}
