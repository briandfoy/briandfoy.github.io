---
layout: post
title: How do you master Perl?
categories: opinion
tags: perl
stopwords:
last_modified:
---

https://www.perlmonks.org/?node_id=446556

<p>
I've thinking about what's beyond the basics of Perl, and here's where
everyone gets to expand my thinking and provide a reality check. What
comes next? What's the "upgrade path"? Do we keep teaching them more
facts about Perl until they know all of the documentation? Teach them
to use the modules they need to use to get their particular job done?
Or is it something else?
</p>

<readmore>
<p>
I just finished working on the fourth edition of <i>Learning Perl</i>,
which should be out towards the end of summer. (I don't have details
on anything yet, but I'm working with the O'Reilly marketing people to
get all that stuff.  And yes, Randal and Tom worked on it: I was just
renamed "Dances with Wolves and Editors" ;) Teaching beginners is easy
because we know where to start and everyone is pretty much in the same
place. A lot of people are content to stay at that level, and that
might be okay for them. What catapults people into the higher levels,
though?
</p>

<p>
Besides specialized topics like CGI, LWP, Testing (chromatic and Ian
Langworth are quickly approaching a completed manuscript that looks
really, really good), there isn't a long vertical path, or even a
contiguous one.  People's interest diverge. At <a
href="http://www.stonehenge.com">Stonehenge</a>, after we teach the
intermediate Alpaca course, it's either a buffet of shorter classes on
specific topics or custom-designed courseware. It's also a captive, targeted
audience. What about the Perl world at large? If we can't group them
into a particular class because that's the class they signed up for,
what do we pick out of all the things that exist as the important
things to teach or write about?
</p>

