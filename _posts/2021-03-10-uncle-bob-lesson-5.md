---
layout: post
title: Uncle Bob, Lesson 5
categories: programming object-orientation
tags: uncle-bob
stopwords: GUIs MVC Mikkjel Reenskaug Trygve
last_modified:
original_url:
---

*"Uncle Bob" is Robert Martin of [CleanCoder](http://cleancoder.com/products). You
may have heard of the Agile Alliance, Extreme Programming, and the SOLID
principles. That's "Uncle Bob".*

<!--more-->

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/sn0aFEMVTpA" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Architecture

* It is a living, breathing thing that responds to the changes in the system.
* The rules of architecture are independent of every other variable—environment, language, etc

* There's magic when the software
    * It takes minimal work to maintain
    * It causes fewer problems
    * There's a reduction in effort to keep it working

* Goal is to minimize human resources necessary to build and maintain software systems

* The measure of design quality is the effort needed to meet the needs of the customer.
    * If that shrinks with time, the design is good

* Easiest way to go fast is to go well. It might not be very fast, but it's not going to slow down.

* People think that you can go fast by going dirty—quick and dirty. But, things slow to a crawl later.

* Software has two values
    * what it does (the requirements)
    * it's structure

## Clean Architecture

* Object-Oriented Software Engineering: A use case approach

* MVC was invented for small things, not application level things. - Trygve Mikkjel Heyerdahl Reenskaug invented it for GUIs.

* There's no such thing as an Object Relational Mapper.
    * An object has behavior, not data
    * A database has data, not behavior
    * An ORM actually just fills in data structures
    * The authors of frameworks do not have your best interests in mind—they have theirs

* Good architecture allows you to defer decisions as long as possible
    * or even not made at all
    * you don't need to select the database right away
    * or, maximizes the decisions not made

* Frameworks
    * are not made for your benefit—made for author's benefit
    * you have to tightly couple into someone else's decisions
    * you commit to them, not them to you
    * framework authors don't care if their framework is in the way
    * first month is easy, the years are hard
    * A good architect looks at how it benefits and hurts, then uncouples
    * Build v Buy decision. Even a free thing might cost more over building yourself

## Also in this series

* [Lesson 1 - Clean Code](/uncle-bob-lesson-1/)
* [Lesson 2 - Comments](/uncle-bob-lesson-2/)
* [Lesson 3 - Professionalism](/uncle-bob-lesson-3/)
* [Lesson 4 - Test Driven Development](/uncle-bob-lesson-4/)
* [Lesson 5 - Good Software Architecture](/uncle-bob-lesson-5/)
* [Lesson 6 - Production vs. Development](/uncle-bob-lesson-6/)
