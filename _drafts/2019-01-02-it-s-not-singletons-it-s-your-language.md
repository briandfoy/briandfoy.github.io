---
layout: post
title: It's not Singletons, it's your language
categories:
tags: programming singletons
stopwords:
last_modified:
original_url:
---

Every so often I run across some programmer who says that Singleton objects are bad, and I then go reading to see what people are saying about Singletons. I'm struck how often their complaints are limitations of their language and misapplication of object-orientation principles.

<!--more-->

The Singleton comes from *Object-Oriented Design Patterns**, a Smalltalk book (later ported to C++) that described how you can arrange and connect objects to solve various organizational problems. Think about this as you read people's complaints. This book was originally written for one language then lightly edited to use a completely different language with different foundational ideas.

## Object-Orientation

Smalltalk, invented in the 1970s at Xerox Park, is largely attributed to its main evangelist, Alan Kay ([The Early History Of Smalltalk](http://worrydream.com/EarlyHistoryOfSmalltalk/). He [accidentally coined "object-oriented](https://www.quora.com/What-did-Alan-Kay-mean-by-I-made-up-the-term-object-oriented-and-I-can-tell-you-I-did-not-have-C++-in-mind), although he later says that it wasn't a good description of what he was actually doing. His idea, loosely, was that things ("objects") would talk to each other by sending and receiving messages. Different receivers, completely unrelated to each other, could handle the same messages. You don't care if you have the right Type, and you didn't need to know all the Types and bindings and relationships ahead of time. This made the syntax of Smalltalk very simple.

C++, invented in the late 1970s and early 1980s, as "C with Objects" and later its final name, was a different beast. You can write C in a way that has the concept of classes and objects. That's the way C++ originally worked—it transpiled code to the equivalent C. But C doesn't have the same ideas, designs, or goals as Smalltalk. It doesn't think in terms of messages, and it really wants to know everything ahead of time (or you have to play weird games to get around that).

## Design Patterns

The idea of a "design pattern" comes out of architecture (as in buildings and whatnot). Christopher Alexander wanted to create a vocabulary for common concepts that architects could use to maintain consistency throughout a plan. These patterns would help you decide what you needed to do.

The [Design Patterns: Elements of Reusable Object-Oriented Software](https://amzn.to/3uljGkD) uses the same term, but adds another wrinkle. The authors include sample implementations. We all know how that is going to work out. Once you show concrete code, people think that the code is the pattern.

The two are not the same, as Mark Jason Dominus explains it in his presentation ["Design Patterns" Aren't](https://perl.plover.com/yak/design/).

## The Singleton

The [Singleton Pattern](https://www.oodesign.com/singleton-pattern.html) has too stated intents:

* Ensure that only one instance of a class is created.
* Provide a global point of access to the object.

But, these intents are not the actual intents. The real intent, as expressed in the rest of the description of the idea, is that a program can share something without having to coordinate with anything else that also wants to share the thing. The stated intents are not the revealed intents

The "one instance" leads astray the literal-minded. I don't care if there's a single instance, two instances, or some other number. In that regard, "Singleton" is a bad name for a pattern. It's prematurely specifying the number of things to share, and excluding the concept that we might want to share more than one thing.

Some people also focus on the "global point of access" to mean it's a global variable with global state. Well, every class name you create is a global *point* of access. But it doesn't have to be global either. Parts of the program that don't need it don't even need to know about it.

These misapprehensions arise because the software "design patterns" are received as code, and the C++ examples come from a language that actively gets in your way because it already has opinions about how you should do things. The online version uses Java:

{% highlight c++ %}
class Singleton {
	private static Singleton instance;

	private Singleton() {
		...
	}

	public static synchronized Singleton getInstance(){

		if (instance == null)
			instance = new Singleton();

		return instance;
	}

	...

	public void doSomething()
	{
		...
	}
}
{% endhighlight %}

The code example has to work hard to avoid having a constructor. There's a private inner class `Singleton` with the same name as the public class. That's mostly because most examples are generic, and this is about as generic as you can get. You can't call `new` on the public class because you'd get a different object. And, not calling `new` calls out that there's something funny about this arrangement.

Consider the same thing in Perl, which lets you do practically anything you want. You don't keep creating objects. You create it once and reuse it, but since no method name is special in Perl, it doesn't matter that you use `new`. Call `new` as many times as you like without creating more objects. The programmer doesn't even have to know they are using a Singleton (and that's the point!)

{% highlight perl %}
package Singleton {
	my $singleton;

	sub new {
		return $singleton if defined $singleton;
		$singleton = ...
	    }
	}
{% endhighlight %}

With Perl v5.10 or later

package Singleton {
	sub new {
		state $singleton = ...
		return $singleton;
	    }
	}

Some of the complaints about this form are that the Singleton class doesn't have a proper constructor or destructor. I think these are language details; people complain because their first language set their expectations of what should exist everywhere else.

### Lifecycle

Another complaint is that the lifetime of a Singleton is effectively from its first use to the end of the application. That stored instance, in the way it's presented, essentially sticks around forever. That's another implementation detail, though; when the programmer asks for the instance, you are allowed to do anything you like. You could update the shared object, destroy it and create another, or something else.

But why does the programmer ever have to see the singleton or get to use it directly? At the application level, you use a class that more directly connects to the actions the application wants to do, and that class then translates the calls to the shared resource. For example, I print to a socket, but I don't manage the details of the socket in the application layer.

The `SharedThingy` class can clear out the underlying thingy so the next time you ask for it, you get a new one:

{% highlight perl %}
package Singleton {
	use experimental qw(signatures);

	my $singleton;

	sub new ( $class, @args ) {
		return $singleton if defined $singleton;
		$singleton = ...
	    }

	sub clear ( $self ) { $singleton = undef }
	}

sub SharedThingy {
	use experimental qw(signatures);
	my $active = 0;
	sub new ( $class ) {
		$active++;
		my $self = bless { singleton = Singleton->new }, $class;
		}

	sub DESTROY ( $self ) {
		$active--;
		$self->singleton->clear if $active == 0;
		}
	}
{% endhighlight %}

The `SharedThingy` has the lifecycle that people expect because its object contains the singleton, but also knows when it is created and when it goes out of scope.

This is, by the way, what some database modules do. They keep a single connection, ping it, and reconnect when necessary, all while hiding that from the application.

If you are directly exposing the shared resource to the application, you are probably doing it wrong anyway. Mixing high and low is a bad idea, guaranteeing tears and misfortune.

### Testing

Testability is another concern, and another reason not to mix the high and the low details. At some point, you have to remove or limit access to the shared resource during testing. If you can't do that easily, your design is wrong.

One interesting example I saw involved charging credit cards and accidentally charging people more than once. First, why do you test against the production merchant systems? Most of those will have a sandbox for testing. There's no requirement that the low-level implementation choose one system over the other, and a design that prevents that selection is a bad one. Consider, for example, what happens when you change merchant accounts. Does your code suddenly need widespread and invasive changes?

{% highlight perl %}
sub SharedThingy {
	use experimental qw(signatures);
	my $active = 0;
	my $singleton_class = ... ? 'ProdSingleton' : 'TestSingleton';
	sub new ( $class ) {
		$active++;
		bless { singleton = $singleton_class->new }, $class;
		}

	sub DESTROY ( $self ) {
		$active--;
		$self->singleton->clear if $active == 0;
		}
	}
{% endhighlight %}

Another complaint about testability is that multiple tests, running in parallel (or even the same test suite run simultaneously), would affect the state of the shared resource. Sure. But so is production.

There might be examples where you can't do this, but I haven't seen anyone present a concrete version.

### Multithreading

Some people note that if you don't have thread-safe code in your implementation of the Singleton, then the Singleton is not thread-safe. It's a weak complaint that's put to bed in [C++ and the Perils of Double-Checked Locking](https://www.aristeia.com/Papers/DDJ_Jul_Aug_2004_revised.pdf). You have to do this to control access to any shared thing:

{% highlight c++ %}
Singleton* Singleton::instance() {
	if (pInstance == 0) {  // 1st test
		Lock lock;
		if (pInstance == 0) { // 2nd test
			pInstance = new Singleton;
		}
	}
	return pInstance;
}
{% endhighlight %}

### Inappropriate use

A final criticism is that people use the Singleton pattern incorrectly or in contexts where it's inappropriate. Sure, but people do all sorts of stupid things. That's not the fault of the idea, though.

## Hall of Shame

* [Singleton Design Pattern in Automated Testing](https://www.automatetheplanet.com/singleton-design-pattern/)
* [6 Reasons Why You Should Avoid Singletons | David Tanzer - Coach Consultant Trainer](https://www.davidtanzer.net/david%27s%20blog/2016/03/14/6-reasons-why-you-should-avoid-singletons.html)

## Further reading

* [Singletons The Safe Way. The Singleton pattern is a useful… | by Matt Carroll | Medium](https://mattcarroll.medium.com/singletons-the-safe-way-9d1e019220fc)
* [design patterns - So Singletons are bad, then what? - Software Engineering Stack Exchange](https://softwareengineering.stackexchange.com/questions/40373/so-singletons-are-bad-then-what)
* [Singleton Considerations | Johannes Rudolph's Blog](https://jorudolph.wordpress.com/2009/11/22/singleton-considerations/)
