---
layout: post
compare: math
title: Don't compare percentages
tags: general-idiocy rescued-content math
stopwords: APPL MSFT sigzero tiobe's O'Reilly's Binstock
---


*I wrote this for use.perl.org in 2006, but I keep looking for it at
the beginning of each year as numeric illiterates try to do the same
flawed analysis to prove something about programming languages in the
last year ([this year it's Andrew Binstock at
DDJ](http://www.drdobbs.com/jvm/the-rise-and-fall-of-languages-in-2013
/240165192)). I'm adding it to blogs.perl.org in case use.perl.org
(now read only) suddenly disappears.*

sigzero recently asked [if the Perl community was
atrophying](http://use.perl.org/use.perl.org/_sigzero/journal/29798.
html), someone else pointed me to Tim O'Reilly's [State of the
Computer Book
Market](http://radar.oreilly.com/archives/2006/04/
state_of_the_computer_book_mar.html), and there's a [Wikipedia revert
war](http://en.wikipedia.org/w/index.php?title=Perl&action=history)
over Tiobe's [Programming Programming
Index](http://www.tiobe.com/tpci.htm). All of these suffer from a
misunderstanding of percentages and their value in making decisions
and reaching conclusions. This is especially egregious when people
divorce the percentages from the absolute numbers (either because the
original data are restricted or the people know that they tell a
different story).

I start with six topics I'll call { A, B, C, D, E, F }, and I'll
arbitrarily assign them a number. It doesn't matter what this number
actually is. It could be hits on a web search engine, book sales on
the topic, number of people moving to a town, or anything else. I'm
just making all of this up to show that when people talk of trends in
growth using percentages, they get the wrong answer because
percentages remove information. The real answer involves some simple
calculus (although without the fancy symbology) and a realization
about what I should actually measure.

Let's get to it then. I make up two sets of numbers. I'll say one was
from last month, and one was from this month. Since the universe is
growing, the total results for this month are not the same as the that
from last month. This is very important, because this is where
percentages fail and how people use percentages incorrectly. Notice
that in every case except one, the number for each topic increased. In
the other case, the number stays the same.

{% highlight text %}
Table 1: Size of topic, in absolute numbers,
for two consecutive months

    A         17,000        34,000
    B         50,000        70,000
    C          5,000         6,000
    D          8,000        16,000
    E         10,000        12,000
    F         10,000        10,000

    TOTAL    100,000       148,000
{% endhighlight %}

I'll change these numbers to percentages of the totals now. I round
off to the nearest integer, but that won't matter much. This is the
first place where I'll lose some information. With percentages, the
difference in the totals between the two months disappear, but I'll
compare the percentages as if the totals were the same, and I'll end
up with the wrong answer.

{% highlight text %}
Table 2: Size of topic, in percentage of total number,
for two consecutive months

    A    17    23
    B    50    47
    C     5     4
    D     8    11
    E    10     8
    F    10     7
{% endhighlight %}

First, notice in Table 1 that B had the greatest overall change
(20,000), but actually dropped by 3% in Table 2, while A had a smaller
change (17,000) in Table 1, but shot up 6% in Table 2. A has a
relative percentages growth of 9%, although it's growing more slowly.
All topics except F had an increase in absolute numbers, but four
actually dropped in percentages. Both C and E increased by a fifth of
their absolute number, which is remarkable growth in a month, but
their percentages dropped. That is, although they actually trend
upward, the percentages trend in the opposite direction of their
growth. B, which contributed the most absolute growth, dropped as much
as F in percentages, although F had absolutely no growth. According to
the relative numbers, B is losing in relative size as fast as F,
although it added double the total number of F just in growth in one
period.

I'll do this for another month, adding the same absolute numbers as
before to each topic. Each topic has the same absolute growth from
month to month. Each is steadily increasing in absolute numbers except
for F, which stays the same.

{% highlight text %}
Table 3: Size of topic, in absolute numbers,
for three consecutive months

    A         17,000        34,000       51,000
    B         50,000        70,000       90,000
    C          5,000         6,000        7,000
    D          8,000        16,000       24,000
    E         10,000        12,000       14,000
    F         10,000        10,000       10,000

    TOTAL    100,000       148,000      196,000
{% endhighlight %}

What happens to the percentages in steady state growth? I see the same
relative downward trends in most cases, despite the fact that all but
F are growing in actual size.

{% highlight text %}
Table 4: Size of topic, in percentage of total number,
for three consecutive months
    A    17    23    26
    B    50    47    46
    C     5     4     4
    D     8    11    12
    E    10     8     7
    F    10     7     5
{% endhighlight %}

Now, in Table 4, the percentages are even worse for B. Again, the
total increased by 48,000 hits, and again, B provided 20,000 new hits.
But, by the percentages, B falls 1%. B is responsible for most of the
growth, but also looks as if it is atrophying, while A is just getting
up to the level where B started. Although all but one topic increased
their absolute numbers, four fell in relative percentages.

Let's go a year later than the last column, adding 12 times the same
number of absolute growth to each result. Every topic continues a
steady state growth.

{% highlight text %}
Table 5: Size of topic, in absolute numbers, for three
consecutive months, and one year later (covering
15 total months)

    A         17,000        34,000       51,000       255,000
    B         50,000        70,000       90,000       330,000
    C          5,000         6,000        7,000        19,000
    D          8,000        16,000       24,000       120,000
    E         10,000        12,000       14,000        38,000
    F         10,000        10,000       10,000        10,000

    TOTAL    100,000       148,000      196,000       772,000
{% endhighlight %}

What happens to the percentages a year later, shown as the last column
in Table 6?

{% highlight text %}
Table 6: Size of topic, in percentage of total number,
for three consecutive months, then one year later (covering
15 total months)

    A    17    23    26    33
    B    50    47    46    43
    C     5     4     4     2
    D     8    11    12    16
    E    10     8     7     5
    F    10     7     5     1
{% endhighlight %}

It's the same decline. Although B has over six times the absolute
numbers it did 15 months ago, it lost 7% in relative numbers. It's
still the largest and the fastest growing topic by absolute numbers,
but the relative numbers make it look like the fastest declining
topic.

The relative numbers are based on the total absolute number, and the
problem comes in when I compare the percentages from month to month
since the total absolute number changes. Percentages remove
information to make things easier to see, but they aren't there to be
compared to percentages from another measurement. If the total number
stays the same, the trend in percentages might have meaning, but if I
don't report the total size, the percentages don't enough information
for me to compare them across measurements.

If I used this analysis to figure out which books to publish, I'd miss
the biggest and fastest growing market. If I used them to decide which
city to do business in, I'd miss the one with the most customers and
the one that's adding the most customers. Analysts used to like to use
this sort of thing to show why Apple Computer was a poor bet since it
only had a minuscule percentage of the market, but that was clearly
wrong. If I'd bought APPL 3 years ago at $11, I would have gained over
400% in value, compared to MSFT, selling at $26, losing 14% in the
same time period. It's because relative numbers aren't the important
ones.

So how do I do it then? I want to see how things are growing and what
I should pay attention to. I could plot the absolute numbers, but a
first-derivative plot makes it easier to see the real change. Like
percentages, it removes the total number, but it leaves in the
information about the direction and magnitude of the change. That's
the number I really want to compare. The first derivative is simply
the change in the number over the time period. It's a bit of calculus,
although I won't take it to an infinitesimal time slice.

{% highlight text %}
Table 7: First derivative table, showing the change over three consecutive months, and one year later.

    A   17,000    17,000    17,000    204,000
    B   20,000    20,000    20,000    240,000
    C    1,000     1,000     1,000     12,000
    D    8,000     8,000     8,000     96,000
    E    2,000     2,000     2,000     24,000
    F        0         0         0          0
{% endhighlight %}

Compare the utility of Table 7 to Table 6 for decision making. In
Table 6, topics A and D look like they are the fastest growing, when
in reality topic A grew more than either of them and continues to have
a faster rate of change over the next year. The percentages have the
least information, doing away with the absolute change and the
absolute total size. If I'd bet my money on A because it looked as if
it was growing fastest by percentages, at the end of the year I would
have missed the top by 55,000, over a fifth of the absolute total for
B.

Now, consider the business reason for looking at these sorts of
numbers, and, for simplicity, imagine that the products for each topic
have the same price. I don't make more money by the higher rate of
growth. Topic A doubled in its first month, but still sold less than
Topic B. Betting on the fastest growing relative percentage (Topic A)
in that case would have meant ignoring the greater number of sales I
could get from Topic B. I make more money by making more sales, not
more growth, and in this case, the worst-performer, percentage-wise,
is the highest volume seller in every time period.

The first derivative plot shows that Topic B is the fastest growing
market. I don't care about the growth in terms of the size of the
market, but the number of units I can sell. In business parlance, the
percentage is the "market penetration", but that's not the interesting
number to anyone other than those trying to drive someone out of a
market (as in the case of the silly business between Microsoft and
Apple arguments). Market penetration is the false idol of stock
speculators. The totals and first-derivatives are the numbers that
translate into real money and real value.
