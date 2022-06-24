---
layout: post
title: How not to code
categories: programming
tags: rescued-content opinion
stopwords:
last_modified:
original_url: https://www.perlmonks.org/?node_id=401293
---

*I originally published this on Perlmonks as [How not to code](https://www.perlmonks.org/?node_id=401293)*

Most people seem to most enjoy the actual coding part of the software
life-cycle. Some people may have heard of design, and even
non-programmers know about this part called debugging. It's the
creation of new program statements that is the most fun though, and
since it's so fun, we gravitate towards that part of the process and
do it as much as we can. Damn the torpedoes!

<!--more-->

This isn't a complete list of code avoidance techniques, and I'm sure
plenty of monks will have their own to share.

This meditation is about taking all the fun out of programming. The
fun part causes all the problems: it's the one the creates more lines
of code which leads to more bugs and more work for maintainers and
documenters. Life would be grand if every task could be expressed as a
screenful of code (assuming that we don't have to worry about any of
the code behind the statements we actually see). We'll never acheive
that, but we can still work towards it.

For this meditation, I mean "programming" in an over-arching sense,
including the entire development cycle, including the boring bits. I
mean "coding" as just the bits that involve typing new statements.

"Not programming" means not coding when I don't need to. It's more
than not reinventing the wheel, or [Laziness](http://c2.com/cgi/wiki?LazinessImpatienceHubris).
It's not about code style, code re-use, script archives, or any other source of
code. It's also not about refactoring or reducing the amount of code,
because that's coding too. "Not programming" means not doing
anything. It means not creating more code, however we acheive
that.


## Do something else

The trivial solution is probably the most fun and the least
well-paying. Just don't code. Play Quake. Watch a movie. Do
something else. You could even do what I'm doing right now: write
something for Perl Monks. It's a colossal <s>waste of time</s>
procrastination leverage technique that combines the synergies of the
... sell it anyway that you like, because you probably already know
how to. This isn't a meditation on writing though: it's about not
coding.

## Don't get interns to do it for you

A lot of people see interns as less-than-minimum wage workers who will
do just about anything to get a good letter of reference. Give them
any real work to do and they'll probably take three times as long as
anyone else and you'll have to redo it yourself anyway.

Of course, with proper supervision, interns and junior coders
can do a lot of good work, too. They can pump out a lot of lines of
code for a little bit of money. Don't think that they are just
coders you pay less, though: how many of those lines did you actually
need?

The same goes for outsourced programming: you can't expect good
results when you dump something into the laps of people you have never
met, never talk to, and generally ignore. Despite what managers may
tell you, this does not save you money. Often it costs more, and you
end up coding it yourself, and that's what we're trying to avoid.

## Don't rush to code

If you don't want to do much coding, don't be in such a rush to
code. Pressure-cooker shops that need one-offs in 15 minutes (yes,
they exist) don't count, just as many other situations will not fit
this.

When we start coding before we really know what we
want to do, we often end up with something we don't want or is a lot
more than we should have to maintain.

I used to have a guide at one of my workplaces: a good idea will
still be a good idea in three days. Not only that, you'll still want
the good idea is three days. The fair and bad ideas will sort
themselves out in your head within that time. You'll either see the
downside or just forget about it completely. In that case, you didn't
do any work.

Of course, we don't want to go the other way either. We don't need to
make all sorts of fancy diagrams, UML charts, story cards, or any of
the other things that delay coding.


## If it ain't broke, don't fix it

Some people can be satisfied with ugly, kludgy code. Some people
can't sleep at night unless every equal sign lines up correctly. Guess who
spends more time programming (I don't know either: one probably spends
more time debugging while the other keeps fiddling with things that
don't make the code work any better).

If the code is doing whatever it has to do, let it alone unless you really,
really need to change it (see the "Three Day Rule"). There is usually
enough work to go around anyway. Do something else. Delay and evade
pressure as long as possible.

Inherited code is another story.  I haven't heard too many people
rave about the beauty of the code dropped in their lap. More often
than not, they complain about the long gone employee who was the only
one who understood the code, or why anyone would try to code
FORTRAN in Perl.

## It's probably already there

A while ago, I thought "Wouldn't it be great if I could process a
whole directory of Template files all at once?" I almost started
to write the simple scrip that would be able to do it, but then
I thought "I bet someone has already done this." Indeed, Template
comes with ttree, which does just that.

There are probably a lot of things that you already have and just
don't know about. Find and use those things.

## Redefine the problem

Sometimes I can simply re-define the problem. Does this really need
to be so complicated? Why are we really doing this step? Business
processes develop over time through the hands of many people, some of
which may have become a faded memory. The process keeps going because
it has always happened that way and everyone assumes that everyone
else wants it to happen that way.

## Consider a social solution

Along with a problem redefinition, there might be a better way to
re-arrange the people portion of the problem. If everything were just
technology, wouldn't the world be great? We could solve all of the
problems pretty quickly.

I get to see a lot of different situations since I get to
visit so many companies while working for [Stonehenge](http://www.stonehenge.com), and one of the most common situations is
that the programmers don't work with the system administrators, or the
other way around depending on which side you take. If that weren't
enough, throw database admins into the mix, because they count themselves
as a separate group. There might even a couple of levels of management in there, or
even worse, grumpy off-site telecommuters.

It doesn't matter who's who, who's right, who's left, or who's to
blame. Most likely the different groups don't even really know each
other. They may not have even met. Companies and universities can be
big places, so people are spread out. A lot of programming may just be working around something
that someone else has set up. In some cases, they might have no
particular attachment to that set-up (or, more likely, they do).

People tend to work better together when they know each other. People
tend to work better with you when you've helped them out in the past.
They work really well if they are drinking buddies. Maybe the solution is
really just a night at the pub with the right people.

## Get a different job

No, really: get another job. Many programmers promoted into a managerial
career path find they no longer have time to code. And they probably
get paid more.

