---
layout: post
title: Counting IPv4 addresses with a bitmap
categories: perl programming
tags: bit-vector vec
stopwords:
last_modified:
original_url:
---

I had  this task to count IPv4 addresses, but the typical way of counting with a hash has problems. With Perl, you might think to just use each item as the hash key and increment its value each time you find one. However, when you are looking at most of the IPv4 space, or even half of it, that's a couple billion keys that might not fit into memory. Remember, each of those values are a scalar value (SV) that take up several bytes merely by existing, and that SV takes up several octets.

<!--more-->

As an aside, hash keys are not SVs; they are simple strings. This is why a hash key cannot be tainted and one way to get around taint checking is to send the SV through a hash key, losing all its SV flags, and pull it back out. I write about this in [Mastering Perl](https://www.masteringperl.org).

Maybe you have enough memory to do all of this, but in the environment where I do this, I do not. That's simply because the owners of the hardware aren't going to give me several hundred Gigs of RAM. So, I need to come up with another way.

Since I only needed to know if a particular IPv4 address was part of the data, I don't really care about which address that was (but I will be able to). I just need the count of unique IPv4 addresses. Perl has a way that I can map them onto a much smaller data structure: the bit vector.

But IP numbers are just just, well, numbers (sometimes represented as
strings), so let's simplify this with a smaller set of numbers. I'll use one
bit for each IP address, and it's position is its integer value. For example, the address 192.168.1.1 is really the positive whole number 3,232,235,777, which I know because I have a bash shell alias to convert it:

	$ alias ip_aton
	alias ip_aton='perl -MSocket=inet_aton -le '\''print unpack q(N), inet_aton(shift)'\'''

	$ ip_aton 192.168.1.1
	3232235777

I won't go through a long `vec` tutorial here, especially since our field width is one bit which makes it straightforward. Here's a small demonstration where I start with nothing in `$bitmap`, and when I see a number, I set a bit at that position. Perl takes care of extending the bitmap as needed. I use numbers up to 13:

	#!perl
	use v5.36;
	use strict;
	use warnings;

	my $bitmap;
	foreach my $i ( random_numbers(10, 4) ) {
		say "Saw $i";
		vec( $bitmap, $i, 1 ) = 1;
		say show_vec($bitmap);
		}

	sub random_numbers ($max = 13, $n = 10) {
		my @a = map { int rand $max } 1 .. $n;
		}

	sub show_vec ($b) {
		my $bits = 8 * length $b;
		my $s =
			join '',
			map { vec($b, $_, 1) ? '+' : '.' }
			0 .. $bits - 1;
		}

Here's one run. In the bitvector, I show "not set" as `.` and "set" as `+`. Notice that Perl grows the size of the bitvector as needed:

	 2: ..+.....
	 9: ..+......+......
	 2: ..+......+......
	 8: ..+.....++......

Now I want to know haw many of the unique numbers I saw, so I add a function to count the bits:

	sub count_unpack ($b) {
		unpack("%32b*", $b);
		}

Now honestly, raise your hand if you've ever seen something like that before. I think I've only seen it because I handled the `pack` section
of the latest *Programming Perl*.

The `%` in the `unpack` indicates that I want a checksum of the values, taking 32 thingys at a time. This is effectively the count of set bits.

Now, if instead of random numbers I do this for IP addresses, I get the count of IPv4 addresses, and do it for something under 600 MB (counting all the other stuff going on). That's pocket change for some applications.

As a side note, `unpack` has a nybble order. It doesn't matter for this task becasue it does not change the count, but I could play games with where the bits show up. This is endianness at the octet level:

	$ perl -le 'print unpack q(B8), shift' p
	01110000

	$ perl -le 'print unpack q(b8), shift' p
	00001110

