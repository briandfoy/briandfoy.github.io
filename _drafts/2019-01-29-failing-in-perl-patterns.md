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

That's certainly not as pretty, but it works. Does that mean you should use it? I'm not going to tell you what to do (no "best practice" exists without a context), but I have no plans to use this for any good purpose. My only thought was seeing how that Raku translated back to Perl 5.

## Take it apart

There are two features that I want to highlight. There's the conditional and the `(*FAIL)`.


### Fail hard

The `(*FAIL)` is easy. If Perl tries to match that, that part of the pattern fails.

Here's an alternation that looks for one of *a*, *b*, or *c*. An alternation matches the first branch that satisfies its pattern.

{% highlight text %}
$ perl -le 'q(abc) =~ /(a|b|c)/ and print $1'
a
{% endhighlight %}

Now add a `(*FAIL)` to the first branch. As the regex moves along it matches the *a* then runs into the `(*FAIL)`. That branch immediately stops and the match tries the next branch, where it matches the *b*:

{% highlight text %}
$ perl -le 'q(abc) =~ /(a(*FAIL)|b|c)/ and print $1'
b
{% endhighlight %}

### The conditional

Now on to the conditional. I have a way to fail a pattern, so I need a way to conditionally trigger that.

Here's the basic structure:

{% highlight text %}
(?(CONDITION)yes-branch|no-branch)
{% endhighlight %}

If the CONDITION is true, the `yes-branch` becomes the next part of the pattern to match. If the CONDITION is false, the `no-branch` becomes the next part to match.

The `CONDITION` is any one of these things:

* a capture number (so, `1` for `$1`)
* a capture group name in angle brackets or single quotes
* a lookaround assertion
* a zero-width assertion
* a code block, `(?{ CODE })`
* a recursion marker

As a simple example, here's CONDITION as a capture number. If `$2` matched, the condition `(2)` is true and the next part of the pattern is `bc`. If that capture did not match (it's optional), the next part of the pattern is `yz`:

{% highlight text %}
$ perl -le 'shift =~ / (a)? (?(2)bc|yz) /x and print $&' abc
abc

$ perl -le 'shift =~ / (a)? (?(2)bc|yz) /x and print $&' yz
yz
{% endhighlight %}

However, if I make the next part of the pattern the `(*FAIL)`, even though the *a* matches, it doesn't! There's no output!

{% highlight text %}
$ perl -le 'shift =~ / (a)? (?(2)(*FAIL)|yz) /x and print $&' abc
{% endhighlight %}

Convert the condition from a capture number to a code block: `(?{ CODE }). Now the CONDITION is true is the code returns true, and false otherwise. In this case, if the value in `$1` is `a`, the code returns true and the next part of the pattern is `bc`. Otherwise, the next part of the pattern is `yz`:

{% highlight text %}
$ perl -le 'shift =~ / (a)? (?(?{ $1 eq q(a) })bc|yz) /x and print $&' abc
abc
$ perl -le 'shift =~ / (a)? (?(?{ $1 eq q(a) })bc|yz) /x and print $&' xyz
yz
{% endhighlight %}

Add the `(*FAIL)` again. Now `abc` doesn't match even though `a` matches:

{% highlight text %}
$ perl -le 'shift =~ / (a)? (?(?{ $1 eq q(a) })(*FAIL)|yz) /x and print $&' abc
{% endhighlight %}

But, I don't care about the `no-branch`. Or, more correctly, I'll make it the empty pattern. This still fails:

{% highlight text %}
$ perl -le 'shift =~ / (a)? (?(?{ $1 eq q(a) })(*FAIL)) /x and print $&' abc
{% endhighlight %}

Move on to numbers now. Instead of matching `a`, match a digit with `\d`. If that digit is 7, fail. Otherwise, since the `no-branch` is effectively the empty pattern, the rest of the pattern matches:

{% highlight text %}
$ perl -le 'shift =~ / (\d)? (?(?{ $1 == 7 })(*FAIL)) /x and print $&' 123
1
$ perl -le 'shift =~ / (\d)? (?(?{ $1 == 7 })(*FAIL)) /x and print $&' 789
{% endhighlight %}

But I'm more interested in the cases where I match something that I don't want. Suppose I only want to match `5` and fail for anything else. I negate the comparator in the code; now I'm using `!=`.

{% highlight text %}
$ perl -le 'shift =~ / (\d)? (?(?{ $1 != 5 })(*FAIL)) /x and print $&' 789

$ perl -le 'shift =~ / (\d)? (?(?{ $1 != 5 })(*FAIL)) /x and print $&' 567
5
{% endhighlight %}

But I can have more complex code. I'll have two comparisons. Now the value in `$1` has to be 0, 1, 2, 7, 8, or 9 because the condition looks for digits greater than 2 and less than 7:

{% highlight text %}
$ perl -le 'shift =~ / (\d)? (?(?{ 2 < $1 and $1 < 7 })(*FAIL)) /x and print $&' 567

$ perl -le 'shift =~ / (\d)? (?(?{ 2 < $1 and $1 < 7 })(*FAIL)) /x and print $&' 234
2
{% endhighlight %}

To match the numbers between 2 and 7, I negate the combination of those two comparisons:

{% highlight text %}
$ perl -le 'shift =~ / (\d)? (?(?{ ! (2 < $1 and $1 < 7) })(*FAIL)) /x and print $&' 345
3
{% endhighlight %}

And, this brings me back to where I wanted to be. I just need to update the thing I match to be multiple digits and adjust the range:

{% highlight text %}
$ perl -le 'shift =~ / (\d{1,3})? (?(?{ ! (0 < $1 and $1 < 256) })(*FAIL)) /x and print $&' 567

$ perl -le 'shift =~ / (\d{1,3})? (?(?{ ! (0 < $1 and $1 < 256) })(*FAIL)) /x and print $&' 234
234
{% endhighlight %}

Or, instead of using numbers outside the range, use `<=` to include the numbers at the end of the range:

{% highlight text %}
$ perl -le 'shift =~ / (\d{1,3})? (?(?{ ! (1 <= $1 and $1 <= 255) })(*FAIL)) /x and print $&' 234
234
{% endhighlight %}
