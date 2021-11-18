---
layout: post
title: Advertising SSH on Ubuntu
categories: system-administration
tags: ubuntu macbook-air
stopwords: dns sd
---

Up until today, I've only used my Ubuntu MacBook Air. My home network
is mostly Apple products, so service discovery is built in. I want to
enable and advertise the SSH service on the Air too.

First, I need to enable ssh. No big whoop:

{% highlight text %}
air$ sudo apt-get install openssh-server
air$ sudo systemctl enable ssh
air$ sudo systemctl start ssh
air$ sudo systemctl status ssh
{% endhighlight %}

Now I can ssh into the machine as `air.local`. I set up SSH keys and so
on. But, I don't see it advertised. That's something under the purview of
[avahi](https://www.avahi.org). That's not an easy thing to casually use. I can publish the
service during a session:

{% highlight text %}
air$ sudo avahi-publish -s `hostname` _ssh._tcp 22 "SSH Remote Terminal"
{% endhighlight %}

And I can see it when I run [dns-sd](http://www.dns-sd.org) on my macOS machine.
Start *dns-sd* first because it will sit there to watch the network for
advertisements and output new ones as they come in:

{% highlight text %}
macbookpro$ dns-sd -B _ssh._tcp .
Browsing for _ssh._tcp
DATE: ---Sat 11 Jan 2020---
15:07:21.564  ...STARTING...
Timestamp     A/R    Flags  if Domain  Service Type  Instance Name
15:07:21.757  Add        3   1 local.  _ssh._tcp.     macbookpro
15:07:21.757  Add        2   5 local.  _ssh._tcp.     macbookpro
15:07:22.293  Add        2   5 local.  _ssh._tcp.     macpro
15:07:22.543  Add        2   5 local.  _ssh._tcp.     air
{% endhighlight %}

To make it persistent, I can copy an example service from the *examples*
to the live *services* directory:

{% highlight text %}
air$ sudo cp /usr/share/doc/avahi-daemon/examples/ssh.service /etc/avahi/services/.
{% endhighlight %}

Once all that is setup, I make an entry in *~/.ssh/config* on any remote
machine where I want to start. I don't want to type the entire `air.local`
so I give it a short name with `Host`:

{% highlight text %}
# ~/.ssh/config
Host air
Hostname air.local
User brian
IdentityFile /Users/brian/.ssh/id_rsa
{% endhighlight %}
