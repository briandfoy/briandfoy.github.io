---
layout: post
title: Another reduction example
categories: programming perl
tags:
stopwords:
last_modified:
original_url:
---

I started to answer a StackOverflow question, but it was deleted before I could get back to it. The person was trying to figure out what an `if` branch was doing.

Often, programming, well, good programming, relies on our ability to [reduce problems to known solutions](on-the-decomposition-of-problems/). This relies on our ability to see structures and patterns, and possibly see possible structures.

<!--more-->

# The Answer

Here's your code, indented so I can see what belongs to what:

{% highlight perl %}
while (<file_name>){
    if ($runmode eq 'prd'){
        if (/^(\d{2})(\d{2})(\d{2})\/([a-z]{5})\/\d{6}\.(dw[a-z]+)\.001/i) {
            print $OUT uc("$4|$5|20$1-$2-$3\n");
        }
     } else {
        if (/^QA\/(\d{2})(\d{2})(\d{2})\/([a-z]{5})\/\d{6}\.(dw[a-z]+)\.001/i){
            print $OUT uc("$4|$5|20$1-$2-$3\n");
        }
    }
}
{% endhighlight %}

The outer `if` checks some variable for the run mode, then does the same operation with a slightly different regex. Here are the patterns aligned so that you see that the second pattern has `QA/` at the front:

{% highlight perl %}
    (\d{2})(\d{2})(\d{2})\/([a-z]{5})\/\d{6}\.(dw[a-z]+)\.001
QA\/(\d{2})(\d{2})(\d{2})\/([a-z]{5})\/\d{6}\.(dw[a-z]+)\.001
{% endhighlight %}

The problem is that the structure hides that simple difference. The `if` is only there to select between slight differences before going on to do the same thing.

One way to fix that is the take the pattern out of the loop. You can use the `qr` to build a regex without using it, and you can even use that result inside another regex to make a bigger one. Once you have the final pattern, apply it with `m//` as usual:

{% highlight perl %}
my $base = qr|(\d{2})(\d{2})(\d{2})/([a-z]{5})/\d{6}\.(dw[a-z]+)\.001|;
my $pattern = $runmode eq 'prd' ? qr|^$base| : qr|^QA/$base|;

while( <$fh> ) {
	print $OUT uc("$4|$5|20$1-$2-$3\n") if m/$pattern/;
    }
{% endhighlight %}

Another tactic reduces the problem so you can use the same pattern. If you remove `QA/` from the start of the string in some cases, then you don't need to modify the pattern.

{% highlight perl %}
my $pattern = qr|(\d{2})(\d{2})(\d{2})/([a-z]{5})/\d{6}\.(dw[a-z]+)\.001|;

while( <$fh> ) {
	s|\AQA/|| if $runmode eq 'prd';
	print $OUT uc("$4|$5|20$1-$2-$3\n") if m/$pattern/;
    }
{% endhighlight %}

