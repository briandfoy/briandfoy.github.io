---
layout: post
title: the null mull
categories:
tags:
stopwords:
last_modified:
---

https://www.perlmonks.org/?node_id=410871

<p>
I've been thinking about the Null design pattern recently.  People get wrapped up in UML diagrams, Gang of Four descriptions, and
all sorts of other things.  Patterns are really simple, and this is
one of the simpler one.  It's not complicated enough to get it's own
module (there is a [cpan://Class::Null]), and this isn't everything I've been
thinking about, but it's a start.
</p>
<p>
Everyone has probably experienced the pain and frustration of something
in their script trying to call a method on something that isn't a
reference.
</p>

<code>
$ perl -e '1->method'
Can't call method "method" without a package or object reference at -e line 1.
</code>

<p>
This might happen from something we programmed ourselves, or because
something in the bowels of a module tried to do something it shouldn't
have done.  This is one of my favorite examples while teaching when
I need to show people which languages have objects and which don't.
For extra credit, out of Perl, Java, C++,and Ruby, which one is
really object based?
</p>
<readmore>
<p>
The problem at the very bottom of this is Perl's lack of a true object
system.  Perl may be an object oriented language only in that parts
of it are oriented toward objects, but, like a lot of other languages
that claim to be object-oriented, it has things that aren't objects.
That's also what makes Perl great and malleable.
</p>
<p>
If we care about this sort of thing, and there are people who do
care (perhaps too much, even), we just need to use more objects. We
don't have to go crazy and make everything an object.  People who
like that sort of thing probably don't use Perl anyway.
</p>
<p>
So, what to do when we need to call a method but we don't have an
object to send the method too?  For instance, in method chaining,
the previous step has to return an object to go onto the next
step.  methoda() has to return an object that can respond to
methodb().
</p>

<code>
my $result = $obj->methoda->methodb->methodc;
</code>

<p>
If methoda() doesn't return an object, the program dies. Not
only that, if methoda() doesn't return an object that can
respond to methodb(), the program stops.  That's broken.  If
we design our interface, it shouldn't break, even if things
fail.  We shouldn't have to duct tape an eval {} around the
code to catch it from breaking, and we should be able to choose
how to handle errors before perl has to.
</p>
<p>
If we can't return the object we want because things went wrong,
we can return a different object.  No law in the universe says you
have to return an object of the same class.
</p>
<p>
Since we only need to keep the chain from breaking (which is
different than making it keep working), we need something to
call methods on, and it has to respond to any method we
decide to throw at it since we don't know a priori which
methods we might call on this other object.  No problem:
just return itself for any method.  An AUTOLOAD function
takes care of that.
</p>

<code>
package Object::EveryMethod;

my $all = bless {}, __PACKAGE__;

sub new { $all }

sub AUTOLOAD { $_[0] }
</code>

<p>
Now I use this in my methods.  If you already do the right
thing with your failure codes, you have the magic value in some
sort of variable or symbolic constant.  Just shove the new object
in there instead.  The object $all only exists once, and everyone
shares it.  Since it doesn't do anything or store any information,
we don't need more than one.  This is the Singleton design pattern, for
those that care.  <a href="http://www.theperlreview.com/Issues/">I
wrote about singletons in The Perl Review 0.1</a>
</p>

<code>
# my $False = 0;  # old way
my $False = Object::EveryMethod->new();

sub methoda
	{
	my $self = shift;
	#...

	if( ... everything worked ) { $self }
	else                        { $False }

	}
</code>

<p>
That takes care of the method chaining problem.  It's not
going to break because it tries to do something it shouldn't
do, like call a method on a non-object.  The chain goes all
the way to the end, but the object switches at some point to
an instance Object::EveryMethod. At the end, the last method
returns the Object::EveryMethod reference.  That's our
failure code.  Instead of 0 or undef or whatever we get are
false object.
</p>
<p>
Once we get the result, we want to know if whatever we tried
to do did what we wanted it to do or if it failed.  If we
are doing what we are supposed to be doing, it can only fail
in one way: it gives us back an instance of
Object::EveryMethod.  If it worked, we get back some other
object.  We can use UNIVERSAL::isa to check that, and we can
use a function to hide that nastiness.
</p>

<code>
sub hey_that_worked
	{
	not UNIVERSAL::isa( $_[0], 'Object::EveryMethod' )
	}
</code>

<p>
There are other tricks to make that  we can do to test the
result, but you can figure those out on your own.  As long as
we have a way to check, we're all set.
</p>
<p>
We may also want to know when things go wrong and why.  We have the
initial concept, and if that's not good enough for us, we just extend
it a bit.  Instead of a singleton, we create a error object that
can carry so information.  We don't have to interrupt the flow of
the program with crazy things like exceptions, and the error
checking won't dominate the useful parts of the program.
</p>
<p>
Let's change the Object::EveryMethod a bit.  We'll add some information
to the object, and a method to get the information back.  Now, the
first method to create it gets to set the message and it's identity.
Any method we call on it just returns the object, including all of
its original information.
</p>

<code>
package Object::EveryMethod;

sub new
	{
	my $class = shift;

	bless {
		message => $_[0],
		setter  => ... caller stuff,
		}, $class;
	}

sub AUTOLOAD { $_[0] }

sub what_happened { @{ $self }{ qw( message setter ) } }
</code>

<p>
We use it a bit differently.  We create a tiny object for each
error (or, we can use a pool of flyweight objects).
</p>

<code>
sub methoda
	{
	my $self = shift;
	#...

	if( ... everything worked ) { return $self }
	else
		{
		my $failure = "Oops, I did it again!";
		return Object::EveryMethod->new( $failure );
		}

	}
</code>

<p>
Once we have the Object::EveryMethod, we can check it like before
and then get information out of it to see what went wrong.
</p>
<p>
From there the variations are up to you, and you can design the
Object::EveryMethod class to fit your needs.  Indeed, you should
make your own instead of using some module.  Make your own design
decisions to fit the situation.  Design patterns aren't about
using the right modules:  they're about doing things that fit into
the rest of the project.
</p>
<p>
We can hang some other fancy features on Object::EveryMethod.  Since
we use AUTOLOAD for everything, we can't call the can() method on
them while returning a value that users of can() expect.  We have to
give back true or false, not another object.  We just add our own
can() method that always returns true.
</p>

<code>
package Object::EveryMethod;

sub new
	{
	my $class = shift;

	bless { ... }, $class;
	}

sub AUTOLOAD { $_[0] }
sub can      { 1 }

sub what_happened { @{ $self }{ qw( message setter ) } }
</code>

<p>
If that doesn't work for us, we can make it return false,
except for the methods we defined.  If we are alrady using
can(), we probably expect the object to actually do
something useful when we call the method we check and have a
way to handle it if the object can't do what we need.  Since
we define our own can(), Perl finds that one before it gets

a chance to check UNIVERSAL.
</p>

<code>
package Object::EveryMethod;

sub new
	{
	my $class = shift;

	bless { ... }, $class;
	}

sub AUTOLOAD { $_[0] }
sub can      { 0 unless defined &{$_[1]} }

sub what_happened { @{ $self }{ qw( message setter ) } }
</code>

<p>
We need only ensure that what_happened() (or any other method
in Object::EveryMethod) doesn't exist in any other class interface,
or we're back to breaking things again.    There are lots of ways
around that too.
</p>

<p>
So, for not too much work, we get a way to not break method
chaining, don't have to use eval {} to catch broken code,
don't need exceptions, and it can fit into what we're already
doing with all of our other objects.  Beware though:  just
because it has all that, it isn't necessarily the right
way to do things for whatever we are doing.
</p>

<!-- Node text goes above. Div tags should contain sig only -->
<div class="pmsig"><div class="pmsig-366986">
-- <br />
brian d foy <bdfoy@cpan.org>
</div></div>

<p><small>2004-11-29 Janitored by [Arunbear] - added readmore tags, as per Monastery [id://17558|guidelines]</small></p>
