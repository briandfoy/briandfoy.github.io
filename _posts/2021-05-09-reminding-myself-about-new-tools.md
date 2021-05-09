---
layout: post
title: Reminding myself about new tools
categories: programming
tags: programming ncdu
stopwords:
last_modified:
original_url:
---

I often run across new and better tools that can replace the Unix
utilities that I'm used to (and typically don't cause a problem). I
download these new things, compile them, install them, and try them
for 10 minutes. A day later I forget about them and never use them
again. Sometimes, months later, I remember there was a better tool,
but I can't remember the name.

No more. I now have a low-tech annoyance device. I put a small shell
script in *~/bin*, which is first in my `PATH`. Here's my personal
`du` to remind me I want to use [ncdu](https://dev.yorhel.nl/ncdu)
(NCurses Disk Usage):

	#!/bin/sh
	echo "You wanted to use ncdu, remember?"

When I type the familiar command, I get the reminder:

	% du
	You wanted to use ncdu, remember?

Now I remember I wanted to play with the new tool, and I know what
its name is:

	% ncdu

I can still use the original `du` by calling it with its full path:

	% /usr/bin/du
