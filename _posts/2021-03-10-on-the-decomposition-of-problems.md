---
layout: post
title: On the decomposition of problems
categories: programming
tags: mark-jason-dominus magnus-carlson
stopwords: Arcus Blaise Carlsen Dominus's Magnus Ousterhout Tullius bn empathies unencouraging
last_modified:
original_url:
---

There's a joke that I can never quite get right, and even then telling it
at a party often gets the rather unencouraging response that the tale attempts
to illustrate. It's all about how people reduce problems.

<!--more-->

> The Engineer, the Physicist, and the Mathematician are each given the
task of solving the problem of the light bulbs burning out in the
hallway of the science building. The Engineer sets about to design a
longer lasting, high efficiency light bulb that will last much longer.
Three years, they deliver this bulb to the science building and the
custodian says they will try it the next time a light bulb burn out.

> At the same time, the
Physicist sets about to determine how to use the existing bulbs more
effectively. They discover that the bulbs are running too hot, which
cuts their life expectancy considerably. They design a new circuit
would reduce the amperage to bring the light bulb within its apparent
tolerances and extend its actual lifetime to the expected time. They
deliver this after several months, much faster than the Engineer's
solution. No one does anything because the custodian is not going to
change the existing wiring in the building since there is no
burnt out light bulb at the moment.

> Neither the Engineer nor the Physicist noted that there was no light
bulb that was burnt out when they delivered their solution. Given the
same problem, the Mathematician had gone into the hallway with a broom
and broken the burnt-out lightbulb. Asked why they did that, they said
they had noticed whenever the lightbulb was shattered and its glass
had fallen on the floor, a new light bulb showed up. They could not
explain how their solution worked for burnt out light bulbs, but they knew
that they could restate that problem into one that had a solution.

Set aside the realms of reality in each Archetype deals (from more
concrete to more abstract) because they are all mostly doing the same
thing: reducing most of a problem to something else. The first two,
the Engineer and the Physicist, fall back on things they know:
processes, formulas, and such. They have meat grinders that solve most
of their problems, and they cram the problem into their particular
meat grinder and crank the handle until their particular sort of
sausage comes out.

The Mathematician, however, doesn't have a meat grinder. They have an
infinite number of meat grinders, so they find the way the one that
takes their current problem. Having found that, someone else cranks
the handle because, having found a solution, the Mathematician is on
to something else. Perhaps a later Mathematician will find a shorter
path to a better meat grinder, after which the Mathematics Department Chair
will counsel them that re-solving known solutions is not a path to tenure.

And, as a postscript to that joke, the Physicist might see that and then
break every lightbulb in the building to see what happens. But, only if
they are an Experimental Physicist. Part of the magic of math is not
showing how you did it.

There are two sorts of programmers: Those who get the joke and those
who don't. Or, there are 10 sorts of programmers: Those who understand
binary and those who don't. And so on.

I think about this joke when I solve other people's problems or
help them solve their problems. Often, I'm trying to figure out the class
of problem they really have and at which level they need a solution. I can
think like this because I've been practicing for decades, and in all of
that practice, I've seen a lot of different situations.

The breadth of that set of situations is more valuable than particular skills.
It's not about the skills inherit in a problem. It's the variety of solutions
and scenarios that someone can bring to bear on the problem.

Think about that joke a little harder. At first it looks like it's just
making fun of the different dispositions of three closely related groups.
But, the joke has a structure that's close to universal: "same, same, different".
And, that structure is the point of the joke. By establishing two parallel
scenarios, the joke gives a third so that you will apply the same thinking.
The joke, by giving two exemplars, has forced you into a pattern of thought
about the third. And, having done that, the joke can now depart from
the frame it constructed. This allows the story to surprise you by breaking
the frame.

Breaking the frame is the structure but also the literal narrative. You
expect the Mathematician to do math thing, but they do human things. The
Mathematician uses a solution that's not particular to math even though
that's how it's presented.

The Mathematician may have been thinking like a mathematician, but
they used something outside of the realm of math (and available to
anyone) to solve the problem. That is, their conception of the
possible set of tools was infinitely wider because it wasn't
constrained by the occupational stereotype.

And yet, here I am, over half way through this, still using the same
ideas. ("I apologize for such a long letter - I didn't have time to
write a short one.", said Mark Twain, or Benjamin Franklin, or Abraham
Lincoln, or Winston Churchill, or Blaise Pascal, or Henry David Thoreau, or Marcus
Tullius Cicero [Quote Investigator](https://quoteinvestigator.com/2012/04/28/shorter-letter/)).
All of this is to say that your ability to recognize the structure of
the problem along with a big enough toolbox allows you to effectively
solve problems.

Curiously, "Same, different" isn't enough to make the joke because there's no time
to develop the pattern and lead the listener to the expected then denied
conclusion. Then "Same, Same, Same, Different" seems like too much. But,
some cultures are "one, two, many" while others are "one, two, three, many",
and maybe there's "one, many". So maybe their jokes are different.

## Recalling slides

I was explaining to a friend that experienced poker players probably
don't do that much math. They might state odds and probabilities, but
they probably have those memorized. They go straight from observation
to final results because they have been in that situation so many
times before.

That's is, the more situations you've seen and the more ways you've
experienced a problem, the more likely you can go straight to an idea
of a solution. The more ways that you've previously approached a problem,
the more likely you have an approach that will work for another problem.

In one line of work I'm involved in, the leaders talk about "slides". You
see something weird, and they say "add that to your slides". Add that to
the situations that you'll remember. In some future scenario, recall the
slides that fit and act. Sometimes that's because these split-second, life-and-death
scenarios don't have time for reasoning. This is the basis for USAF Colonel John
Boyd's OODA loop in [Organic Design
for Command and Control](https://pdfs.semanticscholar.org/6ca9/63358751c859d7b68736aca1aa9d1a8d4e53.pdf):

> orientation is an interactive process of many-sided implicit
cross-referencing projections, empathies, correlations, and rejections
that is shaped by and shapes the interplay of genetic heritage, cultural
tradition, previous experiences, and unfolding circumstances.

## But...

Conversely, consider, Magnus Carlsen, the top chess
player in the world (and perhaps of all time). His strategy is to
present his opponents situations they have not seen so they cannot
reduce his play to things they have seen before. He physically and
mentally exhausts them by requiring them to think rather than fall
back on prepared or known situations.

Curiously, part of the idea of the OODA loop is to create chaos for
your opponent while forcing the other side to clarify their intentions.
[Robert Greene wrote](https://powerseductionandwar.com/ooda-and-you/):

> The proper mindset is to let go a little, to allow some of the chaos
to become part of his mental system, and to use it to his advantage by
simply creating more chaos and confusion for the opponent.

## Math is hiding your work

Consider Mark Jason Dominus's post [484848 is excellent
](https://blog.plover.com/math/484848.html). He starts by proving *for
all n, 4bn - 7an = 4*. Why? Because he'd already struggled with the
problem and that was the answer. When he came back to answer the
question, he took the knowledge he had at the end of this struggles
and used it straightaway to answer the question. And, I then expanded
Mark's excellent number ideas greatly ([excellentnums.com](http://www.excellentnums.com))
before Matthew Arcus completely and brilliantly [solved it](https://matthewarcus.wordpress.com/2016/01/16/excellent-numbers/)
with something neither of us had considered.

This is similar to something John Ousterhout says about clean, minimal
code. We don't know how long it took to get the code that simple and clean.
We see end (sometimes intermediate) results.

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/bmSAYlu0NcY" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>
