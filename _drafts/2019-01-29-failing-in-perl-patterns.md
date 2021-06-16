---
layout: post
title: FAILing in Perl patterns
categories:
tags:
stopwords:
last_modified:
original_url:
---

How can you match a number between 0 and 255? There are plenty of ways that merely involve a match, but what if you wanted to stay entirely within the regex? After all, for some people, Perl is just a life support system for a regular expression.

In Raku there's a nice way to do this and it's an example I use in [Learning Perl 6](https://www.learningraku.com). You can immediately test the value of a capture with code inside `<?{ ... }>`:

{% highlight text %}
use v6;
say '١٣٨' ~~ m/ ^ (\d+) <?{ 0 < $0 < 256 }> /;
{% endhighlight %}

Perl 5 has this sort of thing too, although it's not as simple:

{% highlight text %}
print "&lt;$_> Matched!" if /
      	^ (\d+) \z
      	(?(?{ ! (0 < $1 and $1 < 256) })(*FAIL))
    /x;
{% endhighlight %}

That's certainly not as pretty, but it works. Does that mean you should use it? I'm not going to tell you what to do (no "best practice" exists without a context), but I have no plans to use this for any good purpose.

My only thought was seeing how that Raku translated back to Perl 5. So, lets take it apart. There's part of a Perl regex that allows you to set a condition:

{% highlight text %}
(?(CONDITION)yes-branch|no-branch)
{% endhighlight %}

That condition can be a variety of things that you'll see in a moment.
The next part looks like an alternation, but it's two branches. If that condition is true, if does the `yes-branch`. If it's false, it does the `no-branch`. No big whoop.

You can simplify this a bit with a single branch (or, omitting the `no-branch`):

{% highlight text %}
(?(CONDITION)yes-branch)
{% endhighlight %}

So far so good. So let's do something with that first. The `CONDITION` is a reference

* capture number (so, `1` for `$1`)
* a capture group name in angle brackets or single quotes
* a lookaround assertion
* a zero-width assertion
* a recursion marker

The first type of condition is easy, but you need a capture buffer to reference. The pattern `/(.*)/` has the `$1` capture and can still match nothing: and matching nothing is good enough here. Now you have to construct the condition; that's the reference to the capture buffer:

{% highlight text %}
(.*) (?(1)...)
{% endhighlight %}

The condition is true if that capture buffer matched, and false otherwise (including missing captures). For the `yes-branch`, use a code assertion, `(?{...})` so you can output something:

{% highlight text %}
(.*) (?(1) (?{ say "Hello!" }) )
{% endhighlight %}

Try that in a one-liner:

{% highlight text %}
$ perl -E 'm/(.*) (?(1) (?{ say "Hello!" }) )/x'
Hello!
{% endhighlight %}

You get the `yes-branch` because the `$1` capture always matches.

Try matching something—anything—so `$1` might not match.
{% highlight text %}
$ perl -E '$ARGV[0] =~ m/(a) (?(1) (?{ say "Hello!" }) )/x'

$ perl -E '$ARGV[0] =~ m/(a) (?(1) (?{ say "Hello!" }) )/x' a
Hello!

$ perl -E '$ARGV[0] =~ m/(a) (?(1) (?{ say "Hello!" }) )/x' abba
Hello!
{% endhighlight %}


$ perl -E 'm/(.*) (?(1)   (?{ say qq(inside!) })   )/x'
inside!

