---
layout: post
title: Don't check; just do it
categories:
tags:
stopwords:
last_modified:
original_url:
---

In various things, you can simplfy programming with idempotent interfaces.

* idempotency
make_path( $backup_dir, { mode => 0700 } unless -d $backup_dir;

