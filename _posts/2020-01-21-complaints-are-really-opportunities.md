---
layout: post
title: People's complaints are really opportunities
categories: software-lifecycle opinion rescued-content
tags: perl
stopwords: Griffenpoof Upwork Ravendor managementless upwork js
original_url: https://www.reddit.com/r/perl/comments/erxeh9/this_has_to_be_the_greatest_perl_job_listing_ever/ff7u7je/
---

*I originally wrote this in response to /r/perl people making fun of
[a job posting on
Upwork](https://www.upwork.com/job/you-know-Perl-you-want-new-part-time-client_~014fdeeb326d0a79a0/).
I've included a screenshot at the end in case the posting disappears.*

<!--more-->

For those of you making fun of [this job posting](https://www.upwork.com/job/you-know-Perl-you-want-new-part-time-client_~014fdeeb326d0a79a0/), welcome to your audience.

This is Perl's customer. Here's a person who's desperately trying to
use Perl and get through things that he sees as problems. I don't
particularly endorse his views, but as someone who provides software
to other people, I have to account for their pain points. Remember,
people's complaints are signs and symptoms of deeper problems, and
likely problems they don't realize. These are consequences of how we
do things and the people we decide to serve.

Every one of his points is something that Perl makes hard for people
and hard for him. You don't get to disagree with that—those are the
actual expressed opinions. You might be able to inform his views, but
writing it off as "trolling" and keeping the status quo denies you the
opportunity to effectively engage someone who's on your side as well
as showing the rest of the internet that you can't effectively respond
to the disparity of stated and revealed preferences.

CPAN has a problem, and has had it for awhile now. At some point, the
scales tipped into dependency-heavy modules. The core code doesn't
have these dependencies, but the test suite does. I've come across
many situations in my work where the tests failed because a test
module could not install. I now try to avoid these modules because
they are fragile. I've written many `Test::` modules, but I tend not
to use them unless I can overwhelming justify another dependency. But,
even in my `Test::` modules, I likely don't have non-core dependencies
outside of the code connected to it, as in `Test::ISBN` for
`Business::ISBN`.

I've also seen situations where a developer decides to use a new
module that ends up pulling half of CPAN into source control. Part of
that problem is the distributed, nobody-in-charge chaos of
managementless projects where any developer can break the company and
stop the flow of revenue, but it's also rooted in the deeply-held
belief that code re-use is the principal virtue that cannot be
challenged. I think in many cases, the Perl community has gone to far
in code re-use to the detriment of people who want to use Perl
casually. We're not as bad as node.js dependency hell yet, but we are
trending that way. People care much more about ease of installment and
distribution than we tend to think. Code purity doesn't make money.

I also understand the complaint about object-orientation, and I
generally agree with him. Many frameworks, not only in Perl, are
general to the point where you have to shoehorn the problem into the
code. This loses what should be a natural connection between the
problem and the solution's interface. I think those two should be as
close as possible. I think in many cases, the problem gets lost in the
syntax. This isn't special to Perl, but I think it's highly correlated
with people who know the syntax and machinery of object orientation
but haven't been taught to employ it effectively. When I worked with
Randal Schwartz, he insisted that we do some projects in Smalltalk.
Best education in OO that I've ever had and I'm glad he made me do it.
Interface is paramount.

An example helps. *Head Start Java* (I think this was the book) had an
example of code to represent buying a cup of coffee.  There was the
coffee, but then what do you do when you add a shot of chocolate,
cream, or whatever? Their solution was to decorate the object to
represent this new idea with all of these add-ons then have a `price`
method that figured it all out. How many ways now can you construct
that object. Three add-ons gives you 16 different ways these things
combine (including all order-dependent combinations of subsets). Do
you want to be the person to figure out why some combinations have
bugs while others don't? Do you [trust every other
developer](https://hynek.me/articles/decorators/) to be as careful as
you need them to be when decorating the object? Like the saying that
no one minds giving up a factor of 2 in performance, no one minds
decorating an object until 10 people do it at the same time.

As a tutorial writer, I understand that they are showing off a feature
(although I think decorators are often misused in the same way
inheritance often is). But, that's not how anyone thinks about that
problem. Look at a restaurant receipt. You have a bill and it has
items. Want to add extra cream for 5 cents? There's just another line
item for that and you don't really care if it went in the coffee or in
the free glass of water. The goal is the figure out how much money to
take in, not describe the combinations of ingredients. The ["stupid
question" menu
item](https://www.delish.com/food-news/a30459226/stupid-question-diner
/) doesn't care what the question is, just that it's part of the bill.

I'm extremely bothered by framework code where I have to go through
several layers to get to the place where the real work is done, only
then to discover that the code has no idea what problem it is solving.
We end up coding to the framework rather than the real case. We start
eating our own tail, then wail and moan that projects take too long. I
wish I had my slides from Frozen Perl 2008 where my keynote dealt with
this issue. Where do we cross the line from adding value to the world
to simply feeding the beast? How many wrappers do we need? At one
company I helped, there were four layers. The top-level script was
just a runner for another script. That adapted the argument for
another layer, which did the same. Three files, each about 10 lines
long, just to get to the place where something is going to start doing
some work. Agile indeed.

There should be another term beside [yak
shaving](https://seths.blog/2005/03/dont_shave_that/) that describes
work we do that we only think gets us closer to the goal instead of
the procrastination and distraction implied by the yak. For what it's
worth, I feel this pain more directly when I have to fix Python or
Ruby code. It's nothing to do with the language or syntax and deals
directly with the actual source of hard-to-read code: organization and
architecture. For what it's worth, I quite enjoy Perl's
multi-paradigmatic approach because it allows me to adjust complexity
for the problem rather than forcing structure onto the solution before
I even start (looking at you, Java).

The serialization issue is fraught too. We don't really do concurrency
in Perl although there have been many attempts at it and that I hope
Perl gets Promises or something similar in core soon. Sharing memory
and synchronizing access is a hard thing. I've been thinking about
that quite a bit lately because I like Raku's idea of Channels and
Supplies. Some people have mentioned Data::Dumper and Storable, but
both of those have serious security issues because they can
[maliciously inflate into objects for classes you never intended to
use](https://www.masteringperl.org/2012/12/the-storable-security-
problem/). It's a problem Perl hasn't solved and more and more people
want and need that sort of thing.

All of these complaints are opportunities for Perl and the community
to do better. They are good opportunities to bring people around by
the slow and careful introduction of better techniques rather than the
heavy hammer of do it all correctly right away or suffer shame and
humiliation. This isn't Harry Potter and this isn't the sorting hat
the figure out who's in Griffenpoof or Ravendor.

If you want to make fun of something though, it's the two space, no
tab indent. That's just a non-starter. Might as well demand we use
emacs.

---

Here's a screencap:

![Upwork job posting](/images/2020-01-21-upwork.png)
