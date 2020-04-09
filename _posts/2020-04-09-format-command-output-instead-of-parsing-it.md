---
layout: post
title: Format command output instead of parsing it
categories: programming
tags: git nmcli perl command-line 10x
stopwords:
last_modified:
original_url:
---

Perl is a great tool to parse command output, especially if you want to use that for something else. But, this sort of thinking is an artifact of a time when we couldn't affect the output. What a command spit out was what it spit out and we needed extra-command tools to deal with it.

However, many modern tools have facilities to do this for you. You don't need to parse the output because the command can format it for you. Using builtin features makes for simpler scripts.

I've answered some StackOverflow questions about this; I think people aren't reading the docs for what their commands can do:

* [Using Perl to format nmcli output and get WiFi names](https://stackoverflow.com/a/60963075/2766176)

* [How do I get the information about each branch of my git local repository](https://stackoverflow.com/a/61117730/2766176)

Read the docs and learn what your tools can do. It's going to make your life easier.
