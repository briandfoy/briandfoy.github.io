---
layout: post
title: My editor progression
categories:
tags:
stopwords:
last_modified:
original_url:
---

I started programming before I had a mouse, or even persistent storage. Typing things into a console isn't weird to me. I was also responsible for my own hardware, which is one of the best ways to learn programming, which is essentially telling hardware to do something.

I learned both vi and emacs as an undergraduate and used them both extensively. I don't particularly like emacs, but its existence or use doesn't offend me. My former business parter, [Randal Schwartx](https://en.wikipedia.org/wiki/Randal_L._Schwartz) basically uses emacs for everything from text editing to video production. I leaned more toward vi because it was available in single user and console modes. However, one sysadmin told me I should use ed because it's always there even when vi isn't. That's an editor from back in the day before monitors. Tom Ryder has an interesting ed walkthrough in [Actually using ed](https://sanctum.geek.nz/arabesque/actually-using-ed/)

Sometime in graduate school, I started some Mac Programming, which I came to detest, and I started using [CodeWarrior](https://en.wikipedia.org/wiki/CodeWarrior). I even learned some 680x0 assembly because those processors had some nice features that made data manipulation really, really fast. Like, it would take 4 hours instead of a week to process a complete 8GB Exabyte tape (which is not the unit of measurement but the company name).

At some point I transitioned to [BBEdit](https://www.barebones.com/products/bbedit/), which I still use today. As a side note, when I've found really odd bugs in BBEdit, maybe five times in 25 years, I've received a reply in hours and usually a new build to test the next day. Try that in open source and nine months later people will still be trying to convince you the bug doesn't exist and even if it did, you're doing it wrong. So yeah, I'll pay the $30 every couple of years to get closed-source technology.

I've also spent significant time in Atom, Sublime Text, nano (PINE!), Notepad++, UltraEdit, TextMate, and many others. Typically, I'll try a new editor for several months to get past the initial "this is too different" phase.

## The coming Dark Ages

Earlier, I mentioned single-user mode and console servers. There's no pointy-clicky in these things. Many programmers working in today's Software- or Platform- as a Service modules may have never had to deal with those access methods. Some sysadmins may have never done it, and even more DevOps people probably have heard the lore but never tried it. If your AWS doesn't work, you just keep fiddling with things, looking at StackOverflow, and restarting. It's a big black box.

But, is that something you really want to brag about? How about after reading [Finding a problem at the bottom of the Google stack](https://cloud.google.com/blog/products/management-tools/sre-keeps-digging-to-prevent-problems), where the issue was a broken foot on a data rack which caused uneven flow of coolant? Those Site Reliability Engineers get paid quite well and don't care about the latest programming fad.

At some point, problems are reduced to the physical world no matter how many layers of programming abstraction there are. What happens when you can't fix your programming problem with programming? What happens when the fix is not something you can edit in your project?

The best programmers I've ever met invariably come from former Soviet states. They didn't have better educations over there, from what I've been told. They had it worse. Sometimes computers and computer literature was forbidden. To program, you had to really want it and had to experientially fill in the missing information in the non-existent manuals. They had to learn the hardware to be able to make it do anything. Being from a former Soviet state is not sufficient; this is straight-up selection bias. But, the point stands.

Now we are in a world where a programmer isn't expected to (and often can't) recreate the systems that could run their program. That is, buy some hardware, install it, configure it, and run the program. As Milton Friedman said:

> "Look at this lead pencil. There’s not a single person in the world who could make this pencil."

He's making a point about the supply chain and the tools to get to the final product (see [Leonard E. Read's "I, Pencil"](https://www.econlib.org/library/Essays/rdPncl.html?chapter_num=2#book-reader)). Consider Thomas Thwaites's attempt to build a toaster from scratch, starting with ore.

<iframe width="560" height="315" src="https://www.youtube.com/embed/5ODzO7Lz_pw" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

These approach _reductio ad absurdum_, but not quite. Just how far back should anyone be expected to understand anything? Today's "full stack" is really as thin as the atmosphere covering the Earth. How many full-stack developers can reasonably administer the operating system layer of things?

But, I don't expect every developer to be a sysadmin. But, since programs control hardware, we should understand a little about it. Otherwise. we're reliant on other people to do out own work (and that's what StackOverflow really is, isn't it?).

