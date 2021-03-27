---
layout: post
title: What's the pull of that planet?
categories:
tags:
stopwords: Birdman Flim
last_modified:
original_url:
usemathjax: true
---

[The Amazing Randi recently passed](https://www.rollingstone.com/culture/culture-news/james-randi-obituary-1079316/), so I finally starting reading his book [Flim Flam](https://amzn.to/3kDjWWU). In one of the early chapters, he goes after astrology, but makes a unsupported, weird, glib claim. The entire book is him castigating others for doing just that.

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/r70HsEvNRck" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

He notes that astrologers like to say that the effect of the planets alignment matter. Randi asserts for in the case where every planet aligns, merely changing your position from standing up to sitting down nullifies any of that effect.

> Lowering the body a distance of 25 inches would bring it closer to the gravitational center of the earth and neutralize all effects of the other heavenly bodies... (in Chapter 4, "Into the Air, Junior Birdman")

He uses the number "25 inches", which is also magical later in the book as a cubit, which leads to the ["pyramid inch"](https://en.wikipedia.org/wiki/Pyramid_inch) (1/25th of a cubit), or 1 millionth the polar radius.

I set out to do the math. That's actually a bit too complicated at first pass even if it was fun to research. Who cares about 25 inches when we're dealing with objects and masses tens of orders of magnitude higher? The Sun is 150 million miles away. What instrument is going to know the difference?

What's the gravitational effect on the Earth right now (November 17, 2000 at about 1800h UTC)? Very few sources give real time distances between planets, preferring to give "average" distances based on dubious calculations. But, if you go through the actual orbital mechanics, you discover that most of the time, [Mercury is closer to Earth than any other planet](https://physicstoday.scitation.org/do/10.1063/PT.6.3.20190312a/full/). That's the sort of data I want to think about astrological effects. If we're talking about 25 inches, I don't want to be off by several million miles because I used an average distance. [timeanddate.com](https://www.timeanddate.com/astronomy/planets/distance) gives the real time distances.

![](/images/randi_astrology/timeanddate.png)

That's a linear representation even through the planets are all over the place. Those guys are zippy around the sun, moving away or from the earth is various combinations. Notice the orbit of Eros, which crosses that of Mars.

![](/images/randi_astrology/solar_system.png)

I plug that into a Google Sheet to figure out some relative gravity numbers. The Force column leaves out the gravitational constant and the mass of earth because the last column divides everything by the force from the Sun, canceling out those values. Sadly, no one wants to report numbers for Pluto, which is still a planet, but it's so small (smaller than our Moon) and so far away it doesn't matter.

<div class="center">
<iframe src="https://docs.google.com/spreadsheets/d/e/2PACX-1vQhjBD08iBStX3sv-ySo7Ugl1v9wc9UTd7u9SfSeSj8l0cYi5mupuY-QikNPp4UfeqIg8o63Ij06QTF/pubhtml?gid=0&amp;single=true&amp;widget=true&amp;headers=false&amp" width="100%" height="300"></iframe>
</div>

Play around with those numbers and you see adding another million miles affects the relative force in the third or fourth decimal place. And, I haven't even accounted for the inexact numbers since the distances and masses have uncertainties orders of magnitude larger than 25 inches or the human weight.

Even then, as we mostly already know, the Sun and Moon dominate the gravitational effects on earth. The Moon is about 1/100th the effect of the sun. Next is Jupiter, at about 1/100th the effect of the Moon.

Numbers are hard to read. Here's a pie chart of the proportion of all gravitational effects. It's all Sun and a very thin slice for the rest of it. But, exclude the Sun and look at the proportions in just that thin slice. The plot looks almost the same, with the Moon dominating.

![](/images/randi_astrology/pie_chart.png)

Even better, here are those different pie charts presented by their proportions to each other:

![](/images/randi_astrology/pie_relative.png)

But thinking about it further, everything is a waste of work even if I did have a lot of fun working on it.

Standing up or sitting down are a lot less important than mere altitude. The top of my block in New York City is 15 feet higher than the bottom, and about 45 feet higher than the subway stop. But I'm only 167 feet above sea level, and people in Colorado barely have enough air to breath.

And that really turns out to be the problem with The Amazing Randi's book. He laments that several publishers passed around the book before it was published, and he blames a conspiracy to stop the truth. That might be true, but it's just poorly written. But, I had to buy this book instead of getting it from the library because they don't have a copy. [The Strand](https://www.strandbooks.com), with 12 miles of books, didn't have it.

If you've seen one of his presentations, you know he's eccentrically charismatic, clever, and direct. None of that shows in this book, which is about as twice as long as it needs to be. Rather than organize by type of scam, its apparently random. Some chapters focus on one con while others group related cons. He castigates others for their false claims, but in this case with astrology, he makes his own unfounded assertions.

## Some better versions of The Amazing Randy

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/lTn0t_7pGZo" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/qqCJDpNnHNI" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/LjF1sUZEy2U" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
