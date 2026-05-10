---
layout: post
title: Skip the first line by using the flip-flop operator
categories: perl programming
tags: flip-flop perlfaq
stopwords: sed's
last_modified:
original_url: https://www.reddit.com/user/briandfoy/comments/1t8o9y1/geeking_out_about_the_flipflop_operator/
---

*(this was an answer to a StackOverflow question that I didn't post because it didn't quite fit, but I use too keen on showing off the flip-flop operator to get rid of it all)*

*I also put [this in Reddit](https://www.reddit.com/user/briandfoy/comments/1t8o9y1/geeking_out_about_the_flipflop_operator/)*

A few other places:

* [perlfaq5: How do I change, delete, or insert a line in a file, or append to the beginning of a file?](https://perldoc.perl.org/perlfaq5#How-do-I-change,-delete,-or-insert-a-line-in-a-file,-or-append-to-the-beginning-of-a-file?)
* [Respect the global state of the flip flop operator](https://www.effectiveperlprogramming.com/2010/06/respect-the-global-state-of-the-flip-flop-operator/)
* [Make exclusive flip-flop operators](https://www.effectiveperlprogramming.com/2010/11/make-exclusive-flip-flop-operators/)

<!--more-->

Here's some text that has a mix of written ("first") and numeric ("4th") ordinals, and our task is to change them all to the written form except for the first line:

{% highlight text %}
$ cat > file.txt
first line has the numeric ordinal 4th
second line
third is before 4th
4th
next to last
last line is not 4th
{% endhighlight %}

Let's start with a program that simply adds line numbers to the input:

{% highlight text %}
$ perl -n -e 'print "$. $_"' file.txt
1 first line has the numeric ordinal 4th
2 second line
3 third is before 4th
4 4th
5 next to last
6 last line is not 4th
{% endhighlight %}

We can skip the first line, which means that we only get lines that have a line before it. The `$.` is the input line number:

{% highlight text %}
$ perl -n -e 'print "$. $_" unless $. == 1' file.txt
2 second line
3 third is before 4th
4 4th
5 next to last
6 last line is not 4th
{% endhighlight %}

But we don't want to skip the first line. We simply don't want to change it. We can use the same `$.` comparison for the part that changes the line. Notice the first line  does not change but the fifth line does:

{% highlight text %}
$ perl -n -e 's/4th/fourth/ unless $. == 1; print "$. $_"' file.txt
1 first line has the numeric ordinal 4th
2 second line
3 third is before fourth
4 fourth
5 next to last
6 last line is not fourth
{% endhighlight %}

The `-p` switch is different than `-n` because it outputs the value of the line at the end of the loop (if you change it or not):

{% highlight text %}
$ perl -pe 's/4th/fourth/ unless $. == 1' file.txt
first line has the numeric ordinal 4th
second line
third is before fourth
fourth
next to last
last line is not fourth
{% endhighlight %}

Once you know about `$.`, you can select lines however you like, such as every other line:

{% highlight text %}
$ perl -pe '$_ = uc($_) unless $. % 2' file.txt
first line has the numeric ordinal 4th
SECOND LINE
third is before 4th
4TH
next to last
LAST LINE IS NOT 4TH
{% endhighlight %}

Or, even a range (window) of lines:

{% highlight text %}
$ perl -pe '$_ = uc($_) unless( $. < 2 or $. > 5)' file.txt
SECOND LINE
THIRD IS BEFORE 4TH
4TH
NEXT TO LAST
last line is not 4th
{% endhighlight %}

There's a special, and sometimes mind-bending, operator that handles this. The `..` [range operator](https://perldoc.perl.org/perlop#Range-Operators) in scalar context, as it would be in a condition, doesn't produce a list. It's the "flip-flop" variant. That returns false until the lefthand argument is true, and then keeps returning true until the righthand argument is true, after which it returns false. It takes many people a few minutes to unravel that if they haven't used it before:

{% highlight text %}
$ perl -pe '$_ = uc($_) if $. == 2 .. $. == 5' file.txt
first line has the numeric ordinal 4th
SECOND LINE
THIRD IS BEFORE 4TH
4TH
NEXT TO LAST
last line is not 4th
{% endhighlight %}

Perl, being the language that it is, has special cases for the common cases. You can leave off the explicit comparison because comparing the number to `$.` is the default:

{% highlight text %}
$ perl -pe '$_ = uc($_) if 2 .. 5' file.txt
first line is not 4th
SECOND LINE
THIRD IS BEFORE 4TH
4TH
NEXT TO LAST
last line is not 4th
{% endhighlight %}

As an aside, compare this to sed's `2,5 ...` syntax for a line range.
