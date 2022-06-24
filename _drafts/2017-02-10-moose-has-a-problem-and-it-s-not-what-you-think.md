---
layout: post
title: Moose has a problem, and it's not what you think
categories: programming
tags: perl moose object-orientation
stopwords:
last_modified:
original_url:
---

Perl has a third-party object framework, Moose, that many people love. But, it's a dumpster fire that's not fit for purpose. Everyone knows it but many people still push it. And, it's a dumpster fire for a reason other than what you think.

<!--more-->

It's basic idea is that it allows introspection on objects in Perl, and uses that to obviate some warts, including:

* any subroutine in a package is a method because Perl doesn't care
	* including anything you imported
	* and all your fake private-by-convention methods
* too much boilerplate
* lack of "strong typing"
* incorrect code

It's many deficiencies are easily apparent and not the reason I'll discuss in a moment:

* It's big, complicated, and inconsistent, which is why there are so many variants and variants and extensions of it.
* No one agrees on what it should do, which it why there are so many variants and extensions of it.
* It drastically exceeds most people's expectations of capturing and stabilizing third-party dependencies.
* It's really, really slow to get going. Even the Moose creators say they are not targeting quick, one-shot execution but long-running or persistent applications.
* It's slow if you forget some boilerplate to tell it to not be slow, but reduced boilerplate was one of the goals.
* It's not for small things, like a well-defined CPAN module for a low-level feature.
* Toy programs make it look like Moose is handy, but big programs are much more complicated.
* It's tool, an "attribute", is used for everything, including things that are not attributes.
* It can't naturally handle cross-attribute constraints, which is always where frameworks give up.

My advice has been, and been validated by various Moose zealots at various times and intoxication levels, is that Moose is an application level tool, not a re-usable component level tool. In big Application land where Moose only appears in the application-specific code, many of the complaints are somewhat mitigated.

But that's all the easy stuff that you can find

## Get on with it

But, I'm still not to my complaint. Here it is. Are you ready? It's not one that anyone expresses. I don't push it except when asked. It's a minority view, at least in the people who put their views out there for people to consume. Okay, ready?

> Good tools should promote good programming, but Moose doesn't do that.

Doing the same architecturally-stupid thing with different syntax is still the same architecturally-stupid thing. New syntax is doesn't change programmer's needs or desires, and it doesn't change how people think. They have the same goal and a slightly different path.

Moose, however, gives you fewer options to deal with your complexity but it doesn't change anyone's needs or desires. They design the same things they did previously even if it looks different.

I haven't seen a single, effective use of Moose. Ever. That doesn't mean there aren't people putting it to good use, even if that is limited to Stevan Little, Chris Prather, and Dave Rolsky. I rarely get to work with codebases that are generally good, and my statement isn't based on a broad survey of all Moose code bases. Having admitted that, various friends have said various things about what they deal with at work, but again, that's very limited.

But, this isn't a criticism of Moose. Most of the programmers out there don't make effective designs *with any tools*, so it's folly to think that an extra framework would change that. I'll discuss this in a moment because it's often not their fault.

People weren't writing good classes and objects before, but syntax wasn't their problem. And, I'm thinking about very basic things that are easy to do without Moose:

* checking inputs
* decoupled implementations
* separation of concerns
* interfaces that cater to common uses
* components are easily reused in a different context

More often than not, I see components which should be slightly more general but has hard-coded parts that matter to only one use of it. I should be able to use the meaty components in a command-line tool or in a web application. This is rarely true.

What happens when you use Moose? You still have all of those listed problems, several more dependencies, and, AND!, you now have more fewer and more narrow affordances to deal with them.

### Every problem a nail

Using Moose to the problem adds a lot more code, though. Your only affordance is `has`, which you use to define attributes of a object. But not everything you need is an attribute.

You define attributes, and Moose uses those to figure out what should be arguments to the constructor it provides for you. But, why are you setting attributes directly from a constructor? People who complain about Perl's object system typically don't like that objects are most often hashes. But, here we are again, only called attributes, which we are setting directly. Topologically, this is the same idea.

