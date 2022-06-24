---
layout: post
title: X is not my favorite language
categories: programming
tags: pascal unix kernighan
stopwords: rando
last_modified:
---

In 1981, Brian Kernighan, co-creator of Unix, wrote a paper he
called ["Why Pascal is Not My Favorite Programming Language"](http://doc.cat-v.org/bell_labs/why_pascal/why_pascal_is_not_my_favorite_language.pdf). Part of
his abstract points out that the language was not originally aimed at systems programming.

<!--more-->

> Pascal was originally intended primarily as a teaching language, but it has been more and more often recommended as a language for serious programming as well, for example, for system programming tasks and even operating systems.

I originally ran into Pascal because some of the electrical engineering
students around me in college would use it, and it was the language
for Mac (Classic) programming. That's how I started using CodeWarrior,
transitioned into C, and so on. I never used Pascal for anything other
than toy programs, and the Mac programming interfaces handled most tasks.
[Vintage Apple collects many of the books I remember using back then](https://vintageapple.org/macprogramming/).

Brian calls out nine different pain points he found in Pascal while he
was trying to rewrite some tools. Some of them are syntactic and some
are design problems. These are not that far off anyone used to one
language trying to use another, even though we should pay much more
attention to him over a rando Twitter troll.

Some curious quotes:

> Pascal, in common with most other Algol-inspired languages, uses the semicolon as a statement separator rather than a terminator (as it is in PL/I and C). As a result one must have a reasonably sophisticated notion of what a statement is to put semicolons in properly.

Then, a little later:

> One generally accepted experimental result in programmer psychology is that semicolon as separator is about ten times more prone to error than semicolon as terminator.

My preferred language, Perl, uses the semicolon as a statement separator.

He ends with this gem:

> People who use Pascal for serious programming fall into a fatal trap. Because the language is so impotent, it must be extended. But each group extends Pascal in its own direction, to make it look like whatever language they really want.


