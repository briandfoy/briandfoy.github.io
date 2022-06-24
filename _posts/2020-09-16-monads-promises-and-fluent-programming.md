---
layout: post
title: Monads, Promises, and Fluent Programming
categories: programming
tags: perl design-patterns promises monads
stopwords: Stepan's Parunashvili
last_modified:
original_url:
---

I read Stepan Parunashvili [Inventing Monads](https://stopa.io/post/247), in which he starts with some small, simple functions and quickly runs into problems in their use. He mutates them until he ends up with monads, a hot feature I mostly associate with Haskell. These compose separate actions to get something that's safe and predictable.

<!--more-->

I wanted to redo this is Perl so I could make some other points. Stepan contrives a situation to get to a particular endpoint, which is what us tech writers do. He wants to show something about Monads and that's why he follows the progression he does. He's not trying to suggest a particular way of programming.

## Chaining operations

I'll mostly follow Stepan's progression, which starts with a set of functions that rely on the others:

{% highlight perl %}
use experimental qw(signatures);

%Users = ...; # or some database thing
sub get_user            ( $id      ) { $Users{$id} }
sub get_profile         ( $user    ) { $user->profile }
sub get_display_picture ( $profile ) { $profile->display_picture }
{% endhighlight %}

You always have the `$id` value, and you build up from that to get the profile and to get the display picture:

{% highlight perl %}
getDisplayPicture( getProfile( getUser($id) ) )
{% endhighlight %}

The problem is that this only works if everything is perfect. There's a user with that ID, that user has a profile, and that profile has a display picture. First, I'll set aside that I'd do all of this in a different way where I wouldn't have to know the low-level details, such as needing the profile to get the picture. It's an example and I'll stick with that as presented.

As an intermediate step, Stepan invents the `Chainer`, a composer that can recognize when the previous step has failed. The chain starts with the info at the bottom of the process and then goes through the steps to get to the final desired value:

{% highlight perl %}
Chainer->new( get_user($id) )
	->when( sub ($a) { get_profile($a)         } )
	->when( sub ($a) { get_display_picture($a) } );
{% endhighlight %}

If there's a value, it uses that value as the argument to the next step. (For Perl people, the `=>` in his code is a fancy way to define a lambda, not create a pair. It's `SIGNATURE => CODE`.).

{% highlight perl %}
package Chainer {
	use experimental qw(signatures);

	sub new ( $class, $value ) {
		bless { value => $value }, $class;
		}

	sub value ( $self ) { $self->{value} }

	sub when( $self, $f ) {
		defined $self->value ?
			ref($self)->new( $f->($self->value) )
			:
			$self;
		}
	}
{% endhighlight %}

In that code, each step is a new `Chainer` object, either the new one with a new value or the current one. Stepan modifies that for the case where one of the functions already returns a chained thingy. In that case (in `merge`) you don't make a new `Chainer`:

{% highlight perl %}
Chainer->new( get_user($id) )
	->merge( sub ($a) { returns_chainer($a)     } )
	->when(  sub ($a) { get_display_picture($a) } );

package Chainer {
	use experimental qw(signatures);

	sub new ( $class, $value ) {
		bless { value => $value }, $class;
		}

	sub value ( $self ) { $self->{value} }

	sub when( $self, $f ) {
		defined $self->value ?
			ref($self)->new( $f->($self->value) )
			:
			$self;
		}

	sub merge( $self, $f ) {
		defined $self->value ?
			$f->($self->value)
			:
			$self;
		}
	}
{% endhighlight %}

Since he always returns a `Chainer` thingy, I don't see how he gets around a failure. You get one of the thingys, maybe the initial one, and then call `when` on it. The value that the `Chainer` stored was for the previous step but now he tries to use it for the next step. I could be missing something in his setup, but he never mentions how things work when any step fails.

