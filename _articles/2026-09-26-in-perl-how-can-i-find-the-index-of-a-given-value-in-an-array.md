---
layout: post
status: _posts
title: In Perl, how can I find the index of a given value in an array?
categories: programming rescued-content
tags: perl stackoverflow arrays
stopwords:
last_modified:
original_url: https://stackoverflow.com/a/80006144/2766176
---

*This originally appeared as the StackOverflow answer to ["In Perl, how can I find the index of a given value in an array?"](https://stackoverflow.com/a/80006144/2766176)*

I'm adding another answer since Perl now has the `indexed` keyword that makes some of this easier when you want the index and value at the same time.

<!--more-->

If you have to scan the entire list to find all indices (so, maybe more that one), a nifty approach uses the new `indexed` along with the new multiple iterator feature:

{% highlight perl %}
use v5.40;  # experimental in v5.36; imports builtin for you

my @array = qw(a b c 1 3 137 4 137 x y z);
my $target = 137;

my @found;
foreach my ($i, $item) ( indexed @array ) {
	push @found, $i if $array[$i] eq $target;
	}

say "Found @found";
{% endhighlight %}

This is similar to the older Perl way that uses `each` with an array. This was introduced in Perl 5.12, which tried to treat arrays and hashes the same for other reasons that weren't a good idea:

{% highlight perl %}
use v5.12;

my @array = qw(a b c 1 3 137 4 137 x y z);
my $target = '137';

my @found;
while( my($i, $v) = each @array ) {
	push @found, $i if $v eq $target;
	}
say "Found each: @found";
{% endhighlight %}

This is really just a harder way to avoid `grep` with a single element access, but then you don't get to see the new Perl features that might be useful in more complicated tasks:

{% highlight perl %}
my @found = grep { $array[$_] eq $target } 0 .. $#array;
{% endhighlight %}

In all of these, an empty list in `@found` means nothing matched. The other answers to your question have an additional complication that these don't.

## Pre-compute this if that would save time

That's fine if you only need to do this once, but if you need to do this many times for the same list, you can build the index ahead of time.

{% highlight perl %}
use v5.40;  # experimental in v5.36; imports builtin for you

my @array = qw(a b c 1 3 137 4 137 x y z);
my $target = 137;

my %lookup;
foreach my ($i, $item) ( indexed @array ) {
	push $lookup{$item}->@*, $i;
	}

my @found = $lookup{$target}->@*;  # go direct to answer

say "Found @found";
{% endhighlight %}

If your list is very long, you might want to throw this into some sort of
external key store so you don't blow up your program's memory. But, I wouldn't worry about that until you have to worry about that. Also, the time to index it has to be significantly shorter than checking every time for this to make sense.

## Just the first index

If you only care about the first index, then you already have the good solutions. There's the `grep`, where you check for definedness (no index will be undefined), which is the part that most answers left out. Check that you have an actual index before you use it since `undef` numifies to 0:

{% highlight perl %}
my($first) = grep { $array[$_] eq $target } 0 .. $#array;
if( defined $first ) { ... }
{% endhighlight %}

That's going to check every element of the input list even after it has already found an element. With very large lists, that extra time might matter. That's why [List::Util](https://metacpan.org/pod/List::Util), which comes with Perl, has `first`; it stops once it has the single answer. Again, you have to check for definedness:

{% highlight perl %}
use List::Util qw(first);  # comes with Perl
my $found = first { $array[$_] eq $target } 0 .. $#array;
if( defined $first ) { ... }
{% endhighlight %}

You could avoid the index list (`0 .. $#array`) by installing the [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils) module and using `firstidx`, although I think tracking that dependency is worse than the slightly less typing (although I don't think it's actually less).

But, `firstidx` has an additional complication: it returns a defined and true value, `-1`, if nothing matches. Perl uses the index `-1` to signal that the last index of an empty array, homologous to the `-1` that `index` uses to denote that the substring is not in the target string:

{% highlight console %}
$ perl -le 'print $#a'
-1
$ perl -le 'print index q(abc), q(d)'
-1
{% endhighlight %}

You can't test for definedness or truthiness in this case, which I find more annoying than any convenience someone might imagine, and a likely spot that some future programmer will not understand the weirdness and mess it up:

{% highlight perl %}
use List::MoreUtils qw(firstidx);  # does not come with Perl
my $found = firstidx { $_ eq $target } @array;
if( $found > -1 ) { ... }
{% endhighlight %}

But to get around that, [List::MoreUtils](https://metacpan.org/pod/List::MoreUtils) has `indexes`, but that brings you back to scanning the entire list again just like `grep` with the extra burden of the dependency:

{% highlight perl %}
use List::MoreUtils qw(indexes);  # does not come with Perl
my @found = indexes { $_ eq $target } @array;
{% endhighlight %}

