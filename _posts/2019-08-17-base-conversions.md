---
layout: post
title: Number base conversions on the command line
categories: shell
tags: perl bash aliases
---

I made some bash aliases to convert between number bases. Remember that Perl's [oct](https://perldoc.perl.org/functions/oct.html) can translate the other bases as long as the input string has the prefix, such as `0b10101`:

{% highlight text %}
alias d2h="perl -e 'printf qq|%X\n|, int( shift )'"
alias d2o="perl -e 'printf qq|%o\n|, int( shift )'"
alias d2b="perl -e 'printf qq|%b\n|, int( shift )'"
alias h2d="perl -e 'printf qq|%d\n|, hex( shift )'"
alias h2o="perl -e 'printf qq|%o\n|, hex( shift )'"
alias h2b="perl -e 'printf qq|%b\n|, hex( shift )'"
alias o2h="perl -e 'printf qq|%X\n|, oct( shift )'"
alias o2d="perl -e 'printf qq|%d\n|, oct( shift )'"
alias o2b="perl -e 'printf qq|%b\n|, oct( shift )'"
alias b2h="perl -e 'printf qq|%X\n|, oct( q(0b) . shift )'"
alias b2d="perl -e 'printf qq|%d\n|, oct( q(0b) . shift )'"
alias b2o="perl -e 'printf qq|%o\n|, oct( q(0b) . shift )'"
{% endhighlight %}

Here are some runs:

{% highlight text %}
$ d2h 137
89
$ h2d 89
137
$ d2b 137
10001001
{% endhighlight %}

I've had these forever and first posted them on a [use.perl.org journal in 2008](https://use-perl.github.io/user/brian_d_foy/journal/36287/) (the binary ones were a comment from another user). I mention them in my classes and people want a place to copy them, so here they are again. The [aliases tag](/tag/aliases) has more of these.

At various times I've tried to get rid of the `perl`, but I haven't found another tool (that's not another programming language) that can easily handle all the bases and easily take arguments. You might like to read:

* [Binary to hexadecimal and decimal in a shell script](https://unix.stackexchange.com/q/65280/12567)
* [BASH base conversion from decimal to hex](https://unix.stackexchange.com/q/191205/12567)

Somehow the Perl solutions in those found [pack](https://perldoc.perl.org/functions/pack.html) instead of the easier tools such as [hex](https://perldoc.perl.org/functions/hex.html) designed for this.
