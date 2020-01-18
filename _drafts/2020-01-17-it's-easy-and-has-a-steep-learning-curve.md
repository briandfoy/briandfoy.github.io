---
layout: post
title: It's Easy and Has a Steep Learning Curve
tags: english business-speak
stopwords:
---

<script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>

I heard an economist being interviewed react to a question to challenge the
idea of a "steep learning curve". I'd never really considered it. He noted that
people tend to use it to note that something progresses slowly relative to
effort, when "steep" conveys rapid progression. [Wikipedia](), [Grammarphobia](https://www.grammarphobia.com/blog/2009/07/steep-learning-curves.html), and [English StackExchange](https://english.stackexchange.com/questions/6209/what-is-meant-by-steep-learning-curve) go for the facile explanation that people misunderstand what they are saying because they are innumerate.

Typically, people imagine the learning curve to be a sigmoid: it
starts mostly flat, has a much steeper section, then flattens again.
There's is some period where skill is low, something else happens and
skill increases, then skills do not increase as quickly.

![Shallow curve](/images/sigmoid-shallow.jpg)

That slope can be steeper:

![Steep curve](/images/sigmoid-steep.jpg)

Now, here's the problem. Those plots have no labels on their axes. People assume that the Y must be something like skill level, productivity, facts learned, or something like that. I would have assumed that too.

But, once I start thinking about something like this I want to go back to first principles. Why do I assume that a learning curve has those axes? They make sense mathematically, but we're not in the world of math. We're in the world of education.

Google N-Gram's first appearance of "learning curve" is in 1914:

<iframe name="ngram_chart" src="https://books.google.com/ngrams/interactive_chart?content=learning+curve&year_start=1800&year_end=2008&corpus=15&smoothing=3&share=&direct_url=t1%3B%2Clearning%20curve%3B%2Cc0" width=900 height=500 marginwidth=0 marginheight=0 hspace=0 vspace=0 frameborder=0 scrolling=no></iframe>

Google Books has a thesis from the University of Chicago by Louis Leon Thurstone in 1919—["The Learning Curve Equation"](https://play.google.com/store/books/details?id=pb5BAAAAIAAJ&rdid=book-pb5BAAAAIAAJ&rdot=1). After a short review of statistical methods, he gets down to it on page 11:

> In the majority of learning curves the amount of attainment gained per unit of practice decreases as practice increases.

Then,

> The use of an equation for this relation enables one to predict the limit of practice before it has been attained.

He was concerned with typing speed. How fast should a sample of people be able to type given some amount of practice? Or, the actual question, when does practice not produce better results? This is not what people think a learning curve is, though. It's not how much you know or have to learn. It's how good you get at it.

He notes that that he experimented with "forty different equations", and eventually enumerates four types of curves. There's quite a bit of math trying to get to simple lines where he can compute the *a* and *b* in the equation \( y = ax + b \).

## speed versus amount

How fast you can produce a unit of work some amount of practice? This is the sort of plot that most people envision when they think of "learning curve".

On the x-axis is the amount of practice, in his thesis, he specifies total number of pages typed since the start of work. The y-axis is the the number of successful work units per time.

Let's set the time to four minutes (the length of the typing test he gave weekly). How many pages can I properly type in that time?

With very little practice, I expect to type very few pages. With more practie units (not time), I should be able to type more pages in the allotted test time.

Let's make this concrete for the discussion of the four plots.

* The "unit of work" is a page of correctly typed text.

* The "total practice time" is the time spent typing pages, correct or otherwise

* The "total practice units" is the number of pages typed, correct or otherwise

## "Number of words in allotted time" versus "weeks of practice" ( speed-time )

The x-axis is the total practice time in weeks and the y-axis is the number of words that you can type correctly in four minutes. This is the curve that most people envision and it's typically hyperbolic. You start with very few words, the progress for awhile, then do not improve because you've reached a physical limit.


## "Time to type a page" versus "time spent typing" ( time-time)

The x-axis is the time it takes to type a page versus the total practice time. You expect this to start at some high number, stay that way for a bit, then have a more rapid downward slope to some limit after which more practice time doesn't improve speed.


## time versus amount (figure 11)

The x-axis is the total time of work and the y-axis is the time to complete a unit of work. With little practice behind a typewriter, the amount of time to complete a unit of work is high. This line descends; as time of work increases, the time to complete the same task decreases (to some limit).


## Some curious conclusions

The absolute number of errors increases with practice, but so does the absolute count of work units. The trick is that the error rate does not increase as quickly as the work done.
