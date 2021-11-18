---
layout: post
title: Skipping profile parts while running through BBEdit
categories: consumer-software programming
tags: bbedit macOS secrets
stopwords: env
last_modified:
original_url:
---

In [Putting environment values in the keychain](/putting-environment-values-in-the-keychain/), I noted how I moved a bunch of sensitive info into the Keychain, but set env variables in the shell when I got a log-in shell. That has worked well, except for running a program through BBEdit. Every time I run a program, all that work is redone as BBEdit gets a new interactive shell. It takes a couple seconds for the secrets to load, and that's
annoying.


This isn't a big deal. I have to figure out how to test whether BBEdit is the thing that started this shell. It turns out to be easy. I write a program to dump the environment:

![](/images/secrets/bbenv.png)

I see I have plenty to choose from, and `BBEDIT_CLIENT_INTERACTIVE` looks like the best option:

{% highlight plain %}
  "BBEDIT_CLIENT_INTERACTIVE" => 1,
  "BBEDIT_CLIENT_UUID" => "1E65C199-E1EF-4E5F-A410-9125B7E931AA",
  "BBEDIT_PID" => 3410,
  "BB_DOC_LANGUAGE" => "Perl",
  "BB_DOC_MODE" => "perl",
  "BB_DOC_NAME" => "bbenv.pl",
  "BB_DOC_PATH" => "/Users/brian/Desktop/bbenv.pl",
  "BB_DOC_SELEND" => 49,
  "BB_DOC_SELEND_COLUMN" => 23,
  "BB_DOC_SELEND_LINE" => 2,
  "BB_DOC_SELSTART" => 0,
  "BB_DOC_SELSTART_COLUMN" => 1,
  "BB_DOC_SELSTART_LINE" => 1,
{% endhighlight %}

Now I check that `BBEDIT_CLIENT_INTERACTIVE` is empty before I load up my secrets:

{% highlight plain %}
[ -z "${BBEDIT_CLIENT_INTERACTIVE}" ] && [ -f ~/.bash_secrets ] && source ~/.bash_secrets
{% endhighlight %}
