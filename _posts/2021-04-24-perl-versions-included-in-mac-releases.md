---
layout: post
title: Perl versions included in Mac releases
categories:
tags: perl mac
stopwords: VERSIONER usr
last_modified:
original_url:
---

I compiled [a list of the Perl versions](https://github.com/briandfoy/mac-perl-versions) included with each Mac release. There have been previous efforts, but those are dated. Some of the earlier efforts tried to be clever by writing code to extract that data, but it's easier just to look inside—especially since Apple did it in at least three different ways through the years.

It didn't take long for me to trawl through the code in [https://opensource.apple.com](https://opensource.apple.com), where Apple shows what they did to prepare various packages for inclusion in the operating system. I'm probably missing something else to make it all work, but then I'm not releasing an operating system so who cares.

Apple has this curious system where it can ship multiple versions of a package at the same time. For example, macOS 10.15 ships with both Perls v5.18.4 and v5.28.2. The thing in */usr/bin/perl* isn't even *perl*—it's the thing that dispatches the right one. You can find which versions it knows about by extracting the string-looking stuff from the binary and looking for lines that have `5`:

{% highlight text %}
% strings /usr/bin/perl | grep 5
5.18
5.28
{% endhighlight %}

If I usually want v5.18.4, I can set that as my user default. I have to leave off the point release. This affects all sessions immediately:

{% highlight text %}
% defaults write com.apple.versioner.perl Version 5.18
% /usr/bin/perl -v

This is perl 5, version 28, subversion 2 (v5.28.2) built for darwin-thread-multi-2level
(with 2 registered patches, see perl -V for more detail)
{% endhighlight %}

To set that for all users, you have to affect the global preferences:

{% highlight text %}
% sudo defaults write /Library/Preferences/com.apple.versioner.perl Version 5.18
{% endhighlight %}

Those methods set a persistent default that affects all current and future sessions. To set a value for only the current session, use the `VERSIONER_PERL_VERSION` environment variable:

{% highlight text %}
% VERSIONER_PERL_VERSION=5.18 /usr/bin/perl -v

This is perl 5, version 18, subversion 4 (v5.18.4) built for darwin-thread-multi-2level
(with 2 registered patches, see perl -V for more detail)
{% endhighlight %}

But, this is the Perl that Apple ships so the system can do its work and it's compatible with everything else that Apple shipped. We want to keep that working, so I recommend that people install their own *perl* that they can compile it just the way they want, install and update modules freely, and even have other versions installed. That way, nothing you do affects the jobs that Apple's *perl* needs to do.
