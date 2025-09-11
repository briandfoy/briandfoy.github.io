---
layout: post
title: Why do we need references?
categories: programming perl
tags:
stopwords:
last_modified:
original_url:
---

https://stackoverflow.com/questions/21352651/what-is-the-purpose-of-references-in-perl

Previous answers noted part of the reason for references, but there's much more to them.

<!--more-->


# Variables are references already (but not that kind)

First, you have to understand how Perl uses data. Let's start with an example with `localtime`, which returns a list of values. One of those values is the year, but 1900 less than it actaully is

     printf 'The year is %d', 1900 + (localtime)[5];

In this program, there's a list of values stored somewhere, and we slice it. But those data are there somewhere (although in some things, perl is smart enough to handle very common cases differently for performance). We don't have a variable connected to those data, so it disappears after the slice (but, in cases like `stat`, Perl might save that data).

What if we don't want to use those data right away? We can assign it to a named array then use it later:

    my @localtime = localtime;
    ...
    printf 'The year is %d', 1900 + $localtime[5];

This is Perl connecting a name to some data stored somewhere. That's technically a reference (for ref counting) because *perl* connects a name to data. Perl does not dispose of that data until all the references to it have been disconnected. Even then, the actual data might not disappear until *perl* decides to clean up after itself.

## Complex data structures

Perl has scalars, which are single values. A scalar variable stores a scalar value. A list is a sequence of scalar values, and an array holds a list value. A hash has strings (not scalars!) as keys, and scalars as values. And we'll ignore the rest of the Perl data types since they aren't important here.

Remember that a list is a sequence of scalars, which means that a list does not contain a list, or at least a list that can retain its identity. These are all the same list once

	my @n12 = qw(1 2);
	my @n456 = qw(4 5 6);

	( (1, 2), 3, @n456 )
	( @n12, 3, 4, 5, 6 )
	( (1, 2, (3, 4), (5), 6))

This is different from many languages where a lists do not flatten, and the worthiness of that idea is left to a different arugment. In Perl, a list is a sequence of scalars and nothing else.

However, a reference is a scalar value. It's a single value, and its value is a pointer to data, although not a pointer as you would expect from C. Since the reference is a single value, we can store it in a scalar variable. These are all different structures:

 	( [1, 2], 3, \@n456 )
	( \@n12, 3, 4, 5, 6 )
	( [1, 2, [3, 4], [5], 6])

We can see the differences by dumping the data:

	$ perl -MData::Dumper -E '@n456 = qw(4 5 6); @l = ( [1, 2], 3, \@n456 ); say Dumper( \@l )'
	$VAR1 = [
			  [
				1,
				2
			  ],
			  3,
			  [
				'4',
				'5',
				'6'
			  ]
			];

	$ perl -MData::Dumper -E '@n12 = qw(1 2); @l = ( \@n12, 3, 4, 5, 6 ); say Dumper( \@l )'
	$VAR1 = [
			  [
				'1',
				'2'
			  ],
			  3,
			  4,
			  5,
			  6
			];

	$ perl -MData::Dumper -E '@l = ( [1, 2, [3, 4], [5], 6]); say Dumper( \@l )'
	$VAR1 = [
			  [
				1,
				2,
				[
				  3,
				  4
				],
				[
				  5
				],
				6
			  ]
			];

And, since all references are scalars, we don't care what sort of data the references point to. These are all scalars:

	$ref = \%hash;
	$ref = { ... };  # anonymous hash constructor
	$ref = \@array;
	$ref = [ ... ];  # anonymous array constructor
	$ref = \&some_sub;
	$ref = sub { };  # anonymous subroutine

We can mix these as we like to create complex data structures. Here's an array of hashes:

	my @array_of_hashes = (
		{ key => $value1 },
		{ key => $value2 },
		...
		);

XXXX

Suppose we want to send the data referred to by `@localtime` to a subroutine to process it, and we want `@localtime` to reflect the changes. We have to understand a little about how Perl passes arguments to subroutines.

Perl passes lists to subroutines, not arrays (which are variables that hold lists). This means that these are all the same to *perl*:

	some_sub( (1, 2), 3, @n456 );
	some_sub( @n12, 3, 4, 5, 6 );

# Sharing the same data

Lets start with a routine to add 1900 to the year. The arguments to a subroutine show up in the special variable `@_`, so the sixth element, the year, is the normal single element access to an array, `$_[5]`:

    my @localtime = localtime;
    printf 'The year is %d', $localtime[5];

    add_offset( @localtime );
    printf 'The year is now %d', $localtime[5];

    sub offset { $_[5] += 1900 };

The output shows that this works and the value in `@localtime` is different after the call to `offset`:

	The year is 125
	The year is now 2025

But, this works because *perl* actually aliases the values in `@_` to the data for speed and memory use (and *perl* largely now has Copy On Write (COW) everywhere). But, change that subroutine to something more complex where the first argument is the offset. This is pretty silly, but this still works even after using `shift`, which takes the first item off `@_`:

    my @localtime = localtime;
    printf "The year is %d\n", $localtime[5];

    add_offset( 1900, @localtime );
    printf "The year is now %d\n", $localtime[5];

    sub add_offset {
    	my $offset = shift;
    	$_[5] += $offset;
    	};

