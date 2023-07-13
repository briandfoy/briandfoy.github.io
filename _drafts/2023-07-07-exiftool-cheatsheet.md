---
layout: post
title: exiftool cheatsheet
categories: cheatsheet exiftool
tags:
stopwords:
last_modified:
original_url:
---


Adjust the hour and the time zone offset, including the Canon Tags:

{% highlight text %}
exiftool -overwrite_original -TimeZoneCity=Chicago -TimeZone=-05:00 -alldates-=1 "-offsettime*=-05:00"
{% end highlight %}

Geotag:

{% highlight text %}
exiftool -progress -overwrite_original -geotag $avenza_dir/*
{% end highlight %}
