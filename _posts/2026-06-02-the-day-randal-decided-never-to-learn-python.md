---
layout: post
status: _post
title: The Day [Randal] Decided Never to Learn Python
categories: programming
tags: python perl randal-schwartz
stopwords:
last_modified:
original_url: https://medium.com/@realmerlyn/the-day-i-decided-never-to-learn-python-2c59d1a1edc5
---

*I left this comment on [Randal Schwartz's Medium](https://medium.com/@realmerlyn/the-day-i-decided-never-to-learn-python-2c59d1a1edc5) post*

Randal taught me OO by forcing me to use Smalltalk, although once learned, a job he said he could do in 20 minutes since there are only 5 syntatic elements, everything made sense. And, after that, it was a bit depressing looking at the fake OO languages, such as Java and Python, that had painted themselves into corners. For example, Python's foundational idea about whitespace forecloses so many possibilities. While teaching Perl classes for Randal, I'd make that provocative statement, mostly to goad the Java people, and when someone took the bait, I'd ask them what type of object `if` was. Yes, there are objects in your language; even C can do that, but most of your language is not objects. It's just Algol with extra features (or in Python's case, removed statement terminators, a little hand grenade left over from B and abc).

<!--more-->

This isn't really the fault of the languages themselves so much as the weird ideas that the practitioners instill and pass on. This happens to everything that involves people, but more so with languages that try to enforce an ethos such as "Pythonicity," where the language allows something, but you shouldn't use it for "reasons". You can only really have that sort of language when the solution to your problem is naturally expressed by the syntax available to you. In Guido's case, he chose the syntax, whereas we merely have to live with it.

When I work on Python stuff, I think the full-time Python people are a bit taken aback that OO does not need that much work. But then, many people (in any language) aren't learning multiple languages or paradigms, so they have no yardstick for how much extra work they might be doing. I don't hate Python as much as Randal does, and Python does have a lot of things I like, but still, you see code like Randal shows in this post and you wonder why God hates you so much. Find Brian Will's videos on YouTube and rejoice that someone gets it. He hates OO, but he understands it much better than most people who love OO.

The point of OO is not to have bags of data associated with some class, then kludge them together and force them to cooperate in the same program. The trick is to find the right model that allows things to happen simply, and that future problems almost solve themselves. Language purity is not the goal. Well, it shouldn't be the goal, but I have worked with plenty of people who don't care about solutions as long as they get paid to do the language they like. Well, that was the case when you could be fired in the morning and hired in the afternoon. Now we'll see.

For example, there is an example in Head First Java shows decorators, where a cup of coffee has a price. But, a cup of coffee with cream has an additional price, so you decorate the coffee object. The example goes with many more levels of decoration. It's absurd because no one treats a coffee order like that. You take your whatever to the cashier and list everything you have and they just add it all up. Coffee with cream is the two things (coffee, cream). We think of add-ons as separate items in the addition. So, just throw in a cream object in the list instead of creating a new fancy, undocumented object. No decorators, or decorators on top of decorators, or decorators on top of decorators on top of decorators.

I'll forget all the details, but there was this state government contract that Randal and I worked on, and he had this idea that Self would be a really good tool for the problem. But, we had to deploy Perl, so he picked Class::Prototyped, whose name is a bit ironic since it's doing Self-like classless object orientation. Instead of making weird classes with lots of knobs and dials, each object is essentially its own type and can add or replace behavior that affects only it. No type tests, no branches, no nothing extra.

As with any project, we'd hit some thorny problem, but the design Randal had worked out handled it naturally to the point we were surprised. I don't think we ever had to change an initial design decision. That's how you know you chose the right mental model. We might have thought about a problem for a day, and I remember Randal getting excited a few times, saying something like "no, we just do this, then everything works". And, we would do that thing, and all sorts of downstream problems solved themselves. Most of that was simply from not having that much experience with the classless idea. Then, looking back on it, there was nothing we wanted to do differently (and that's very unusual).

As a side note, some people disparage Perl's nuts-and-bolts blessed reference objects, but guess from where Larry stole that! The difference is that Perl isn't coy about its warts and practicality, but also celebrates diversity of solutions.
