---
layout: post
title: Pausing all Cloudflare domains
categories: sysadmin
tags: cloudflare web-api
stopwords:
---

Sometimes I want to do bulk actions on everything hidden behind a
Cloudflare account, so I need to pause Cloudflare. I do have direct
access through another hostname, but that's sometimes not the same
thing.

[Cloudflare has an API](https://api.cloudflare.com), so this action is
easy to script once I've collected some Zone IDs:

<script src="https://gist.github.com/briandfoy/8b6bf162a5eea7f11e1016273ecdbb14.js"></script>
