---
layout: post
title: tmux cheatsheet
categories:
tags:
stopwords:
last_modified:
original_url:
---

I guess I'm going to start using tmux because I have to work on a system that
doesn't have the xterm package and all sorts of things wonky.

<!--more-->

## Some commands

{% highlight text %}
$ tmux attach -t NAME
$ tmux detach
{% endhighlight %}

### Get the session name

Get them all:

{% highlight text %}
$ tmux ls
{% endhighlight %}

Get the current one:

{% highlight text %}
$ tmux display-message -p '#S'
{% endhighlight %}

### Rename session

{% highlight text %}
$ tmux rename-session -t OLD NEW
{% endhighlight %}


## Links

* [tmux cheatsheet](https://tmuxcheatsheet.com)
* [tmux in iTerm2](https://iterm2.com/documentation-tmux-integration.html)
* [Chris Scheller's tmux config](https://github.com/schelcj/scripts/blob/master/smux)
