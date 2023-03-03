---
layout: post
title: Speedtests
categories: system-administration command-line nyc-mesh
tags: python speedtest
stopwords:
---

Since I've got[NYC Mesh](https://www.nycmesh.net) now, I want to see
how it stacks up to what I have currently. I can do that with the Speedtest.net
web pages or mobile app, but I'd like to collect a lot of stats over
time.

<!--more-->

There's a python command-line program for it:

{% highlight text %}
$ pip install speedtest-cli
{% endhighlight %}

I had to fiddle with some issues with Python and SSL, but that wasn't
a big deal (thank you StackExchange).

A run shows me what I have now, which is about what I expected but a
lot less than Spectrum has promised:

{% highlight text %}
$ speedtest-cli
Retrieving speedtest.net configuration...
Testing from Spectrum (xxx)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by Natural Wireless (New York, NY) [5.93 km]: 16.386 ms
Testing download speed................................................................................
Download: 60.55 Mbit/s
Testing upload speed......................................................................................................
Upload: 11.89 Mbit/s
{% endhighlight %}

I can also get that in JSON:

{% highlight text %}
$ speedtest-cli --json
{"download": 62739979.93993792, "upload": 11754874.487030044,
"ping": 15.015, "server": {"url": "http://nyc.speedtest.sbcglobal.net:8080
/speedtest/upload.php", "lat": "40.7127", "lon": "-74.0059", "name":
"New York, NY", "country": "United States", "cc": "US", "sponsor":
"AT&T", "id": "5029", "host": "nyc.speedtest.sbcglobal.net:8080",
"d": 5.9323532524349485, "latency": 15.015}, "timestamp":
"2020-01-19T22:05:10.986822Z", "bytes_sent": 14999552, "bytes_received":
79240756, "share": null, "client": {"ip": "xxx", "lat":
"xxx", "lon": "xxx", "isp": "Spectrum", "isprating": "3.7",
"rating": "0", "ispdlavg": "0", "ispulavg": "0", "loggedin": "0",
"country": "US"}}
{% endhighlight %}

More interestingly, I can get CSV output. The first time, I want the
CSV headers. Then each run after that

{% highlight text %}
$ speedtest-cli --csv-header > speedtest.log
$ speedtest-cli --csv >> speedtest.log
{% endhighlight %}

I wrapped this in a shell program that I can run from cron:

<script src="https://gist.github.com/briandfoy/ba285633dc01ea1b2cfc63adea5032b1.js"></script>



