---
layout: post
title: Your OO Accessors Are Destroying Everything
categories:
tags:
stopwords:
last_modified:
original_url:
---

Many people treat object orientation as data structures with behavior, and because of that, they build a data structure and then put all sorts of scaffolding around it. Often, that scaffolding just obscures the path to get to the data structure, which means you are doing a lot of needless work for negative benefit.

Objects are not about "accessors", the name given to methods that get at internal details. Yet, the idea of "accessors" is elevated to the principal virtue of objects, eclipsing all of the other gains one could reap. OO programming becomes a procedure for listing accessors and giving them names. That's why you have trouble programming with objects.

Now, since it's so easy to create a list of accessors, it's easy to define discrete objects. So people come up with a bunch of objects. It looks productive because there's a lot of code produced. But that's a problem. There's thousands of lines of code and almost none of it is useful.

Why isn't it useful? People get this far without ever thinking about the problem. Are those the right objects for the problem? Probably not, but somehow more code will tie them together in some way that the entire team tolerates but makes maintenance and evolution very tough.

I like [Robert Martin's definition of good code](/uncle-bob-lesson-5/): The measure of design quality is the effort needed to meet the needs of the customer. If that shrinks with time, the design is good. And, that comes from forethought.

## Do you have the right objects?

Object-oriented design is tough. What objects to you really need? Forget about how they are going to do their work. Which things need to coordinate with each other to get the job done? Do these things need to be tangible objects in meatspace?

For example, many OO examples like to think about a Car. Those do that because people know what cars are and how its components work with each other in the real world. But, do you care if something is a Car? Do you care how the car operates? Or, do you just need something that transports people or cargo from one place to another? It depends on what you are doing.

Or, consider an example I found in *Head Start Java*. They wanted to show off decorators, so they were using cups of coffee to illustrate that. Each cup of coffee has a price. But, if you add cream to it, you decorate that object to modify its price. It shows the technology just fine, but it's the wrong design.

Why is a cup of coffee at the center of that design? The problem doesn't care what it is. Your favorite coffee place probably sells pastries or sandwiches, bottles of water, and many other things. They might sell WiFi codes.

What does the problem really want to know? The goal of this problem is to collect the right amount of money, and maybe track some inventory. It doesn't care how you combine or group items. Given a bag of items, how much money should the customer transfer to the seller? So, the natural objects are a bag of items, and items with a price. We don't even care what those items are. We don't need to model coffee at all. We don't need to model customers. That is, the physicality of the objects aren't the things the problem cares about.

## "It's about messages, stupid"

Alan Kay, way back in the 60s, was thinking about how autonomous systems could interoperate. Those things might be the micro-locality, such as objects in the same system (and in Smalltalk, everything was in the same system), but it might be two different computers in the same network. It might be two networks interconnecting with each other. The same ideas that work at the macro scale would work at the micro scale, especially since some of these objects might move around the graph. Consider, for instance, an object that handled internal data now doing the same thing with a microservice, for example.

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/AnrlSqtpOkw?start=2585" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

Objects should know what they can do, and they should have an interface for that. We shouldn't have to string together lots of "low level" object manipulations to do something.

As such, the highest touch points for the person interacting with any object is its interface.

But the interface isn't just a fancy way to access a bag of stupid values. We have data structures that do that just fine. Array, dictionaries, bags, sets, whatever. Putting thin interfaces in front of those things adds no value. It's more code to do what we could already do with the values.