---
layout: post
title: Uncle Bob, Lesson 1
categories: programming
tags: uncle-bob object-oriented
stopwords: Bjarne Booch Edsger Stroustrup booleans polymorphism
last_modified:
original_url:
---

*"Uncle Bob" is Robert Martin of [CleanCoder](http://cleancoder.com/products). You
may have heard of the Agile Alliance, Extreme Programming, and the SOLID
principles. That's "Uncle Bob".*


<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/7EmboKQH8lM" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

##

* Code is messy to start because coding is hard
* It's still messy when it works for the first time
* But at that point people move on to the next thing that doesn't work
* Your job is to write code other people can maintain
* Old code trains new people to write old code
* The only way to go fast is to go well (or, in my world "Slow is smooth and smooth is fast")

## What is clean code?

* Kent Beck -
* Bjarne Stroustrup - "clean code does one thing well"
* Grady Booch - "Clean code is simple and direct. Clean code reads like well-written prose..."
* Ward Cunningham - "You know you are working on clean code when each routine you read turns out to be pretty much what you expected"

## The Rules of Functions

1. They should be small
2. They should be smaller than that

* A small function is a bit of code from which you can't extract smaller
functionality
* not large enough to hold nested structures (indent level <= 2 )
* three arguments is a good number
* if the arguments go together, maybe they belong to some object that groups them
* don't pass booleans—instead decompose function into two functions that represent each branch
* avoid switch statements (use polymorphism instead—open/closed principle)
* a function that returns void must have a side effect, or its pointless
* a function that returns a value must not have a side effect, by convention
* prefer exceptions to returning error codes (Java thing)
* don't repeat yourself
* structured programming - Edsger Dijkstra

## Also in this series

* [Lesson 1 - Clean Code](/uncle-bob-lesson-1/)
* [Lesson 2 - Comments](/uncle-bob-lesson-2/)
* [Lesson 3 - Professionalism](/uncle-bob-lesson-3/)
* [Lesson 4 - Test Driven Development](/uncle-bob-lesson-4/)
* [Lesson 5 - Good Software Architecture](/uncle-bob-lesson-5/)
* [Lesson 6 - Production vs. Development](/uncle-bob-lesson-6/)
