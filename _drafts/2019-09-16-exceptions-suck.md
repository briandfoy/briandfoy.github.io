---
layout: post
title: Exceptions suck
categories: programming
tags: exceptions perl
stopwords:
last_modified:
original_url:
---

Exceptions have been a problem since the advent of computing. People
have various complaints about them that go beyond what they see in the
literal code.

<!--more-->

You can't resume an exception in most languages, and even
the most ardent supporters realized there were better ways to get the same
thing.

Most languages have "terminal exceptions". You either handle them or
the program stops. These are really a second path for return values so
that you can skip several layers of the stack to find the first place
that wants to deal with the problem. But, that place that handles the
problem is mostly just to ignore it or stop the program.

Perl doesn't have a formal exception mechanism, so it relies on `die`,
a function to stop the program and exit with an error. An `eval` can
catch that die (as can setting `$SIG{__DIE__}`) and put the `die` argument
in `$@`. We then inspect that value of `$@`. That's what we call exception handling
in Perl.

However, that `$@` is a global variable. It's one of Perl's special
variables that is always in package `main`. This allows other parts of the
program to replace its value. Consider a call to `die` that is caught by
eval, replacing `$@`, while some other part of the program is calling
`die` and expects the user to see its value.  See the entry for `%SIG` and
`$^S` in L<perlvar>.

Since this mechanism cannot guarantee that the value you see in `$@` is
the one you should see, various third-party mechanisms have tried to solve
the problem. These typically use the `try-catch` structure you'll see in
other languages, and handle all the bookkeeping to preserve values. They bend
over backward to pass the right value up to the `eval`.

But, we really don't need to do any of this. The gymnastics of `try-catch`
come from our insistence on using `die`. We have to put up with the side
effect of `$@`. What do we really want to know?

=over 4

=item * We want to know an error happened.

=item * We want to give that error a name to recognize what happened.

=item * We want to do something when that error happens.

=back

There's another problem.

Typically, people make several (or a lot more) classes, each of which
represent a particular type of error. These classes are almost
completely identical, although some may carry information labeled in
slightly different ways. It's practically a requirement that these
classes be almost exactly the same because we want to do the same
sorts of things to them when we operate on them. We want to extract
its message, so they all should provide that in the same way, and so
on.

The natural thing seems to be to use inheritance. Some base class sets
up the foundational structure, and derived classes override default
values, such as the description (for all instances of that class) and
the default message. We do this because the main mechanism of
recognizing errors is the abuse of the inheritance tree:

	try { ... }
	catch ($e) {
		if( $e->isa( ... ) ) { ... }
		};

But we can forego the inheritance all together. Just give these objects
names, which we can assign arbitrarily per instance instead of relying
on any class organization:

	try { ... }
	catch ($e) {
		if( $e->is_named( ... ) ) { ... }
		};

The instance in `$e` can be the same class for every instance. We no
longer care about what `$e` is other than it's an exception. Every `$e`
acts the same because every one is the same class, which is mostly what
we had before. We don't derive any new classes at all. To recognize an
exception, we have only one class to check:

	$e->isa('X');

At this point, we still have to deal with the reality of all the code
out there that `die` in various ways and with various types of
objects. But, we should never be dealing with that at our application
level anyway. We don't want to couple our high level ideas with low
level, modular code. We either catch and adapt those at the lowest
level possible, or we don't use them at all. Should we switch out a
third-party module for another one, our high-level application code is
insulated from the change in low-level error reporting.

	sub something_low_level {
		my $result = eval { ThirdPartyModule->something };
		X->throw( ... ) if defined $@; # adapter
		...
		}

Now the trick is to handle these exceptions in a way that's unobtrusive.
And, Perl already as a way to do that: the `%SIG` hash. Signals are a
type of exception, and `%SIG` sets handlers for them. We can also define
`$SIG{__DIE__}` with a coderef to override the default `die` behavior.
Why not extend that to other exceptions too?

	{
	local $SIG{HTTPNotFound} = sub { ... };
	...
	}

This means that we no longer have to wrap the fragile code with various
layers of defensive programming. To make this work, we push down the complexity
to the layer that throws the exception. It can immediately check if
there's a handler by looking in `%SIG`, and use it if it finds it:

	package X {

		sub throw {
			....
			if( defined $SIG{$name} ) { $SIG{$name}->(...) }
			}
		}

