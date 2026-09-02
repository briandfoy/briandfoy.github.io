---
layout: post
title: Use identity instead of logic in object-oriented programming
categories:
tags:
stopwords:
last_modified:
original_url:
---

I've often been dissatisfied with object methods in which I have to do a lot of tangled work to discover what I have and what I'm going to allow to happen.

And, although I said "instead of logic" in the title, this is really the waterbed theory of complexity. When you push it down in one place, it shows up in another. However, if I can push it into something that I don't care about and don't have to look at, I don't really care.

<!--more-->

Let me create a collection of objects that are homologues of each other. Instead of creating some contrived, artificial example that tries to model some complex, real-world situation in a way that no real-world application would ever think about it, lets think about what we actually need.

I find I typically use this technique when I have a bag of objects such that each behaves the same ("parametric polymorphism") rather than a collection of arbitrary objects that have the same method names ("ad hoc polymorphism").

	foreach my $animal ( @animals ) {
		show $animal->print;  # footprint maybe?
		}

	foreach my $item (@data) {
		$item->print;         # similar operation?
		}


This is a bit different from generics in that there is no type erasure, even though they might descend from a shared implementation (a base class). I don't find the categorization that useful, though, and prefer not to classify it.

Imagine a pond surrounded by woods, and the life we might manage in that area:

* black bear
* beaver
* kingfisher
* smallmouth bass
* birch tree

As a wildlife manager, I have some basic tasks that don't depend on the particulars of each animal:

* identify them
* tag them
* sex them
* age them
* weigh them
* count them
* track them

Now, here's the key that many people miss when they design objects and collections of objects. I don't need to minutely model what each animal is themselves and everything that they do or have. For example, for those tasks, I don't care that the kingfisher has wings, or that the trees don't have legs. What do I need?

* general identity (bear or birch)?
* particular identity ("Bob the Bear")
* demographics (inherent traits)
* assignments (tags)

Let's imagine that I sit in the woods and write down everything I see. This is an actual job, and because this is an actual job, I'm not a sea otter biologist. I wanted to be a sea otter biologist until I found out everyone wants to be one, hence no one pays decently for it, and the waiting list is years long.
