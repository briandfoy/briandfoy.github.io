---
layout: post
title: How can I speed up my Perl program?
categories: perl programming
tags:
stopwords:
last_modified:
original_url: https://stackoverflow.com/a/177643/2766176
---

*(this originally appeared as [an answer](https://stackoverflow.com/a/177643/2766176) on Stackoverflow)*

<!--more-->

There are many things that you might improve on, so you first have to figure out what's slow. Others have already answered that question. I talk about this a bit in [Mastering Perl](http://www.masteringperl.org/) too.

An incomplete list of things to think about as you are writing new code:

* Profile with something like [Devel::NYTProf](http://www.metacpan.org/module/Devel::NYTProf) to see where you are spending most of your time in the code. Sometimes that's surprising and easy to fix. [Mastering Perl](http://www.masteringperl.org/) has a lot of advice about that.

* Perl has to compile the source every time and compilation can be slow. It has to find all the files and so on. See, for instance, ["A Timely Start"](http://www.perl.com/pub/2005/12/21/a_timely_start.html), by Jean-Louis Leroy, where he speeds everything up just by optimizing module locations in <code>@INC</code>. If your start-up costs are expensive and unavoidable, you might also look at persistent perls, like pperl, mod_perl, and so on.

* Look at some of the modules you use. Do they have long chains of dependencies just to do simple things? Sure, we don't like re-invention, but if the wheel you want to put on your car also comes with three boats, five goats, and a cheeseburger, maybe you want to build your own wheel (or find a different one).

* Method calls can be expensive. In the Perl::Critic test suite, for instance, its calls to `isa` slows things down. It's not something that you can really avoid in all cases, but it is something to keep in mind. Someone had a great quote that went something like "No one minds giving up a factor of 2; it's when you have ten people doing it that it's bad." :) Perl v5.22 has some performance improvements for this.

* If you're calling the same expensive methods over and over again but getting the same answers, something like [Memoize](https://metacpan.org/pod/Memoize) might be for you. It's a proxy for the method call. If it's really a function (meaning, same input gives same output with no side effects), you don't really need to call it repeatedly.

* Modules such as [Apache::DBI](https://metacpan.org/pod/Apache::DBI) can reuse database handles for you to avoid the expensive opening of database connections. It's really simple code, so looking inside can show you how to do that even if you aren't using Apache.

* Perl doesn't do tail recursion optimization for you, so don't come over from Lisp thinking you're going to make these super fast recursive algorithms. You can turn those into iterative solutions easily (and we talk about that in [Intermediate Perl](http://www.intermediateperl.com)).

* Look at your regexes. Lots of open-ended quantifiers (e.g.,) `.*`) can lead to lots of backtracking. Check out Jeffrey Freidl's[Mastering Regular Expressions](http://oreilly.com/catalog/9780596528126/) for all the gory details (and across several languages). Also check out [his regex website](http://regex.info/).

* Know how your perl is compiled. Do you really need threading and `DDEBUGGING`? Those slow you down a bit. Check out the perlbench utility to compare different perl binaries.

* Benchmark your application against different Perls. Some newer versions have speedups, but some older versions can be faster for limited sets of operations. I don't have particular advice since I don't know what you are doing.

* Spread out the work. Can you do some asynchronous work in other processes or on remote computers? Let your program work on other things as someone else figures out some subproblems. Perl has several asynchronous and load-shifting modules. Beware, though, that the scaffolding to do that stuff well might lose any benefit to doing it.
