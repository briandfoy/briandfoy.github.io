---
layout: post
title: Copying C's mistakes
categories: programming
tags: perl wart
stopwords:
last_modified:
original_url:
---

In [One Hundred Year Mistakes](https://ericlippert.com/2020/02/27/hundred-year-mistakes/), Eric Lippert discusses C's addition of the `&&` and placing it incorrectly in the precedence table. This addition happened sometime in 1972 ([history of C](https://en.cppreference.com/w/c/language/history)). By comparison, `grep` was invented in 1974, so searching the source to find the thing to fix isn't an option.

Here's Eric's example. What should the last line return?

{% highlight c %}
int x = 0, y = 1, z = 0;
int r = (x & y) == z; // 1
int s = x & (y == z); // 0
int t = x & y == z;   // ?
{% endhighlight %}

Most new programmers assume that `&` will have the same precedence as any other binary operator—`x & y` will resolve as `x + y`. In that case, `t` is the same as `r`. But, `t` is actually `s`.

In Python (which doesn't have a `&&`), the `&` and `+` are on the same side of the `==`, so both `&` and `+` act the same in relation to comparison.

{% highlight python %}
#!python

x = 0
y = 1
z = 0

r = ( x & y ) == z; # 1
s = x & (y == z);   # 0
t = x & y == z;     # 1

{% endhighlight %}

The equivalent Ruby code wouldn't work because the it mixes the `{True,False}Class` with integers. But the `&` and `+` are on the same side of the `==` just as in Python.


Try the same thing in Perl and you get the same answer as C. [Perl's precedence](https://perldoc.perl.org/perlop) is mostly C's precedence which means it copies the known problem with `&`:

{% highlight perl %}
#!perl

my( $x, $y, $z ) = ( 0, 1, 0 );
my $r = ($x & $y) == $z; # 1
my $s = $x & ($y == $z); # 0
my $t = $x & $y == $z;   # 0
{% endhighlight %}