The output still shows that this works even though we moved the indices of `@_` before making the change:

	The year is 125
	The year is now 2025

Now here's where it breaks, and this is how things tend to look in actual programming because subroutines doing something interesting are probably not using `@_`, even if I have been guilty of that. In this example, we copy all the values into variables, and all of the value from `localtime` end up in `@times`, which is then the thing we change:

    my @localtime = localtime;
    printf "The year is %d\n", $localtime[5];

    add_offset( 1900, @localtime );
    printf "The year is now %d\n", $localtime[5];

    sub add_offset {
    	my($offset, @times) = @_;
    	$time[5] += $offset;
    	};

The output shows that no longers works. Since we don't use `@_` in the operation, the magical aliasing isn't a factor. The values in `@times` are disconnected from `@localtime`:

	The year is 125
	The year is now 125

As a purely internal matter, which you can ignore for this, *perl* won't actaully make data copies until you change the data. Although we may say `@localtime` and `@times` have their own copy, that might not actually be true if we haven't changed `@times`. This is the COW stuff at work. However, logically, `@localtime` and `@times` act as if they have separate copies of the data.

The [Devel::Peek](https://metacpan.org/pod/Devel::Peek) that lets us inspect the low-level details of perl values:

	use Devel::Peek;

    my @localtime = localtime;
	Dump($localtime[5]);

    add_offset( 1900, @localtime );
    printf "The year is now %d\n", $localtime[5];

    sub add_offset {
    	my($offset, @times) = @_;
    	Dump($_[6]);
    	Dump($times[5]);
    	$times[5] += $offset;
    	};

The output shows three groups of text that start with `SV`, for scalar value. The first two groups look the same because they refer to the same data. The third one is diffrent because we saved the list in the named variable `@times`, which is now independent of `@_`:

	The year is now 125
	SV = NV(0x13c025d10) at 0x13c025d28
	  REFCNT = 1
	  FLAGS = (NOK,pNOK)
	  NV = 125
	SV = NV(0x13c025d10) at 0x13c025d28
	  REFCNT = 1
	  FLAGS = (NOK,pNOK)
	  NV = 125
	SV = NV(0x13c026070) at 0x13c026088
	  REFCNT = 1
	  FLAGS = (NOK,pNOK)
	  NV = 125

At the time of this question, Perl subroutine signatures where not a thing, but eventually perl will not expose `@_` when signatures are in use:

	use v5.40;
	use Devel::Peek;
    my @localtime = localtime;
	Dump($localtime[5]);

    add_offset( 1900, @localtime );
    printf "The year is now %d\n", $localtime[5];

    sub add_offset ($offset, @times) {
    	Dump($times[5]);
    	$times[5] += $offset;
    	};

This also doesn't work:

	The year is now 125
	SV = NV(0x13b025d10) at 0x13b025d28
	  REFCNT = 1
	  FLAGS = (NOK,pNOK)
	  NV = 125
	SV = NV(0x13b026070) at 0x13b026088
	  REFCNT = 1
	  FLAGS = (NOK,pNOK)
	  NV = 125

## Passing references instead of values

But there's a way to make this work: references. We can use a reference to pass a data structure where we share all of the values, always:

	use v5.40;
	use Devel::Peek;
    my @localtime = localtime;
	Dump($localtime[5]);

    add_offset( 1900, \@localtime );
    printf "The year is now %d\n", $localtime[5];

    sub add_offset ($offset, $times) {
    	Dump($times->[5]);
    	$times->[5] += $offset;
    	};

This works again, and the two SV records are the same because `@localtime`'s data are the same as the array reference `$times`:

	SV = NV(0x1428233d0) at 0x1428233e8
	  REFCNT = 1
	  FLAGS = (NOK,pNOK)
	  NV = 125
	SV = NV(0x1428233d0) at 0x1428233e8
	  REFCNT = 1
	  FLAGS = (NOK,pNOK)
	  NV = 125
	The year is now 2025

In [Intermediate Perl](https://www.intermediateperl.com), we used the PeGS structures developed by Joseph Hall. This diagram shows an array variable named `@localhost` is associated with the list, and that there is a separate scalar variable (all references are scalars) that points to the same list data:

We can have as many references to the data as we like.

## Deciding as late as possible.

We can use references when we don't know which data we want to use at compile-time (or, even at the start of runtime). So far we had this line, where we take a reference to a named array directly in the argument list:

    add_offset( 1900, \@localtime );

But, that line could easily be a scalar variable that holds a reference, and this line of code doesn't decide what those data are:

    add_offset( 1900, $ref );

We could get the same data as before by calling `localtime`, this time using the anonymous array constructor `[ ]` to make the reference directly:

	my $ref = [ localtime ];
    add_offset( 1900, $ref );

But, we could also do something like this, where we could use one of two references, and we don't know ahead of time one the code will choose:

	my $ref = $use_gmt ? [ gmtime ] : [ localtime ];
    add_offset( 1900, $ref );

It doesn't matter which branch we take in that conditional operator because the right thing ends up in `$ref`. And, this can be as complicated as we like. Consider a hash that has many references, and we don't know ahead of time which hash value the program might choose:

	my %hash = (
		yesterday    => [ ... ],
		tomorrow     => [ ... ],
		one_year_ago => [ ... ],
		...
		);
    add_offset( 1900, $hash{$key} );


