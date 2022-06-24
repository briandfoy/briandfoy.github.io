---
layout: post
title: Conditional matching
categories: perl regex
tags:
stopwords:
last_modified:
original_url:
---

Perl's regular expressions have some simple conditionals that allow you to decide what happens next.

<!--more-->

The first type of condition is easy, but you need a capture buffer to reference. The pattern `/(.*)/` has the `$1` capture and can still match nothing: and matching nothing is good enough here. Now you have to construct the condition; that's the reference to the capture buffer:

{% highlight text %}
(.*) (?(1)...)
{% endhighlight %}

The condition is true if that capture buffer matched, and false otherwise (including missing captures). For the `yes-branch`, use a code assertion, `(?{...})` so you can output something:

{% highlight text %}
(.*) (?(1) (?{ say "Yes!" }) )
{% endhighlight %}

Try that in a one-liner:

{% highlight text %}
$ perl -E 'm/(.*) (?(1) (?{ say "Yes!" }) )/x'
Yes!
{% endhighlight %}

You get the `yes-branch` because the `$1` capture always matches.

Try matching something—anything—so `$1` might not match.
{% highlight text %}
$ perl -E '$ARGV[0] =~ m/(a) (?(1) (?{ say "Yes!" }) )/x'

$ perl -E '$ARGV[0] =~ m/(a) (?(1) (?{ say "Yes!" }) )/x' a
Yes!

$ perl -E '$ARGV[0] =~ m/(a) (?(1) (?{ say "Yes!" }) )/x' abba
Yes!
{% endhighlight %}

Now add a `no-branch` to the regex:

{% highlight text %}
(a) (?(1) (?{ say "Yes!" }) | (?{ say "No!" }) )
{% endhighlight %}

The `yes-branch` case still works, but you don't get output when the pattern doesn't have an *a*:

{% highlight text %}
$ perl -E '$ARGV[0] =~ m/(a) (?(1) (?{ say "Yes!" }) | (?{ say "No!" }) )/x' a
Yes!

$ perl -E '$ARGV[0] =~ m/(a) (?(1) (?{ say "Yes!" }) | (?{ say "No!" }) )/x' b
{% endhighlight %}

That's not a problem with the conditional; the patten fails before it even gets to the conditional because it didn't match `(a)`. If you change that to `(a?)` to make that optional, the `$1` still matched so it's still the `yes-branch`. However, make the the entire capture optional. If the first capture does not capture, you get the `no-branch`

{% highlight text %}
$ perl -E '$ARGV[0] =~ m/(a?) (?(1) (?{ say "Yes!" }) | (?{ say "No!" }) )/x' b
Yes!

$ perl -E '$ARGV[0] =~ m/(a)? (?(1) (?{ say "Yes!" }) | (?{ say "No!" }) )/x' b
No!
{% endhighlight %}

Now lets put this to good use. If we start with a vowel, we have to match a consonant next. If we start with a consonant, we have to match a vowel next.



====== still working on this

$ perl -E 'say $ARGV[0] =~ m/^([aeiou])?([wxyz])? (?(1)[xyz])(?(2)[aeiou]) X/x ? "Match" : "Miss"' xaX
