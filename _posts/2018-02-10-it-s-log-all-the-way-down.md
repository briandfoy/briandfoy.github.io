---
layout: post
title: It's log all the way down
categories: perl programming
tags: logarithms
stopwords: ULP glibc ivln libm
last_modified:
original_url:
---

I read [A Logarithm Too Clever by Half](https://people.eecs.berkeley.edu/~wkahan/LOG10HAF.TXT) about MATLAB 6's messed up `LOG10` function.

<!--more-->

So I was curious how far off Perl would be. These things measure themselves in ULP (units in last place). There's some precision that these functions have based on the number of bits they are able to use, and the path that final number can lose accuracy in each step.

This is one of those things that Computer Scientists can geek out about, but for which most of us don't really care. Even with the inaccuracy, most of us probably don't care. Even if you are reading this, you probably don't care.

{% highlight perl %}
#!/usr/bin/perl

use POSIX qw(log10);

my $interval = $ARGV[0] || 0.01;

for( my $i = 0 + $interval; $i < 1; $i += $interval ) {
    my $natural = log($i);
    my $ten     = log(10) * log10($i);
    my $diff    = $natural - $ten;
    printf "%.10f %.10f %.10f\n", $natural, $ten, $diff;
    }
{% endhighlight %}

The results are ironically disappointing because the numbers from `log` (natural base) and [POSIX](http://metacpan.org/pod/POSIX)'s `log10` are exactly the same:

{% highlight text %}
$ perl log.pl
-4.6051701860 -4.6051701860 0.0000000000
-3.9120230054 -3.9120230054 0.0000000000
-3.5065578973 -3.5065578973 0.0000000000
-3.2188758249 -3.2188758249 0.0000000000
-2.9957322736 -2.9957322736 0.0000000000
-2.8134107168 -2.8134107168 0.0000000000
...
{% endhighlight %}

There's usually a particular reason things are exactly the same: they come from the same thing. After diving down into the source of _glibc_ and deeper into _libm_, I find that `log10` is implemented in terms of `log`. Here's the [BSD version](http://www.retro11.de/ouxr/43bsd/usr/src/usr.lib/libm/log10.c.html). That `ivln10` is just `1/log(10)`, usually a literal (such as `4.34294481903251816668e-01`):

{% highlight c %}
 double log10(x)
  67: double x;
  68: {
  69:     double log();
  70:
  71: #ifdef VAX
  72:     return(log(x)/ln10hi);
  73: #else   /* IEEE double */
  74:     return(ivln10*log(x));
  75: #endif
  76: }
{% endhighlight %}

Most of this still has been figured out decades ago.
