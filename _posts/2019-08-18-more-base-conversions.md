---
layout: post
title: More number base conversions on the command line
categories: programming command-line
tags: perl bash aliases base-36
---

Here are some more number conversion aliases to go with [/base-conversions]. Sometimes I need to deal with Base-36, which includes the normal decimal digits then the 26 letters from the Latin alphabet. Think of Base-16 that didn't stop at F.

<!--more-->

I wanted to use some Bash stuff to do this, but it was easier to simply use Perl again.

{% highlight text %}
BASE_36='perl -MMath::Base36=:all -E'

alias b36="$BASE_36 'say encode_base36(oct(q(0b).shift))'"
alias o36="$BASE_36 'say encode_base36(oct(shift))'"
alias d36="$BASE_36 'say encode_base36(shift)'"
alias h36="$BASE_36 'say encode_base36(hex(shift))'"

alias 36b="$BASE_36 'printf qq(%b\n), decode_base36(shift)'"
alias 36o="$BASE_36 'printf qq(%o\n), decode_base36(shift)'"
alias 36d="$BASE_36 'printf qq(%d\n), decode_base36(shift)'"
alias 36h="$BASE_36 'printf qq(%X\n), decode_base36(shift)'"
{% endhighlight %}

Here are some runs:

{% highlight text %}
$ h2d 89
137

$ 36h 3T
89

$ h2d 89
137

$ d36 137
3T
{% endhighlight %}
