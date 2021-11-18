---
layout: post
title: JPEG comments
categories: command-line
tags: jpeg
stopwords: exiftool
last_modified:
original_url:
---

[exiftool](https://exiftool.org) is a Perl program that can modified metadata stored in images.

So far I'm using it to add comments:

	$ exiftool -Comment="This is a comment" test.jpg

I'm actually making the comment a JSON string so I can pass around structured data. If I have the file I have the metadata rather than losing it in the filesystem.
