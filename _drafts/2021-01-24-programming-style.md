---
layout: post
title: Programming Style
categories: programming
tags:
stopwords:
last_modified:
original_url:
---

<!--more-->

Instead of doing this:

	do_something if ....

Do this:

	do_something();

	sub do_somthing {
		return unless..
		}


========

Make it so it's easier to configure

sub default_user { ... }

====

Have everything return the same sort of thing


