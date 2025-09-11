---
layout: post
title: Everything is not miscellaneous
categories: books
tags:
stopwords:
last_modified:
original_url:
---

A friend suggested I read *Everything is Miscellaneous* after I was telling him my efforts to clean up the metadata in my music collection. Even aside from the idea of a genre, what year was this music track published? Is what I have the single, the album version, the radio music, a bootleg, a live track, or something else? I like to find all the covers of songs, so I can

<!--more-->

So, let's summarize the book. It's really easy because most of the text is the sort fo fluff that has taken over these sorts of non-fiction books where the author is a major part of the story. It's entertaining when Hunter Thompson does it, but no one is Hunter Thompson, so stop it.

There are different ways to organize objects and information about objects. In the physical world, objects take up space and thus exclude other objects from that space (and give me a moment to say the same about the "digital" world), The author calls that the *First Order*. After that, a large enough collection benefits from a way to find that part of physical space that holds the object I want. That's *Second Order*, and might be a card catalog, for example. Beyond that, there's an exciting new *Third Order* that the digital world gives us where we "tag" things.

This book was published in 2007, so likely written a year or two earlier. For comparison, Gmail launched in April 2004 with the idea that there should be no folders because search makes that useless. Later, in 2010, Gmail had to essentially add folders through a kludge with [nested labels](https://gmail.googleblog.com/2010/04/new-in-labs-nested-labels-and-message.html). It's easy to see why this had to happen:

* searching all of your email for a common term returns too many results
* people have one or two major concepts of an email, such as "Duck Project" and "Mallard", and don't want all emails that match "duck", "project", or "mallard"
* tags are folders

Let's go back to the difference between physical and digital objects. Each takes up space somehow. Each needs some way to look up the space it takes. Each of those "Second  Order" organizations can list as many ways as they like to lead the searcher to that address. There is really no third order, digital-only technique. Tagging objects is just another card catalog.

Librarians already know this. There can be a card catalog for the subject, author, or title. These fulfill different starting points in increasing order of specificity:

* I don't know what object I want, but I know its subject
* I know the author and want to find their books
* I know the title I want

The mistake that people make about "digital" is that it is something new. It's not. We can do all of these things in physical space with 3x5 cards. It would be a lot of work and require a lot of people and many, many index cards, but you can do it. It would take up a lot of space.

All of that space disappears inside the computer because the representation of an index card doesn't exist until I ask for it, and it doesn't even really exist then. The physical dimensions disappear.

In the computer world, each time someone tags an object, the virtual card catalogs can immediately update. Instead of a couple of tags, we can have two hundred, two thousand, or two million.

This is especially advantageous when the tags are automatic, which might allow many more tags than we'd ever imagine. Consider an image recognition step that can recognize a bridge over a river next to a mountain. The cataloging system can remember all though things and allow for things like vector databases that remember multiple attributes and we can look for all the images with bridges and mountains, even if there is no river.

This is a different sort of searching though, and it's mildly interesting. Given even small to moderate scale, looking for an image with particular elements will return too many results. Again, we're back at the Gmail problem. With too many objects, random searching will fail. For example, choose your favorite photo and imagine you tag it with everything in it. Now, how many of those tags do you have to specify to find that photo among all the others that have the same tags? And how many hours are you going to devote to adding enough tags that there is some unique way to find it?

But, we have another way, and the book goes off the rails about this when the author claims that a digital object cannot be in more than one folder. Of course it can. That some systems don't do it is not a statement of possibility. In Unix, for instance, there's the hard link, named "hard" because it's literally just another name for a same data on disk. You can have as many of these as you like.

But let's back up a moment. A folder isn't really a folder in the sense of a file cabinet, but rather a skeuomorphic thing that tries to represent a familiar concept in meatspace. Files don't exist in folders. Instead, pointers to data exist in "folders", and there's not a requirement that there can't be multiple pointers to the same data. The computer does not care. The author misunderstands this and uses his misunderstanding to make his case for tagging. Folders are just tags that have a list of objects with that tag, just like Gmail had to admit.

This is a completely different topic than regular people being confused about the idea of folders and labels. "Folders" are typically displayed with icons that look like physical file folders in the graphical UI, and people navigate through them. Each folder can have more folders, and this roughly creates a tree on an organization that the person chooses based on what is important to them. See [johnnydecimal](https://johnnydecimal.com) for example.

But, it's not really tree; it's more like a graph because a folder can contain links to folders into other trees outside of it, and even above it. Consider for example, I have a folder in my macOS Desktop named "Good Things", under which I have another folder named "mac Things", and in that folder I put a link to Desktop again. I follow that interior "Desktop" and see the folder "Good Things" again, and click through the folders infinitely without ever getting to the end.

## Some random notes

* The Dewey Decimal system isn't bad because it's Western. The particular categories might not reflect social needs today, but the categories aren't the system.
* Any classification system, including tags, will have social problems. Some group is not going to like it. There is no balanced tree that will satisfy the world and the diversity of values.
* Some of the confusion is that an assigned number, no matter the system, corresponds to physical space. That's one way to do it, but imagine completely different system now where every object is easily discovered by RFID and are randomly shelved. When that book is requested, the RFID system locates it and presents it. Consider the difference in grocery stores before and after [Piggly Wiggly let shoppers collect their own groceries](https://www.smithsonianmag.com/smart-news/bizarre-story-piggly-wiggly-first-self-service-grocery-store-180964708/) directly off the shelves. In the before times, the shopper didn't need to know how to find the item, and in the after times, they did.
