---
layout: post
title: Finding domains to block
categories: system-administration
tags: dns dnsmasq domain-fronting privacy
stopwords:
---

Every so often I'll log DNS queries so I can discover domains I'd like
to block: anything that's a beacon, webbug, tracker, or the like. When
I find those domains I add them to */etc/hosts* with an non-routable
address of 0.0.0.0. Probably not kosher, but it's better than it
trying localhost and potentially hitting a webserver I have running.

<!--more-->

I installed [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/) and run it
without starting a daemon.

{% highlight text %}
$ sudo /usr/local/sbin/dnsmasq --no-daemon --log-queries --log-facility=~/dns.log
{% endhighlight %}

I have to configure 127.0.0.1 to be the first nameserver so the
requests go to the local port 53 first. The DNS requests then pass
through *dnsmasq* and onto the next DNS server since I don't actually
resolve any addresses.

I leave it open in a terminal window and hope that I remember to kill
it later because it collects a lot of information:

{% highlight text %}
Jun 22 06:02:28 dnsmasq[9187]: started, version 2.80 cachesize 150
Jun 22 06:02:28 dnsmasq[9187]: compile time options: IPv6 GNU-getopt no-DBus no-i18n no-IDN DHCP DHCPv6 no-Lua TFTP no-conntrack no-ipset auth no-DNSSEC loop-detect no-inotify dumpfile
Jun 22 06:02:28 dnsmasq[9187]: setting --bind-interfaces option because of OS limitations
Jun 22 06:02:28 dnsmasq[9187]: reading /etc/resolv.conf
Jun 22 06:02:28 dnsmasq[9187]: ignoring nameserver 127.0.0.1 - local interface
Jun 22 06:02:28 dnsmasq[9187]: using nameserver 1.1.1.1#53
Jun 22 06:02:28 dnsmasq[9187]: bad name at /etc/hosts line 217
Jun 22 06:02:29 dnsmasq[9187]: bad name at /etc/hosts line 50942
Jun 22 06:02:29 dnsmasq[9187]: bad name at /etc/hosts line 52677
Jun 22 06:02:29 dnsmasq[9187]: read /etc/hosts - 57870 addresses
Jun 22 06:03:07 dnsmasq[9187]: query[AAAA] www.google.com from 127.0.0.1
Jun 22 06:03:07 dnsmasq[9187]: forwarded www.google.com to 1.1.1.1
Jun 22 06:03:07 dnsmasq[9187]: query[A] www.google.com from 127.0.0.1
Jun 22 06:03:07 dnsmasq[9187]: forwarded www.google.com to 1.1.1.1
Jun 22 06:03:07 dnsmasq[9187]: reply www.google.com is 2607:f8b0:4006:800::2004
Jun 22 06:03:07 dnsmasq[9187]: reply www.google.com is 172.217.12.132
Jun 22 06:03:07 dnsmasq[9187]: query[AAAA] iapp.org from 127.0.0.1
Jun 22 06:03:07 dnsmasq[9187]: forwarded iapp.org to 1.1.1.1
Jun 22 06:03:07 dnsmasq[9187]: query[A] iapp.org from 127.0.0.1
Jun 22 06:03:07 dnsmasq[9187]: forwarded iapp.org to 1.1.1.1
Jun 22 06:03:07 dnsmasq[9187]: reply iapp.org is NODATA-IPv6
Jun 22 06:03:07 dnsmasq[9187]: reply iapp.org is 35.168.85.238
Jun 22 06:03:09 dnsmasq[9187]: query[AAAA] cdn.cookielaw.org from 127.0.0.1
Jun 22 06:03:09 dnsmasq[9187]: forwarded cdn.cookielaw.org to 1.1.1.1
Jun 22 06:03:09 dnsmasq[9187]: query[A] cdn.cookielaw.org from 127.0.0.1
{% endhighlight %}

From there, I can collate the query lines and sort them by frequency:

{% highlight text %}
$ perl -nle 'next unless /query\[A+] (\S+)/; print $1' dns.log \
    | sort | uniq -c | sort -r
  12 gateway-carry.fe.apple-dns.net
  12 fcmconnection.googleapis.com
  10 play.google.com
   8 xp.itunes-apple.com.akadns.net
   8 play.itunes.apple.com.edgekey.net
   6 www.gstatic.com
   6 www.google.com
   6 otmwumj6qw5em0zb.me
   5 e673.dscb.akamaiedge.net
   4 www3.l.google.com
   4 us-ne-courier-4.push-apple.com.akadns.net
   4 signaler-pa.clients6.google.com
   4 people-pa.clients6.google.com
{% endhighlight %}

Right away two domains stand out: *play.google.com* and
*otmwumj6qw5em0zb.me*. The first is a Google service I don't want and
the second was probably from some clickbait trap. I usually don't care
enough to investigate further.

I investigate with *whois* and find *otmwumj6qw5em0zb.me* hidden
behind Domains By Proxy, so likely something I don't want to use:

{% highlight text %}
$ whois otmwumj6qw5em0zb.me
% IANA WHOIS server
% for more information on IANA, visit http://www.iana.org
% This query returned 1 object

refer:        whois.nic.me

domain:       ME

organisation: Government of Montenegro

....

# whois.nic.me

Domain Name: OTMWUMJ6QW5EM0ZB.ME
Registry Domain ID: D425500000013452183-AGRS
Registrar WHOIS Server: whois.godaddy.com
Registrar URL: http://www.godaddy.com
Updated Date: 2020-01-20T09:45:32Z
Creation Date: 2017-10-24T15:11:00Z
Registry Expiry Date: 2020-10-24T15:11:00Z
Registrar Registration Expiration Date:
Registrar: GoDaddy.com, LLC
Registrar IANA ID: 146
Registrar Abuse Contact Email: abuse@godaddy.com
Registrar Abuse Contact Phone: +1.4806242505
Registrant Organization: Domains By Proxy, LLC
Registrant State/Province: Arizona
Registrant Country: US
{% endhighlight %}

But then, I can google the domains to see what other people have said
about them. It turns out that one of [my VPNs uses *otmwumj6qw5em0zb.me*](https://www.reddit.com/r/nordvpn/comments/8oslys/suspicious_domains/)
for [domain fronting](https://www.andreafortuna.org/2018/05/07/domain-fronting-in-a-nutshell/) so the true endpoint isn't known by snoopy ISPs and
other censors.

Now, here's the tricky part. I want to block these at the DNS level
by returning a null host. But, if I took a long list of suspects and
blocked them all at once, I'm likely to break part of (well, more of)
the web for me. I'll add them one at a time and wait a bit if I'm unsure
what they do. If something breaks horribly, such as GMail not working,
I'll back out the small change.
