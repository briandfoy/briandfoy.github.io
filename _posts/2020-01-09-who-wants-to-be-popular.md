---
layout: post
title: Who wants to be popular?
tags: perl rescued-content opinion
stopwords: yq jq
---

*\[I originally wrote this in the /r/perl thread [Perl as top
language](https://www.reddit.com/r/perl/comments/eldoks/
perl_as_top_language/), but I've rewritten most of it here\]*

Every so often, someone new wonders what it would take to make Perl
the coolest language again. It's an evergreen topic and a natural one for a
new person to ask. That it's a mine field is a completely reasonable thing
to not know.

---

Perl doesn't need to be popular to be a good decision. It's available
and supported, and it's easy to find help. All for free. As long as it
has those three things, we're good.

Most people's problem is that other people don't select Perl for big
enterprise projects. I don't think there's anything that Perl can do
about that because the problem isn't the language.

Most programming ventures anywhere are a mess and staffed by people
who could use much more professional development and time to write
good code, but they aren't given that. Almost every place I've worked
that promised it degraded to day-to-day firefighting within six
months. So, forget about doing something that requires them to start
over.

A lot of programming is done by people who aren't in programmer roles
just like most writing is done by people who aren't "writers". It's a
part of their day and it takes longer than they can really give it.
They are focusing on biology, accounting, whatever, so even if they
did have time to learn more about something, it's probably going to be
their main subject and not the tool. I have another rant about how we
misstructure teams and misallocate resources, because the best way
to solve that is to have a programmer with a little bit of domain
knowledge working with a domain expert with a little programming
knowledge. That's not what we do though.

Perl, however, is for programmers, and especially those who like knobs
and dials. Sysadmins   are that sort, too. It's a powerful language
with an amazingly amount of flexibility. Despite "baby Perl", many
people who program as part of their work don't particularly care about
knobs and dials. And, it's pointless to try to make them care about
those things that aren't making their jobs easier or helping them go
home on time. Many of these people do not go home to hobby projects or
read Hacker News or whatever else might immerse them in a particular
tool.

People (including me) use tools, and often don't care where they come
from if they are good and make their lives easier (or even bad and
make their lives easier). I use WordPress because I barely have to
think about it and I don't really care that it's PHP. I also use
Jekyll, a Ruby thing, because it's easy and I don't have to think
about it. Terraform is Go (mostly). I really like that there's a [Perl
library for AWS](https://metacpan.org/pod/Paws), but if I'm doing
serious work I'm using the Ruby
[aws-sdk](https://aws.amazon.com/sdk-for-ruby/). yq (jq for YAML) is a
Python thing that supplanted my own feeble attempts to do XPath like
stuff in Perl.

We should have lots of options and lots of ideas! If you want Perl to
be popular because you don't want to use any other language, well, get
over that. Learning other languages helps you in your favorite. And
for everyone reveling that their single language has the spotlight
now, just wait. :)

One of the things that hasn't turned out well for Perl is the
insistence that anything a "true believer" use has to come from Perl.
For awhile, various people tried to compete with fledgling Perl
projects in arenas that had already made their decision. You aren't
going to be successful by starting the race late and just getting to
parity with an existing tool people are already using. Perl doesn't
even have tools that would compete with those enterprises use to get a
lot of the boring everyday work done. Many of those people don't even
like those tools, but that's what there is and they deal with it.

So, let's spend more time making new tools for hard problems that
haven't been solved yet. Then, talk about them as tools instead of
talking about them as Perl. Its problem can't be "there's not a Perl
way to do this" or "I want to try things in Perl". It has to be "this
thing is now a lot easier than any other way".

Or, you can go the way of [Mojolicious](https://mojolicious.org) and
do something that's been done a thousand times before, but do it
insanely better. It's like going back to the Stone Age when I have to
deal with any other web framework in any language. But, good luck with
that–few people in the world could pull that off.
