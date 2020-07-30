---
layout: post
title: Why you have problems with object orientation
categories: perl smalltalk programming object-orientation
tags:
stopwords:
last_modified:
original_url:
---

Curtis 'Ovid' Poe is working on the [Cor Proposal](https://gist.github.com/Ovid/68b33259cb81c01f9a51612c7a294ede) to add new object syntax to Perl. There have been various efforts in the last decade, including [Moose](https://metacpan.org/pod/Moose) and the many variations of it. The syntax is nice enough, but syntax isn't the issue that's driving these frameworks. You don't make appropriate classes—that's the source of all of your problems.

Today, Ovid writes [Why Do We Want Immutable Objects?](https://ovid.github.io/articles/using-immutable-datetime-objects-with-dbixclass.html), in which he uses this example:

{% highlight perl %}
my $customer = Customer->new(
    name      => "Ovid",
    birthdate => DateTime->new( ... ),
);

if ( $customer->old_enough_to_drink_alcohol ) {
    my $date = $ovid->birthdate;
    ...
    # deep in the bowels of your code
    my $cutoff_date = $date->set( year => $last_year ); # oops!
    ...
}
{% endhighlight %}

The first problem is that `birthdate` takes a `DateTime` object. Not only is this an inappropriate, very heavy, very complicated object for the value it provides, but it now forces the `Customer` class to know about `DateTime`. He's not advocating this design; he's merely showing that people probably see this often.

The next problem is that there's a birthdate method that gives that object right back:

    my $date = $ovid->birthdate;

Another issue is that I have to construct a very heavy object when I probably don't use anything that requires it to be heavy. Consider this dump of a DateTime, which is 354 lines:

    % perl-MDateTime -MData::Dumper -le 'print Dumper(DateTime->now)'

The computation for drinking age is very simple. Your birthdate has to be before a certain date. Leapseconds and timezones, two of the big advantages of `DateTime`, don't come into it. This computation has the granularity of a day. You don't even care about Daylight Saving time. You need to know the year, month, and day. The answer changes exactly once every calendar day. Indeed, in YYYYMMDD, you simply compare the numbers.

Instead, I'd rather see this, where I give a known string the year, month, and day. I can construct that string however I like before I get there. The constructor can verify that how it decides to. It should have already verified that the `DateTime` made sense (like, wasn't the date the Magna Carta was signed, or past the current date), so that's not extra work:

{% highlight perl %}
my $customer = Customer->new(
    name      => "Ovid",
    birthdate => '1970-01-01',
);
{% endhighlight %}

Now, the next bit is slightly trickier. I can return that same string:

{% highlight perl %}
if ( $customer->old_enough_to_drink_alcohol ) {
    my $yyyymmdd = $customer->birthdate;
}
{% endhighlight %}

But, if I return a string and the consumer wants a `DateTime` object that I already have internally, I don't want to make them recreate that heavy object. I can give them the object they ask for:

{% highlight perl %}
if ( $customer->old_enough_to_drink_alcohol ) {
    my $yyyymmdd = $customer->birthdate_as_DateTime;
}
{% endhighlight %}

But, I wouldn't give them back the original `DateTime` object. I'd make a clone. If I expected to do this a lot from a single object, I'd also cache that clone. Ovid does mention `clone`, but at the consumer level. They should have never had the uncloned object at that point.

Better still, I'd probably have some lightweight object built around that string. When I use it like a string, I get the string, but I can also call methods on it. However, I make the interface exactly what I need it to be to get the answers I want. I store the date however I like and know how to convert it (on-the-fly and just in time) to other objects that I know I want. These lightweight classes are adapters from the Wild West world of third-party developers to what I need in the way that I need it. If their way changes, I handle that in the adapter, not the application code:

{% highlight perl %}
package Local::Birthday {
	sub new    (...) { ... }
	sub year   ()    { ... }
	sub month  ()    { ... }
	sub day    ()    { ... }
	sub of_age ()    { ... }

	# maybe cache these too
	sub yyyymmdd ()    { ... }
	sub to_DateTime () { DateTime->new(...) }
	sub to_TimePiece() { Time::Piece->new(...) }
	}
{% endhighlight %}

{% highlight perl %}
if ( $customer->old_enough_to_drink_alcohol ) {
    my $datetime = $customer->birthdate->to_DateTime;
}
{% endhighlight %}

## The actual problem

The problem at first appears to be deficiencies in Perl's object setup, which is why so many solutions target the syntax. It begs the question that different syntax can fix a problem that existing syntax can fix but hasn't.

More likely, and Ovid eventually gets to this, Object Relational Mappers create complicated "objects" from relational tables. They have no ideas about interface other than close-to-raw access to your database model. Many people provide this directly to their application code. They say they are using MVC (Model-View-Controller) architecture, but their Model and Controller are tightly-coupled and inseparable.

Essentially, these ORMs give you back a data structure that has no particularly interesting behavior or domain knowledge. It's just an object to do that, but it's not really oriented to objects. It's using a chainsaw to sand a bit of wood, and it's doing it because chainsaws are cool and sandpaper isn't.

Not only that, but inflating huge objects, each that may contain several other huge objects, for long results lists, is often a waste of time. Most consumers aren't going to use most of the objects you created. All those unused objects take up memory and time. When companies try to shave milliseconds off time to first byte, this is where many of them find the inefficiencies.

People's database designs tend to be poor as well—they might as well be magic. Your database server sits there mostly idle as your webservers fall over while your application code does work that database server could have done for you. Not only that, the database does it in a way that's available to anything that connects to it no matter the implementation language of the application.

But most people don't use the power their database server provides. They are essentially large spreadsheets, which is also why  people like to use spreadsheets for their databases.

If you are calling yourself a fullstack developer and you aren't creating views, triggers, and stored procedures, well, you are really just a frontend developer. But then, do you even make your own microchips, bro?

## How you can fix this

Syntax will not fix these problems for you. [Moose](https://metacpan.org/pod/Moose) hasn't, and one of Cor's fundamental ideas is that Moose is so complicated that it's impossible to be consistent (optional required parameters? readonly read-write accessors?). The feedback I get from people is that the additional layer of abstraction makes the situation much more complex and much worse. It's another layer of abstraction to dig through.

But, Perl's stock syntax is enough to fix this. Or, I should say, enough to never have this problem in the first place. Don't want someone to have access to part of your object? Don't expose it through the interface. You don't need special features to not do something.

Mostly, I think people don't want to type out accessors for their structs. I've never really had that problem. And, the extent that people want to minutely configure these accessors leads them back to the same commitment in time and typing as the thing they were trying to avoid.

### Learn object-oriented programming

The best way to learn what you need is to find an object-oriented language and learn it. That's not Java or C++, which merely have objects. Ruby is slightly better, but still is not completely object-oriented. Now Smalltalk, there's a language. Just about everything is an object, including the "World", which is the environment you are in. There's no escaping objects because there's no other way to work. Self may be interesting too.

When I say this during in-person training, someone will complain. I'm certainly being glib, but the question I ask is then "what methods can you call on `if`"? Read about [Smalltalk's Boolean class](https://pozorvlak.livejournal.com/94558.html):

> Smalltalk's designers had three choices: bake special syntax for if-statements into the language, implement it in Smalltalk library code in terms of more general concepts that were part of the language, or force the programmer to do the work him/herself every time...They made the unusual choice to go for the second option.

Cincom has a nice introduction to the ideas in [
Smalltalk User's Guide](http://www.cincomsmalltalk.com/pub/cstnc/ostudio/osnc6.9.old/OS_Smtlk.pdf). Alan Kay's original concept didn't focus on the objects. He was more concerned with [sending messages between objects](http://wiki.c2.com/?AlanKayOnMessaging). Eric Elliott nicely
provides the context in [The Forgotten History of OOP](https://medium.com/javascript-scene/the-forgotten-history-of-oop-88d71b9b2d9f).

If you want to use object-oriented programming in Perl, read Damian Conway's [Object Oriented Perl](https://www.manning.com/books/object-oriented-perl). You should already know Perl, though. We teach the syntax and mechanics in [Intermediate Perl](https://www.intermediateperl.com), but Damian teaches the ideas. Likewise, Mark Jason Dominus teaches functional programming in [Higher Order Perl]().

### Recognize object orientation

Object orientation is not a feature—it's a way of doing things.
There are four main object-oriented principles, although many lists add other things, such as classes. It's important to think about why you are doing something rather than how you accomplish it. Not every language has the idea of a class (and Ovid's Cor is certainly aware of Self, with its "slots").

Here are these principles, greatly simplified. When you are looking at something, ask how they support these ideas. If that thing isn't related to any of these, it's probably not helping you practice better OO. Very simplistically, these are:

* Encapsulation - consumers only get to do what you allow and only you change your state
* Abstraction - consumers don't know and don't care how you do it
* Inheritance - you can make more specific versions of something while reusing the code from the general case
* Polymorphism - similar things can act the same without the code knowing their differences

For what it's worth, I don't see anything in Cor that makes any of these easier or better in Perl. I don't see anything that is going to help people employ these ideas any better than they are doing now. I do see an extra layer of syntax.

Take, for instance, [Hash::AsObject](https://www.metacpan.org/pod/Hash::AsObject). This is a handy module that turns hash keys into method names on that hash:

{% highlight perl %}
use Hash::AsObject;

my $hash = Hash::AsObject->new( 'otter' => 'lutris' );
print $hash->otter;
$hash->otter( 'Enhydra' );
{% endhighlight %}

This is practically the same thing as a C struct. Does it deal with any of those four items? Nope. It's just a bag of data. I can see everything, change anything, and I know it's exactly a hash. I can use [Hash::AsObject](https://www.metacpan.org/pod/Hash::AsObject) as a base class and override some methods, but that doesn't really improve anything.

However, many people use objects as Bags of data. They put in some data and they take out some data. However, there a few other things that you want to know when you get and give data:

* Are these data valid?
* Are they valid for this context?

The setter method isn't there to primarily to store the data. It's the traffic cop that ensures you are following the rules and what you are doing makes sense. If it makes sense, the inner working continues, and otherwise the traffic cop complains. That's the primary job of the setter.

Many people think types solve this problem, and I guess that collection of very specific types (DateOlderThan21Years) can do that, but then you have an infinite number of types and all of the complexity you think you are saving goes into the type system. For example, "Int" is often a type, but most of the time you use an integer, not all integers are valid values.

You still have to check that the value is valid. Once you have to do that, the attractiveness of syntax shortcuts quickly disappears because you have to bring back all the complexity of the thing you are trying to replace.

And, it's not as simple as checking one value. With encapsulation, the object may need to update several things in the object. Object frameworks typically punt on these sorts of issues because the coordination isn't something they can easily force of a task when they don't even know the object represents. The tangled web in Moose or Cor isn't going to be better than subroutines.