Now there is one benefit here, which is a complaint that people most often have with Perl's loosey-goosey hash reference objects: you can treat them as any other hash by adding and deleting them. Moose attributes can't do that. Well, there is a way to finalize a class, but it doesn't appear in the example in the Moose module.

If you need to do something more complex in the constructor, Moose wants you to go through `BUILD` or `BUILDARGS` to massage things into a suitable form. That's a bit of an admission that Moose doesn't solve the problem.

Consider my ISBN module. Underneath I store the ISBN as the group, publisher, number, and checksum, but none of those are arguments to the constructor, and I don't keep around the arguments. How much work am I actually saving when I have to redo all the work I'd normally do, but I have to deal with extra complexity to get there? Raku has the same problem, by the way. Moose is very opinionated about how you *construct* objects, and that's most of its idea.

But that's the least interesting place to have an opinion. It's also the most annoying. It tries to collapse all problems into one way of doing things. Part of Perl's true appeal is that it is very flexible: anything can be a constructor and the arguments are a free form list that you can interpret in the best way that solves your problem.


### Consider private attributes

Consider the case of attributes that you want to be private. Many times I have objects with internal state that is not interesting or not stable enough to expose in the interface. This is not uncommon when you break the bad habit of treating your objects as hashes (which is different than using hashes to implement them).

One complaint about Perl's loosey-goosey design is that a conventional object is inspectable and mutable. Technically, it's encapsulat-ish, but not encapsulated. Larry Wall has said things like "Perl prefers you to stay out of its living room because it's polite, not because it has a shotgun". Don't look behind the object's curtain.

That would work out well in small cases,




Some people don't like that because it offends their sense of purity. That's not a dig: the way to good code is the conscientiousness of the programmer who roots out things that offend them. Typically this takes the form of deletion; you remove things and the code is tighter. You bite the bullet to do a little extra work to do it the "right" way, whatever you think that is.

The person using Perl may have developed their sense of "right" in some other domain, so Perl's loosey-goosey approach to things doesn't sit well with them. They would like a little bit more bondage and discipline that they may be used to from their previous experiences. That's a problem in any language. People try to do that with any language, so it's not surprising they'd do it with Perl. As Larry Wall once said "You can write assembly in any language".


Now, what if you need that private method to build the object? Moose hides the constructor from you, and its constructor is supposed to figure out what arguments it will accept from the attributes you define. Here's another big problem: the input to create an object is often not the raw input to the constructor. But, with Moose, all the raw input become attributes. You can get around this through various `BUILD` and `BUILDARGS` shenanigans, but if you are going that far, why are you relying on Moose to handle the constructor? You are already doing more work than you would have before when you didn't have so many dependencies.

So, you use attributes, and you store in those attributes the things that you want to remember about the object. Perhaps one of those things is a date. Many people reach for DateTime for anything that might be a date, even if their YYYY-MM-DD data doesn't need leap second support. ORMs such DBIx::Class love doing this to you. But, now that's an attribute and the DateTime object is part of the interface and the user has to call DateTime methods to get what they actually want. But, you can change the values in that object because it's mutable. Even if you need it internally, it should have never been exposed to the user.

To be fair, Moose doesn't require you to use only attributes. But, now those extra subroutines are built around a set of ill-considered attributes. You are already on shaky architecture ground.

To handle these complexities and still use Moose, you end up working around Moose. And, I assert that most interesting problems are going to be complex enough that you can't do it with attributes. You can see the problem in the explosion of `MooseX` modules that attempt to make up for the deficiencies in the idea.

As an aside, this is also the reason why things such as Params::Validate don't work: many situations are going to have cross-parameter constraints. Consider asking the user for a state or province along with a country. If you are in the US, then there's a list of valid states, and if you are in Canada, there is a different list of valid provinces. These lists do not overlap. Validating those simultaneously is not possible with a framework that considers parameters in isolation. Which one do you validate first, and then where's the error? The error is that the country and state are mismatched, but how do you make that one error when you can only inspect individual parameters.

Extend that to changing the value of an attribute. If that value constrains the value of another attribute, how do you handle that? First, why do you allow the user to change attributes? Why haven't you provided an interface that handles all of this? Because Moose hypnotizes you into defining attributes and using those as the primary interface.

