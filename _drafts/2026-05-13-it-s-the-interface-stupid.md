---
layout: post
status: _draft
title: It's the Interface, Stupid
categories:
tags:
stopwords:
last_modified:
original_url:
---

I think I started to write about what's important for documentating code, then gave up to do something else but left the draft on my desktop. This is half baked, but here it is. It was something about maintainable code, and maybe something with regexes.

<!--more-->

This advice applies to just about any language, and is a problem in just about any language (although I don't know if others have readable regexes). I see the same mistakes in most of the languages I deal with.

[unmaintainable code : Java Glossary](https://www.mindprod.com/jgloss/unmainmisc.html) is a fun site that takes it from the other direction: how to write unmaintainable code.

I think structure and relationships are more important than syntax, but, syntax can also limit or complicate structure.

Last week, I had to deal with a Python script that was all single-letter variable names and a wacky, cumulative, unexplained, deep data structure. The program was a constant fight against this data structure, and no amount of forced indenting was going to fix that. Choose the wrong data structure screws up everything that comes after it.

I think it stems from the same problem too: most people rise to the minimum level of skill the job demands and stop. This is not irrational, and it's perversely rewarded. How many people are given the space and time to reflect on their creations or explore better ideas? And how many people even work with people who are much better than themselves?

Then there is the opposite extreme: architecture astronauts who pile layer upon layer of abstraction to the point that it's difficult to remember, or even discover, where the work actually happens. Or, if they favor dependency injection, what interface your object must obey. [Thinking about Parnas decomposition](https://github.com/briandfoy/parnas_decomposition) is a good exercise. Also, read [Robert Martin (Uncle Bob) failing to explain it to John Ousterhout](https://github.com/johnousterhout/aposd-vs-clean-code). Find Brian Will's videos on YouTube. Or Randal Schwartz talking about why [he decided to never learn Python](https://medium.com/@realmerlyn/the-day-i-decided-never-to-learn-python-2c59d1a1edc5).

Part of this is how language communities have decided to document things and how people then interact, and fail to interact, with those docs. Perl has great but unorganized docs, while most other things I run into have organized but seriously deficient docs. Yes, I can see the list of methods, but there's no guidance on intent, interactions with other things,


* show me how you expect this thing to be used. [Mojolicious and its discussion of "fluent programming"](https://docs.mojolicious.org) is very good in this regard. It has tutorials and guides next to module-level documentation.
* don't make me do low-level or irrelevant things. For example, [LWP](https://www.metacpan.org/pod/LWP), which was a huge jump in usability for its time (over chat2.pl, just as awesome for its time. Waves to u/RandalSchwartz in the back), isn't an integrated library that takes care of details for me. I get why the HTTPS protocol was kicked out of the LWP main distribution, but that doesn't mean I like it. And, then there's Python's requests, which, no, I can't even.
* create an interface that matches the problem. As an open-source developer, I make Perl modules for people I don't know for problems I don't know. That's a particular sort of programming. But when I'm writing internal stuff, I don't need that level of generality, even though I reflexively reach for it. Instead, I have the opportunity to target a concrete problem, eschewing the generality that can make code relationships and hierarchies harder to understand.
* choose a way of doing things, and do that everywhere as much as possible. Everyone has this problem, and I have this problem too, whether in solo or team programming. Perl, being an avowed multiparadigmic language, makes this even worse. That's a principle, not a method, and you have to decide what ideas and structure that you want to highlight across the codebase.