This affords many advantages. First, resumable exceptions have
returned. We don't care what the `throw` actually does. That's up to
the programmer who want to handle that error. That throw might not do
anything, in which case the program continues after the call to
`throw`. The handler might do something like create a missing
directory or config file, and the code picks up after the `throw`.
Or, in terminal cases, the handler can `die` in it's intended use:
stopping the program.

Since you can `local`-ize the `%SIG` hash, or even just particular
keys, you can easily tune it for the scope that you want.

Furthermore, you can use the return value of `throw` to decide what
to do in the code that called it. Having already been handled, you
many not want to continue.

	sub something_low_level {
		eval { ThirdPartyModule->something } //
			return X->throw( ... );
		...
		}

=cut

# Further reading

* http://joeduffyblog.com/2016/02/07/the-error-model/
* https://medium.com/pragmatic-programmers/the-problem-with-exceptions-23d17cc8e4a5
* https://medium.com/codex/the-error-of-exceptions-3aed074c40dc
* https://mortoray.com/2012/04/02/everything-wrong-with-exceptions/
* https://www.joelonsoftware.com/2003/10/13/13/
* https://stackoverflow.com/questions/613954/the-case-against-checked-exceptions
* https://xerokimo.github.io/Blogs/How_to_reason_about_exceptions.html



package X {
	use parent qw(Hash::AsObject);
	use experimental qw(signatures);

	sub throw ( $class, %hash ) {
		$hash{name} = $class unless defined $hash{name};
		my $self = bless \%hash, $class;

		if( exists $SIG{ $self->name } ) {
			my $value = $SIG{ $self->name };

			return do {
				   if( ref $value eq ref sub {} ) { $value->( $self ) }
				elsif( fc($value) eq fc('ignore') ) { () }
				else { warn "No handler for $self->{name} exception"; 0 }
				};
			}
		else {
			die "Died because there is no handler for " . ref $self;
			};
		}
	}


eval {
	local %SIG = %SIG;
	$SIG{HTTPNotFound} = sub ( $x ) {
		say "Caught " . ref($x) . " exception and ignoring it."
		};
	$SIG{JustDie} = sub ( $x ) {
		say "Caught " . ref($x) . ". Dying."; die $x;
		};

	throw_up( 'HTTPNotFound' );
	say "Made it past throw_up with HTTPNotFound";

	throw_up( 'JustDie' );
	say "Made it past throw_up for JustDie";
	};
say "Error: $@" if $@;

eval {
	throw_up();
	say "Made it past throw_up";
	};
say "Error: $@" if $@;

sub throw_up ( $type = 'X' ) {
	X->throw(
		name => $type,
		url  => 'https://xyz.xample.com',
		) if 1;

	say "Got past the throw";
	}



#!perl
use v5.26;
use experimental qw(signatures);

