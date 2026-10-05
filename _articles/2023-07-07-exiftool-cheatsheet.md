---
layout: post
status: _posts
title: exiftool cheatsheet
categories: cheatsheet exiftool
tags: exiftool
stopwords:
last_modified:
original_url:
---

## Times

Adjust the hour and the time zone offset, including the Canon Tags.

Take an hour

{% highlight console %}
$ exiftool -overwrite_original -TimeZoneCity=Chicago -TimeZone=-05:00 -alldates-=1 "-offsettime*=-05:00"
{% endhighlight %}

{% highlight console %}
$ exiftool overwrite_original -alldates-=3 "-offsettime*=-07:00" -TimeZone=-7:00 -TimeZoneCity#=30 -verbose test.CR3
{% endhighlight %}


## Geotag

{% highlight console %}
$ exiftool -progress -overwrite_original -geotag foo.gpx DIR
{% endhighlight %}

## Links

* [Canon Tags](https://exiftool.org/TagNames/Canon.html)
