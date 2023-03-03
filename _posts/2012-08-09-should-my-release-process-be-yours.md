---
layout: post
title: Should my Perl release process be yours?
categories: programming perl opinion rescued-content
tags:
stopwords: Hampstead Haryanto Signes Zilla
original_url: http://blogs.perl.org/users/brian_d_foy/2012/08/should-my-perl-release-process-be-yours.html
---

*I originally wrote this on blogs.perl.org as [Should my Perl release process be yours?](http://blogs.perl.org/users/brian_d_foy/2012/08/should-my-perl-release-process-be-yours.html)*

Steven Haryanto asks ["What is your release process"](http://blogs.perl.org/users/steven_haryanto/2012/08/what-is-your-release-process.html). I could have buried my
thoughts in the comments, but [Dean Hampstead suggested it as a topic
for the second edition of Mastering Perl](https://www.masteringperl.org/2012/08/hello-world/\#comment-2). I started to respond there,
but that got a little out of hand too. Whereas [Learning Perl](https://www.learning-perl.com) and
[Intermediate Perl](https://www.intermediateperl.com) are much more "do what I show you because you're
new", [Mastering Perl](http://www.masteringperl.org/) is much more "why do we do this?".

<!--more-->

There are two opposing ways to go with any process. Your process can
be completely external to the actual distribution so that nothing in
the distribution is set up to support the process or its automation.
Or, you can create a process and make your distribution match that.
You choose the one that works for you.

Think about this for the next week, no matter what you are doing,
whether at work or during a hobby or whatever you do. What's deciding
how you do something?

In the Army, we'd say "There's the right way, the wrong way, and the
Army way". Some people think that means the Army does things in such a
completely messed up way that it's a special sort of wrong. It's not
though. It's a process where you have to take random people who have
never worked together and throw them in a dangerous situation in such
a way that they know what to do, even without talking. That is, it's
process-oriented because, in the grand scheme, the process has more
benefits than localized optimizations (and many of the bad things in
such situations can be traced back to a deviation from process).

But I'm not in the Army and there's no way we're going to convince
most of Open Source to do things the same way (although autoconf is
amazing). I don't want anything in my distribution, repository, or
code to know anything about the tools I use to play with it. But, I
should really restate that. **I don't want any of my tool choices to
affect any of your tool choices**. You don't have to use my editor, my
tool modules, or anything else to play with the repository. I want to
be able to change my process without changing my repository. If I
don't like how I was doing things, I don't have to change the things
to fix it.

Some people like the second one. Ricardo Signes made
[Dist::Zilla](https://www.metacpan.org/pod/Dist::Zilla) to handle the
hundreds of distributions he's managed, and some other people have
started using it too. To work with those repositories, other people
need to use Dist::Zilla as well.

I created [Module::Release](https://www.metacpan.org/pod/Dist::Zilla)
to handle my process. Well, I actually created a program I called
*release* and Ken Williams turned it into the module. My approach was
essentially a big shell script. Try this thing by running some
external program, look at the result, and decide if I should continue
to the next thing. Mostly, I had programmed a bunch of sanity
tests—check that the tests pass; check that the dist tests pass;
ensure the repository is clean; and so on. If everything passed,
upload it to CPAN.

Now comes the next problem. Ricardo and I both made tools that we
wanted to use for our own work to exactly match our own process and
way of thinking about things. Those tools make it out to the public
because that's the sort of people we are. We share what we have.

Other people take the tools
we built for our own process and use them. They are on the opposite
side of us though. Where our process defines our tool, our tool now
defines their process. That's almost always a bad relationship with
technology. It might be hard to see that in Perl, but I'm sure you've
seen how poorly a business is run because you have to submit to what
Outlook, Blackberry, or Excel will let you do.

I had made the mistake I usually make, and will keep making, probably.
I put code out there thinking people would take the idea and hack on
it, coming up with much different things. I ended up creating more
work for myself.

But, as with most things, I started supporting feature requests and
generalizing things. I got no benefit from that. I already had solved
my problem and I had, and continue to have, that by supporting other
people that I'm enabling their ignorance by making it easy for them to
adopt a process they don't understand. Not only that, they are
adopting my process, which always has problems even if it is much
better than it used to be. I don't care about a perfect process. I
care about one that's good enough and doesn't make more work for me.
That might not be good enough for other people though, but people tend
to use the tool to absolve them of examining what they need.

Choosing a distribution version is a good example, and it's something
I haven't automated. Some people change the version when they release,
so they can wrap that into the tool that releases the distribution.
They then have to live by the rules their tool applies (because, if
it's flexible enough, it's not that much different from doing it by
hand). I change versions after a release, though. That way, everything
I'm doing is already on the new version, which is usually a
development version. If the last stable release was 1.023, the next
development version is 1.023_01, which leads up to 1.024. I don't
think that's the process anyone else should use, but it's worked for
me. If my tool did that, people would have to live with it (or not use
my tool, which is more likely).

So, the answer is "It depends". Yep, it's still up to you to answer
the question for yourself.

