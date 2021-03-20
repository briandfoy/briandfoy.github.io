---
layout: post
title: Uncle Bob, Lesson 4
categories:
tags:
stopwords:
last_modified:
original_url:
---

*"Uncle Bob" is Robert Martin of [CleanCoder](http://cleancoder.com/products). You
may have heard of the Agile Alliance, Extreme Programming, and the SOLID
principles. That's "Uncle Bob".*

I've used and even taught Test Driven Development. I'm happy I did, but
it shouldn't be a religion. As with anything, take the ideas that work
and leave the rest. Most of these sorts of debates center on people's
disagreements on how to optimize for their preferences and ideas, along
with them dictating what your ideas and concerns should be.

<div align="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/58jGpV2Cg50" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Three laws of Test Driven Development

* Programming is basically (see end of [Lesson 1](/uncle-bob-lesson-1/), Halting Problem and Correctness):
	* Sequence
	* Selection
	* Iteration
* There's nothing new in programming languages since Prolog.
* New languages are old ideas repackaged.

* Faithfully report impossible deadlines, and don't commit to "just try"
* If someone says "just try", say "we are trying"

## Three laws of Test Driven Development

* You have to write the failing test first, then the code. (He said in Lesson 2 that the Mercury space program wrote tests in the morning and implemented in the afternoon).
* You don't write more of a test than you need for the next thing.
* If you are really good in the debugger, you might be spending your time on the wrong thing.
* Write the code in a way that you can test it
* Testable code is decoupled code
* Inheritance is the tightest coupling we get
* Mutation tests (fuzz) - if tests survive a mutution, the tests are crap

* Outside-In - lots of mocks and test doubles
* Stateless - no mocks
* London versus Chicago

## But also

* [Distillation of “TDD, Where Did It All Go Wrong”](https://herbertograca.com/2018/08/27/distillation-of-tdd-where-did-it-all-go-wrong/)

<div align="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/EZ05e7EMOLM" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Also in this series

* [Lesson 1 - Clean Code](/uncle-bob-lesson-1/)
* [Lesson 2 - Comments](/uncle-bob-lesson-2/)
* [Lesson 3 - Professionalism](/uncle-bob-lesson-3/)
* [Lesson 4 - Test Driven Development](/uncle-bob-lesson-4/)
* [Lesson 5 - Good Software Architecture](/uncle-bob-lesson-5/)
* [Lesson 6 - Production vs. Development](/uncle-bob-lesson-6/)
