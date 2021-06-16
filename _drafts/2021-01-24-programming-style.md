---
layout: post
title: Programming Style
categories:
tags:
stopwords:
last_modified:
original_url:
---

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


