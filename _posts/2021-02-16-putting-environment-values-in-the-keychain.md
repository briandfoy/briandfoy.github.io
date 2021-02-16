---
layout: post
title: Putting environment values in the keychain
categories:
tags: macOS secrets bash
stopwords: macOS's
last_modified:
original_url:
---

I do the same stupid but expedient things that most people probably do. I write passwords on paper (which I latter shred) or I type them into notes. Sometimes I have them in *~/.bash_profile*, right there where anyone can see them if they have access to my terminal.

{% highlight bash %}
export SOME_API_KEY=abcdeadbeef
{% endhighlight %}

If I lose my laptop, all that's easily compromised once someone opens
a terminal.

But, good news everyone! I got far enough down my to do list that I've fixed this. I can put all that in a secure keychain. Here I'll do this on macOS.

First, I moved all the sensitive stuff in their own file, *~/.bash_secrets* and change mode 400 (whereas my *~/.bash_profile* is 644 for no particular reason). I'll load that in *~/.bash_profile*:

{% highlight text %}
[ -f ~/.bash_secrets ] && source ~/.bash_secrets
{% endhighlight %}

In *~/.bash_secrets*, I create a function to use macOS's [security](https://ss64.com/osx/security.html) command to get the value. I can call that, capture its output, and assign it to a variable that I export:

{% highlight bash %}
function get_secret () {
    security find-generic-password -a $LOGNAME -s $1 -w
	}

# Appveyor
export APPVEYOR_API_KEY=$(get_secret appveyor_api_key)

# O'Reilly Atlas
export ATLAS_PASSWORD=$(get_secret atlas_password)

# For Amazon Web Services
export AWS_ACCESS_KEY=$(get_secret aws_access_key)
export AWS_SECRET_KEY=$(get_secret aws_secret_key)
{% endhighlight %}

Now none of the secrets are in the file.

There's a bit of a catch. macOS may pop up a dialog asking for my login password (or the password for the particular keychain).

![](/images/keychains/dialog.png)

I can change the access on my own to never prompt, or to allow particular programs access:

![](/images/keychains/access.png)

Once I adjust all of that, I don't get further dialogs.