<p>
Beyond <i>Learning Perl</i>, which we designed to cover the 80% of
Perl that most people will need to know to write basic programs, there
is <i>Learning Perl References, Objects, & Modules</i> (which we are
now updating), Simon Cozen's soon-to-be-released update to <i><a
href="http://www.oreilly.com/catalog/advperl2/">Advanced Perl
Programming</a></i> (which is a very cool book, having just read the
pre-galleys), Mark Jason Dominus's <i><a
href="http://perl.plover.com/hop/">Higher-Order Perl</a></i> (which he
talks about in <a
href="http://www.theperlreview.com/Interviews/mjd-hop-20050407.html?pm
" >my interview with him</a>), and Damian's upcoming <i>Perl Best
Practices</i> (which I'm now reading in pre-proofs). There are a few
other general subject books too, so my apologies to those I've
neglected.  I've read too many books this week. Most of these,
however, focus on something to do with the Perl language (surprise!)
</p>

<p>
The more I think about this, the more I'm convincing myself (for good
or ill), that the things programmers need to learn next aren't so much
about Perl as things they should know how to implement in Perl, but
could also do in some other language. Surely I can teach more and more
Perl stuff, but at some point the student who really wants to learn
more needs to have a "programming lifestyle" that supports it.
</p>

<p>
I've jotted down a couple of these lifestyle issues. They aren't
revolutionary or new, and I don't have complete discussions on them.
When I started this, I wanted to write the complement of [id://401293],
but I really think mastering Perl (or any language) goes beyond
the stuff that other people can tell you: you need to do things
yourself.
</p>

<h3>You need a safety net</h3>

<p>
Most of us know we should use source control and write tests, but I'm
starting to think that to teach advanced concepts, people need a base
camp to start their exploration.  If you mess things up, you haven't
completely horked your production system or corrupted your operating
system. What else does the safety net comprise?
</p>

<h3>Be bold</h3>

<p>
Once you have the safety net, just try things. You shouldn't have to
ask questions like "What happens if I do this?" because you do it and
find out.  An expert is someone who has made every mistake, so you
have to start making more mistakes. Or, in a foodie analogy, I heard
an interview with a food writer who said "If you aren't getting food
poisoning, your not being adventurous enough".  To experience the
really good things, sometimes you have to be bold and take risks.
Maybe you get burned a couple times, but the times you don't are worth
it.
</p>

<h3>You have to know more</h3>

<p>
A lot of advanced stuff is just knowing more, and that usually means
knowing things that aren't immediately useful.  You can't wait until
you need something to learn it if you want to do fancy things since
fancy things tend to be the cobbling together of many things.
</p>
<p>
I think one of the greatest enemies of this part is "Search". When
you can jump right to the part you want, you often miss a lot of
unrelated but interesting things that surround it. You don't get
the opportunity to subconsciously remember stuff. I have a love-hate
relationship with online dictionaries because I miss running my
finger down a column of words and learning a word or definition I didn't
intend to learn.
</p>
<p>
As part of this, I recommend to my beginner Perl students that they
read all of [doc://perlvar] and [doc://perlfunc], although I stress
they don't have to try to remember any of it.  Some day in the future,
they may remember that there is a function called gethostbyname (or
kill, or whatever).  They may not remember exactly what it was or how
it worked, but they should recall that Perl has a lot of built-ins
that deal with socket stuff.
</p>

<h3>Learn other languages</h3>

<p>
In a Perl class or book, I'm not going to teach Lisp.  MJD talks
about Lisp in <i><a href="http://perl.plover.com/hop/">Higher-Order Perl</a></i>, but not enough to distract
from the Perl. Still, the book is all about using ideas from functional
programming. In a recent thread, Randal talked about a particular Smalltalk
book.
</p>
<p>
Other languages give you perspective on the one that you want to use. You
might hate Java, or C++, or something else, but the honest programmer has
to admit that smart people developed those things and had at least a
couple of good ideas. Even the bad ideas simply make you appreciate
your language of choice that much better.
</p>
<p>
Once you know other languages, even if you only can read them (rather
than create useful things in them), you can read other books on
programming to learn high-level skills and techniques which you
can then apply to Perl.
</p>
<p>
Knowing that, do we really need a "Do Bar in Foo" book for every
combination of task and language? You cut yourself off from
mastering your favorite language if you don't pay attention to the
good ideas and idioms in other languages.
</p>

<h3>Learn how to answer your own questions</h3>

<p>
The best part of my college education were the classes where the
professors wouldn't answer questions.  It's not that they didn't want
us to ask questions: they were training us to be able to answer
questions on our own. Every upper level chemistry class I had in my
undergraduate days had a tough library assignment that came with no
instructions other than "the answer is in the library". A couple
classes were merely "this instrument needs to be rewired, and here's a
bottle of mercury to build the barometer you'll need. It's due next
week. Good luck." To be certain, it sucked, but after a while, I knew
how to find information and answer my own questions.  I didn't
even have Google then.
</p>
<p>
Or do you just ask questions as Anonymous Monk? :)
</p>

<h3>Reinvent the wheel</h3>

<p>
In <i>Advanced Perl Programming, Second Edition</i>, Simon talks
about the "rites of passage". Those are the things that the intermediate
programmer has to go through to pass onto the ranks of advanced
programmer, and they are all about re-writing something that is
usually already done much better elsewhere: templating engine, command
line argument parser, and so on.
</p>
<p>
There's some inflection point in the learning path where all that
good advice we give to beginners is bad advice.  Stuff like "use
a module" and "just use a regex" get in the way of "<a
href="http://blogs.pragprog.com/cgi-bin/pragdave.cgi/Practices/Kata">kata</a>",
where the intermediate programmer needs a topic against which he
tries new techniques and approaches.
</p>
<p>
Back in the day when I was answering a lot of questions on comp.lang.perl.misc,
instead of giving just one code sample, I'd give several. I tried to get
each answer to do the job with a different feature. One might use a regex
while another one uses index().
</p>
<p>
Not only that, but it's in re-inventing something that you discover just
how difficult the problem is, and you appreciate design decisions and limitations
in what already exists. It's almost like you have to bang your head against
the wall or touch the hot frying pan to learn that those things hurt. It's
empirical learning: there is no knowledge without experience.
</p>
<p>
You don't have to use the re-invented thing in production, though. :)
</p>
<p>
What other good beginner advice is bad intermediate advice?
</p>

<hr>
</readmore>
<p>
Okay, I'm stopping there because it's 5:30 am and I'm starting to babble.
My mind is mush and open to the wisdom and experience everyone else has to
offer on what you need to do to master Perl. :)
</p>

<!-- Node text goes above. Div tags should contain sig only -->
<div class="pmsig"><div class="pmsig-366986">
-- <br />
brian d foy <brian.d.foy@gmail.com>
</div></div>