And once you realize a few simple things, you see that Moose is a house of cards.

## A bit of  empathy

None of this is not meant to impugne the quality of the programmer. I have the benefit of thinking long and hard about the problems I'm giving. Many programmers get to type in code only between the endless, thoughtlessly scheduled death march of meetings they endure. Indeed, that's part of my value: I don't have to go to the meetings.

But, sometimes it is the quality of the programmer, who is often self-taught (Computer Science is about programming as much as Physics is about engineering), learns on the job (or not), and can often coast for quite a long time before anyone fires them. Think about the teams you've been on: I bet you knew who needed to be fired, your manager agreed, and yet, there they are taking up a headcount because the next guy might be worse.

But there's another force at work. People base their judgment of the tool on their estimation of the author instead of the technical merits. It's a human thing to do, and you have to realize that humans will do that. It's a shortcut. We can't all ourselves deeply evaluate everything we come across. Instead, we re-use the work of others. In movie reviews, I know which reviewers think like me and I know which ones don't.

Damian Conway is a brilliant programmer and a very nice and generous person, and people know that. But, most of his advice in *Perl Best Practices* is bad advice. People mostly realize that now. The problem is that he didn't necessarily set out to create the rules. He gave some examples of rules, but early on in the book had told people to use these as a basis for their own. He told his readers to think about what's important to them in their work and make their own rules. Almost no one remembers that part, especially when they are reading only parts of the book instead of reading the book from beginning to end.

From my experience, I knew people were going to treat his book as gospel, and *Perl Best Practices* morphed into `Perl::Critic` and hard and fast rules divorced from context. That's the human tendency. A suggestion from a well-respected person is treated as much more than a suggestion. The problem is often that well-respected people sometimes don't see them in a position of authority, so don't anticipate the accidental authority people assign to them. It's even worse when they write a book, which already carries some authority simply by being printed on paper before we even know what's on the inside.

chromatic is a good programmer, but *Modern Perl* is not a good prescription for making anything that much better. It's a decent book, but it's implicitly targeted at the people who already know what they are doing (check out that casual Liskov Substitution Principle name drop). It's generally good advice, but people again take it as holy scripture. I know at least one excellent programmer was passed over for a job because the employer was blindly looking for a "Modern Perl programmer", not even understanding what that was.

The Perl rock stars who are interested in and playing with ideas through Moose are generally good programmers, but even good programmers don't know the long term consequences of what they are doing. They are experimenting, trying ideas, and extending boundaries. But, as open source people are wont to do, they do this in public before the idea is ready for the people who don't understand what it offers or won't take the time to evaluate it. Again, not everyone has the time to deeply evaluate everything, so they use the people they respect as a stand-in for their due diligence. That's just how it is and how it always has been.

People with kids get it: you can't do everything you want to do as an adult in front of small kids who don't understand what you are doing and how you are making it safe. Good leaders tend to get it: they can't say everything they think or express their frustrations in front of their subordinates because that engenders a culture of gossip and complaining and malcontent.

<iframe width="560" height="315" src="https://www.youtube.com/embed/dKbdE5LOGNQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

The vocal programmers, the ones writing on the internet, getting cool points for shiny and new, tend to think information should be free and their should be no secrets. That's not most programmers, but most programmers aren't part of the conversation even though some of them are aware of what's out there. It's particularly a young person's game, before they've had the chance to be in a significant leadership position. They don't have the scars from reckless information sharing yet.

## Getting it right

Typically, you can't do something right until you tried it a few times. You might accidentally coded a good module or library, but unless you know why its good, you may not accidentally do that again. The thing that made it good in that context might not be the thing that makes it good in the next context.

But, a framework like Moose is essentially contextless because the developers do not know what you are going to do with it. It tries to distill the problem down to the constraints it can manage and ignore the rest as if they don't matter.

<hr />

Tadeusz Sośnierz gave a short talk at PerlCon in Rīga in 2019, [How Moose made me a bad OO programmer](https://perlcon.eu/talk/101):

<iframe width="560" height="315" src="https://www.youtube.com/embed/783CBT1r1DU" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
