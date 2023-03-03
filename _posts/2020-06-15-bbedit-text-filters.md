---
layout: post
title: BBEdit Text Filters
categories: programming consumer-software perl macos
tags: bbedit
stopwords:
last_modified:
original_url:
---

BBEdit allows you to make your own text processing programs. It gives your program the contents of a selection then replaces that selection with the output of your program. I also wrote about these in [BBEdit Text Filters in Perl 6](https://www.learningraku.com/2017/01/17/bbedit-text-filters-in-perl-6/).

<!--more-->

These show up in the _Text > Apply Text Filters_ menu item, but I tend to use them from the Text Filters palette (_Windows > Palettes > Text Filters_).

![](/images/bbedit_text_filters/palette.png)

These programs go in _Application Support/BBEdit/Text Filters_ folder; I keep mine in Dropbox so it's common across all my Macs. These can be AppleScript or Text Automator actions, but they can also be Unix scripts. I tend to use Perl, but I have some in Python and Ruby too.

Here's a Perl program that finds the `=>` in the selection and aligns them:

	#!/Users/brian/bin/perls/perl-latest
	use warnings;
	use strict;
	use v5.26;

	my( $longest, @lines ) = 0;

	while ( <> ) {
		push @lines, [ split /\s+=>\s+/, $_, 2 ];
		if( $lines[-1]->@* == 2 ) {
			my( $key, $length ) = map { $_, length } $lines[-1][0];
			$longest = $length if $length > $longest;
			}
		}

	foreach my $line ( @lines ) {
		if( @$line > 1 ) {
			printf "%*s => %s", -$longest, @$line;
			}
		else {
			print @$line
			}
		}

It takes this hash, where the arrows are not aligned:

	my %hash = (
		common => 'sea otter',
		genus => 'Enhydra',
		species => 'lutris',
		);

And turns it into this hash, where the arrows are aligned:

	my %hash = (
		common  => 'sea otter',
		genus   => 'Enhydra',
		species => 'lutris',
		);

I actually used the text filter to turn the unaligned hash into the aligned one.

My filter can be as complicated as I like it to be. Here's one that reads the entire selection and attempts to pretty print JSON:

	#!/Users/brian/bin/perls/perl-latest
	use warnings;
	use strict;
	use v5.26;

	use JSON;

	# this is already UTF-8
	my $selection = do { local $/; <> };

	# now I need octets
	open my $string_fh, '>:encoding(UTF-8)', \my $octets;
	print {$string_fh} $selection;
	close $string_fh;

	my $json = JSON->new;
	my $perl = $json->decode( $octets );

	print $json->pretty->encode($perl);

