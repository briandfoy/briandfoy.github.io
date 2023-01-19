---
layout: post
title: Speeding up my secrets
categories:
tags: macOS secrets bash
stopwords: mtime precompute
last_modified:
original_url:
---

In [Putting environment values in the keychain](), I showed how I use the macOS keychain to store passwords and then read those into my shell's environment. It worked, but it's also a bit annoying; every time I start a new interactive shell, I have to wait five seconds for it all to happen. Now I've fixed that.

<!--more-->

The problem was that every time I started the shell I made many calls to the bash function `get_secret`:

{% highlight bash %}
# .get_secret.sh
function get_secret () {
	security find-generic-password -a $LOGNAME -s $1 -w
	}
{% endhighlight %}

This means that I'm likely fetching the same data over and over even though it hasn't changed. These values are often API keys, constants, and other things that probably haven't changed in months. Still, I reload them several times an hour as I open new terminals.

I decided that I'd precompute everything I need and have it ready to go. That's easy enough. I basically do what I was doing before, but I write everything to a file that will stick around. My *.bash_profile* then sources this text:

{% highlight bash %}
# ~/.bash_secrets_base_gpg
source ~/.get_secret.sh

s=''

# Appveyor
s="${s}export APPVEYOR_API_KEY=$(get_secret appveyor_api_key)\n"

# For Amazon Web Services
s="${s}export AWS_ACCESS_KEY=$(get_secret aws_access_key)\n"
s="${s}export AWS_SECRET_KEY=$(get_secret aws_secret_key)\n"
s="${s}export AMAZON_ASSOCIATES_TAG=$(get_secret amazon_associates_tag)\n"
s="${s}export DBD_AMZN_USER=$(get_secret dbd_amzn_user)\n"

echo -e "$s" > .bash_secrets # this line will disappear
{% endhighlight %}

What's the point of the secrets store if it's just sitting there as text? Now comes the fun part. I'll encrypt that string with GPG and save that. I store the destination file and target key in the secrets too, but mostly as a coordination point for all the scripts that might use this. GPG gets its plaintext directly from standard input:

{% highlight bash %}
# still in ~/.bash_secrets_base_gpg
gpg_fingerprint=$(get_secret bash_secrets_gpg_fingerprint)
output_file=$(get_secret bash_secrets_gpg_filename)
echo -e $s | gpg --encrypt --armor -r $gpg_fingerprint > $output_file
{% endhighlight %}

On the other side, in *.bash_profile*, I go backward. There's a nested `if` here. I don't want to run this if I'm running a program through BBEdit. No big whoop:

{% highlight bash %}
source ~/.get_secret.sh

base_secrets_create=~/.bash_secrets_base_gpg
gpg_file=$(get_secret bash_secrets_gpg_filename)
days=1

if [ -z "${BBEDIT_CLIENT_INTERACTIVE}" ]
then
	if test `find $gpg_file -mtime -$days`
	then
		echo "$gpg_file is fresh"
	else
		echo "Recreating $gpg_file"
		$base_secrets_create
	fi
	echo "Sourcing $gpg_file"
	gpg_password=$(get_secret bash_secrets_gpg_password)
	plain=$(echo $gpg_password | gpg --passphrase-fd 0 -d $gpg_file 2>/dev/null)
	source <(echo -e "$plain")
fi
{% endhighlight %}

The inner `if` is where the magic happens. I use `find` to compare the file modification time against what I put in `day`. The `--mtime -1` fails if the file is over a day old. In that case, I want to regenerate the secrets file.

Once I have the secrets file, either reusing a fresh one or recreating it, I decrypt that in place. The password comes in from the keychain too and gets to gpg through standard input. The gpg output ends up in `plain` without touching the disk.

With the plaintext in a variable, I source that string. This little trick requires bash 4 on macOS because bash 3 had a bug that prevented this feature from working.
