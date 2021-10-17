---
layout: post
title: Timezone names in Windows
categories:
tags:
stopwords:
last_modified:
original_url:
---

The Perl Power Tools tries to provide Perl versions of Unix tools so you can use those tools wherever you have Perl, such as Windows. Tom Christiansen started this project ages ago and I merely dust and mop every so often.

Recently, [kal247](https://github.com/kal247) [filed a bug](https://github.com/briandfoy/PerlPowerTools/issues/98) that the Perl Power Tools version of `date` did the wrong thing with timezones.

In short, the original, abre implementation guessed at timezones and was specific to North America. Oops. Locales are a tough thing, but with that fixed, a new problem presented itself.

Windows is not a POSIX system, so some POSIX things just don't work. In this case, I thought I fixed things by using `%z` in `date` format, but Windows doesn't know anything about that.

First, here's the `date` command from macOS, where the `%Z` produces the abbreviation for the time zone and `%z` produces the offset:

{% highlight text %}
$ date +%Z
EDT

$ date +%z
-0400
{% endhighlight %}

With `strftime` from Perl's POSIX module, macOS gives the same thing:

{% highlight text %}
$ perl -MPOSIX -le "print POSIX::strftime( '%Z', localtime )"
EDT

$ perl -MPOSIX -le "print POSIX::strftime( '%z', localtime )"
-0400
{% endhighlight %}

However, on Windows, it's different. That operating system doesn't have appropriate interfaces to time zone information (who made that decision?).

{% highlight text %}
$ perl -MPOSIX -le "print POSIX::strftime( '%Z', localtime )"
Eastern Daylight Time

$ perl -MPOSIX -le "print POSIX::strftime( '%z', localtime )"
Eastern Daylight Time
{% endhighlight %}

There's a crude list of timezones that I can see with `tzutil`:

{% highlight text %}
> tzutil /l
...

(UTC-05:00) Eastern Time (US & Canada)
Eastern Standard Time

...
{% endhighlight %}

"Eastern Daylight Time" isn't in there. These are simply the names that you can use to set the timezone, after which Windows will figure out daylight saving and offsets. So, given the output of the Perl program, "Eastern Daylight Time", I can't necessarily connect it back to something useful.

But, I did take that list and set every time zone into both January 1 and July 1, hoping to get all strings that Windows would supply. If I had the output, and I knew what timezone I set, I can associate the `%Z` output with it.

Then I wondered
