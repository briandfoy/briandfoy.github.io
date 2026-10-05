---
layout: post
status: _posts
title: systemd cheatsheet
categories: cheatsheet
tags: systemd
stopwords: cheatsheet systemd
last_modified:
original_url:
---

My cheatsheet for dealing with systemd, which I hate for the things I need to do.

<!--more-->

## Some admin

Clean out the journal:

{% highlight console %}
$ sudo journalctl --vacuum-time=2d
{% endhighlight %}

## User services

Make the *.service* and *.timer* files in *~/.config/systemd/user*, then enable them.

{% highlight console %}
$ systemctl --user enable whatever.service
$ systemctl --user enable whatever.timer
$ systemctl --user start whatever.service
{% endhighlight %}

When you change the service or timer, you have to reload it:

{% highlight console %}
$ systemd-analyze --user verify path
$ systemctl --user daemon-reload
$ systemctl --user start whatever.service
{% endhighlight %}

Check that the service is listed:

{% highlight console %}
$ systemctl --user list-unit-files
{% endhighlight %}

## Example

The service:

{% highlight ini %}
[Unit]
Description=Something that does something
[Service]
Type=simple
WorkingDirectory=/home/userfoo/bin
ExecStart=/home/userfoo/bin/script
StandardOutput=file:/home/userfoo/...

[Install]
WantedBy=multi-user.target
{% endhighlight %}

The timer:

{% highlight ini %}
[Unit]
Description=Something that does something
Requires=whatever.service

[Timer]
OnCalendar=daily
Persistent=true
Unit=whatever.service

[Install]
WantedBy=timers.target
{% endhighlight %}

## Further reading

* [systemd: The Good Parts](https://xeiaso.net/talks/systemd-the-good-parts-2021-05-16)
* [systemd, 10 years later: a historical and technical retrospective](https://blog.darknedgy.net/technology/2020/05/02/0/)