package Inception::Base {
	use experimental qw(signatures);
	use mro;
	use overload
    	bool => sub {1}, '""' => 'as_string', fallback => 1;

	use Carp qw(croak);
	use Mojo::Util qw(dumper);

	our $VERSION = "0.001";

	sub _class ( $t ) { length ref($t) ? ref($t) : $t }

	sub _var ( $t, $name ) { join '::', _class($t), $name }

	sub new ( $class ) { ( bless {}, $class )->init }

	sub init ( $self ) {
		$self->field( $_, $self->$_() ) for $self->fields;
		$self;
		}

	sub add_field ( $class, $field, $sub = undef ) { no strict 'refs';
		$sub //= sub ( $self, $arg = undef ) { $self->field( $field, defined $arg ? $arg : () ) };
		*{ var($class, $field)   } = $sub;
		${ var($class, 'FIELDS') }{$field} = 1;
		}

	sub superclass ( $class ) { no strict 'refs';
		${ var($class, 'ISA') }[0] // ();
		}

	sub all_isa ( $class ) {
		mro::get_linear_isa( ref $class ? ref $class : $class )
		}

	sub as_string ( $self, @args ) { $self->message };

	sub description { 'Generic description' }

	sub fields ( $self ) {
		my $class = length ref($self) ? ref($self) : $self;
		no strict 'refs';

		my $coderef = eval { $self->superclass->can( 'fields' ) };
		sort(
			$coderef ? $coderef->( $self->superclass ) : (),
			keys %{"${class}::FIELDS"}
			)
		}

	sub make_subclass ( $class, @args ) { no strict 'refs';
		my %hash;
		if( @args == 1 ) { $hash{namespace} = $args[0] }
		elsif( @args % 2 == 0 ) {
			%hash = @args;
			}
		else {
			croak "Odd number of arguments";
			}

		my $name = $hash{namespace}
			or croak( "use the <namespace> key to specify the new class name" );
		$name = $class . $name if $name =~ m/\A::/;

		my %isa = map { $_, 1 } $class->all_isa->@*;
		if( exists $isa{$name} ) {
			croak "$name is already in the inheritance tree";
			}
		@{ _var($name, "ISA"     ) } = ( $class );
		@{ _var($name, "VERSION" ) } = $class->VERSION;
		*{ _var($name, "fields"  ) } = sub ( $self ) {
			my $class = length ref($self) ? ref($self) : $self;
			no strict 'refs';
			my $coderef = ${ _var($name, "ISA" ) }[0]->can( 'fields' );
			sort(
				$coderef ? $coderef->( ${ _var($name, "ISA") }[0] ) : (),
				keys %{ _var($name, "FIELDS") }
				)
			};

		my $description = $hash{'description'} // 'Undescribed exception';
		*{ join '::', _class($name), "description"} =
			sub ( $self ) { $description };

		$hash{fields} //= [];
		$name->add_field( $_ ) foreach ( $hash{fields}->@* );

		$INC{ $name =~ s|::|/|gr . 'pm' } = 'generated by ' . __PACKAGE__;
		return $name;
		}

	sub message { $_[0]->{message} = $_[1] if @_ > 1; $_[0]->{message} }

	sub type { length ref $_[0] ? ref $_[0] : $_[0] }

	sub throw ( $self, %args ) {
		$self = $self->new unless ref $self;
		foreach my $key ( keys %args ) {
			next unless $self->can( $key );
			$self->$key( $args{$key} );
			}
		die $self;
		}

	sub field ( $self, $field, $value = undef ) {
		$self->{user_fields} = {} unless exists $self->{user_fields};
		$self->{user_fields}{$field} = $value if @_ > 2;
		$self->{user_fields}{$field};
		}
	}

Inception::Base->make_subclass( namespace => 'X' );
say "Can? " . !! Inception::Base->can( 'fields' );

X->add_field( 'time', sub { $_[0]->field( 'time' ) // time } );

say 'X Fields: ', X->fields;

say "Making new object at " . time;
my $e = X->new;
eval { $e->throw( message => "This is the die message" ) };
say 'Message: ', $@->message;
say 'Time: ', $@->time;

say '-' x 40;
X->make_subclass(
	namespace   => '::HTTP',
	fields      => [ qw(host code) ],
	description => 'This is the X::HTTP description',
	);
say 'Can code? ', !! X::HTTP->can( 'code' );

eval { X::HTTP->throw( message => "The HTTP fails", code => 407 ) };
my $error = $@;
use Mojo::Util qw(dumper);
say "Code: ", $error->code;

__END__

say '-' x 40;
X::HTTP->make_subclass(
	namespace => '::NotFound',
	description => 'This is the X::HTTP::NotFound description',
	);
eval { X::HTTP::NotFound->throw( message => "The HTTP is not found", code => 404 ) };
say 'Type: ',    $@->type;
say 'Message: ', $@->message;
say "Message string: $@";
say 'Code: ',    $@->code;
say 'ISA: ',     join ' ', $@->all_isa->@*;
say 'X::HTTP::NotFound Fields: ', join ' ', X::HTTP::NotFound->fields;

say '-' x 40;
X::HTTP->make_subclass( namespace => 'X' );

__END__
my @exceptions = (
	[ 'Y', [qw(foo bar)], 'This is Y', [
			[ '::W', [], 'This is ::W' ],
			[ '::A', [qw(iota)], 'This is ::A' ],
		]
	],
	[ 'Z', [qw(quux)], 'This is Y', []
	],
	);

while( my $item = shift @exceptions ) {
	my( $class, $fields, $description, $subclasses ) = @$item;

	push @exceptions, map { [ [ $class, @$subclasses
	}
