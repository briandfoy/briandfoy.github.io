---
layout: post
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

{% highlight text %}
exiftool -overwrite_original -TimeZoneCity=Chicago -TimeZone=-05:00 -alldates-=1 "-offsettime*=-05:00"

exiftool overwrite_original -alldates-=3 "-offsettime*=-07:00" -TimeZone=-7:00 -TimeZoneCity#=30 -verbose test.CR3
{% end highlight %}

## Geotag

{% highlight text %}
exiftool -progress -overwrite_original -geotag foo.gpx DIR
{% end highlight %}

## Links

* [Canon Tags](https://exiftool.org/TagNames/Canon.html)