Not only that, I shouldn't need the extra `merge` method. I can look at the value to see if it's a `Chainer` sort of thing (in this case, using the new [isa operator from v5.32](https://www.effectiveperlprogramming.com/2020/01/use-the-infix-class-instance-operator/)). This might not be allowed:

{% highlight perl %}
use v5.32;

package Chainer {
	use experimental qw(signatures);

	sub new ( $class, $value ) {
		bless { value => $value }, $class;
		}

	sub value ( $self ) { $self->{value} }

	sub when( $self, $f ) {
		return $self unless $self->value;
		my $value = $f->($self->value);
		$value isa 'Chainer' ?
			$value
			:
			ref($self)->new( $value )
		}
	}
{% endhighlight %}

From there, you can follow [Stepan's post]((https://stopa.io/post/247) to learn more about how this resembles monads. I want to look at the particular problem and a few techniques for dealing with it.

## Promises

So, lets try something else. How about Promises? I only want to go to the next step if the previous step works? Stepan mentions that the `Chainer` sidesteps callback hell, but so do Promises:

[Mojo::Promise](https://docs.mojolicious.org/Mojo/Promise) is a Perl implementation of A+ Promises. I've wrote [Higher Order Promises](https://mojolicious.io/blog/2018/12/03/higher-order-promises/) for the 2018 Mojo Advent Calendar, and [solved some exercises using Raku's Promises](https://www.learningraku.com/2017/04/18/the-24-puzzle-in-perl-6-using-channels-and-promises/).

Here's what I think the Promise version of `Chainer`. Each step leads to the next `then`:

{% highlight perl %}
use v5.10;
use Mojo::Promise;

my $promise = Mojo::Promise->new;

my $chain = $promise
	->then(
		sub { say "First step resolves" },
		)
	->then(
		sub { say "Second step resolves" },
		)
	->then(
		sub { say "Third step resolves" },
		)
	;

$promise->resolve;
$chain->wait;
{% endhighlight %}

This outputs the message for that step:

{% highlight text %}
First step resolves
Second step resolves
Third step resolves
{% endhighlight %}

That's fine. The chain happens. But what if I reject the `$promise`?

{% highlight perl %}
$promise->reject;
$chain->wait;
{% endhighlight %}

Now I get an error because I don't have a handler:

{% highlight text %}
Unhandled rejected promise:  at ...
{% endhighlight %}

I can handle that anywhere I like, but a `catch` at the end works:

{% highlight perl %}
my $chain = $promise
	->then(
		sub { say "First step resolves" },
		)
	->then(
		sub { say "Second step resolves" },
		)
	->then(
		sub { say "Third step resolves" },
		)
	->catch( sub { warn 'wtflol' } )
	;
{% endhighlight %}

But, a `catch` is just a `then` with only a `reject` branch:

{% highlight perl %}
my $chain = $promise
	->then(
		sub { say "First step resolves" },
		)
	->then(
		sub { say "Second step resolves" },
		)
	->then(
		sub { say "Third step resolves" },
		)
	->then( undef, sub { warn 'wtflol' } )
	;
{% endhighlight %}

Now expand that into something real. Create a Promise and resolve it with the user ID I want to find. That's primes the pump.

After that, use a series of `then`s that each do the next step in the process. Each `then` only handles the `resolve` branch. If the function call works (returns a defined value in this example), I return that defined value. That value becomes the argument for the subroutines in the next `then`. If I make it all the way to the final `then` with a resolved Promise, I assign to final value (the picture) to `$picture` and output a message.

If something doesn't work, I return a rejected Promise that knows why it failed. Since nothing else but the final `then` handles the rejected branch, the interstitial `then`s are effectively skipped and I can look in the argument list for the reason it failed:

{% highlight perl %}
use v5.10;
use Mojo::Promise;
use experimental qw(signatures);

my %Users = (
	137 => {
		id => 137,
		profile => {
			pic => 'brian.jpg',
			},
		},
	37 => {
		id => 37,
		},
	7 => {
		id => 7,
		profile => {},
		},
	);

sub user    ( $id      ) { $Users{$id}      }
sub profile ( $user    ) { $user->{profile} }
sub picture ( $profile ) { $profile->{pic}  }

my $promise = Mojo::Promise->resolve( shift );

my $picture;
my $chain = $promise
	->then(
		sub { defined $_[0] ? $_[0] :
			Mojo::Promise->reject( "No userid!" ) },
		)
	->then(
		sub { user( $_[0] )
			// Mojo::Promise->reject( "No such userid $_[0]" ) },
		)
	->then(
		sub { profile( $_[0] )
			// Mojo::Promise->reject( "User $_[0]{id} does not have a profile" ) },
		)
	->then(
		sub { picture( $_[0] )
			// Mojo::Promise->reject( "Profile does not have a picture" ) },
		)
	->then(
		sub { $picture = $_[0]; say "Picture is $_[0]" },
		sub { warn "wtf: @_" }
		)
	;

$chain->wait;
{% endhighlight %}

Here are some runs, where I neglect to supply a user ID, give one I know doesn't exist, and so on so I get all the responses:

{% highlight perl %}
$ perl promises.pl
wtf: No such userid

$ perl promises.pl 4
wtf: No such userid 4

$ perl promises.pl 7
wtf: Profile for  does not have a picture

$ perl promises.pl 7
wtf: Profile does not have a picture

$ perl promises.pl 37
wtf: User 37 does not have a profile

$ perl promises.pl 137
Picture is brian.jpg
{% endhighlight %}

But, that code is pretty ugly. One of the major problems (among others), is that I hard-coded the chain. That's easy enough to fix—I'll construct all the middle `then`s from a table instead. Rather than check with `defined`, I'll add a new step to verify the input.

{% highlight perl %}
sub looks_like_id ( $id      ) { $id =~ /\A[0-9]+\z/ ? $id : undef }
sub user          ( $id      ) { $Users{$id}                       }
sub profile       ( $user    ) { $user->{profile}                  }
sub picture       ( $profile ) { $profile->{pic}                   }

my $user_id = shift;
my $promise = Mojo::Promise->resolve( $user_id );

my @table = (
	[ \&looks_like_id, "Doesn't look like a userid [%s]"               ],
	[ \&user,          "No such userid [%s]"                           ],
	[ \&profile,       "User [%s] does not have a profile"             ],
	[ \&picture,       "Profile for user [%s] does not have a picture" ],
	);

my $chain = $promise;
my $picture;
foreach my $tuple ( @table ) {
	my $sub = sub {
		my $error = sprintf $tuple->[1], $user_id;
		$tuple->[0]->( $_[0] ) // Mojo::Promise->reject( $error );
		};

	$chain = $chain->then( $sub );
	}

$chain
	->then(
		sub { say "Picture is $_[0]" },
		sub { say "wtf: @_" }
		)
	->wait;
{% endhighlight %}

## Method chaining

There's a trick I like a bit too much, but it's fun enough to justify sometimes. Sometimes this sort of thing is called [fluent programming](https://martinfowler.com/bliki/FluentInterface.html), but I'm going to stick with "method chaining". The trick is handling errors in the middle of the chain.

I want to write something like this, where I have a chain of methods one after the other. This isn't a good design for this problem, but it's fine for showing the method chaining idea. Each method returns an object. It could be the same object or different objects. I don't have to know too much about that:

{% highlight perl %}
my $user_id = shift;
my $picture = UserThings->new($user_id)
	->looks_like_id
	->user
	->profile
	->picture;
{% endhighlight %}

So, how do I handle errors? Here's the trick. If a method fails, I'll return a null object that responds to any method name by returning itself. That soaks up the rest of the method chain without an error. When you want to know if the whole thing worked, you look at what you got back. This is the same object type technique I used in [No ifs, ands, or buts](/no-ifs-ands-or-buts/), [The Null Mull](/the-null-mull/), and the StackOverflow answer [How do I handle errors in methods chains in Perl?](https://stackoverflow.com/a/7068271/2766176):

{% highlight perl %}
if( $picture isa 'Local::Null' ) {
	warn "wtf: " . $picture->{message} . "\n";
	}
else {
	say "Picture is $picture";
	}
{% endhighlight %}

Here's the null class. The `new` creates it and the `AUTOLOAD` handles any method not defined by returning the null object again. I handle `DESTROY`, a special Perl finalizer method to break an infinite loop:

{% highlight perl %}
package Local::Null {
	use experimental qw(signatures);

	sub new ( $class, $message ) {
		bless { message => $message }, $class;
		}
	sub DESTROY  { 1 }
	sub AUTOLOAD ( $self ) { $self }
	}
{% endhighlight %}

To handle everything else, stuff moves into a class. Each method either succeeds or returns a null object:

{% highlight perl %}
package UserThings {
	use experimental qw(signatures);

	my sub _null ( $message ) { Local::Null->new( $message ) }

	sub new  ( $class, $id ) { bless { id => $id }, $class }
	sub id   ( $self ) { $self->{id} }

	sub looks_like_id ( $self ) {
		$self->id =~ /\A[0-9]+\z/ ?
			$self
			:
			_null( sprintf "Doesn't look like a userid [%s]", $self->id )
		}
	sub user ( $self ) {
		$self->{user} = $Users{$self->id} ?
			$self
			:
			_null( sprintf "No such userid [%s]", $self->id )
		}
	sub profile ( $self ) {
		$self->{profile} = $Users{$self->id}{profile} ?
			$self
			:
			_null( sprintf "User [%s] does not have a profile", $self->id );
		}
	sub picture ( $self ) {
		exists $Users{$self->id}{profile}{pic} ?
			$Users{$self->id}{profile}{pic}
			:
			_null( sprintf "Profile for user [%s] does not have a picture", $self->id );
		}
	}
{% endhighlight %}

There are various ways that I can reduce this to create new classes on the fly with just the operations I want to do, but that's some tricky code I don't want to explain here.

