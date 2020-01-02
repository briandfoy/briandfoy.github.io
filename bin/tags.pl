#!/usr/bin/perl
use v5.10;
use strict;
use warnings;

use File::Spec::Functions;

my @tags =
	grep { state %Seen; ! $Seen{$_}++ }
	map {
		say "File is $_";
		open my $fh, '<:utf8', $_ or warn "Could not open <$_>: $!";
		my $in_header = 0;
		my @tags;
		while( <$fh> ) {
			chomp;
			$in_header = ! $in_header if /\A---$/;
			next unless $in_header;
			next unless /\Atags:\s*(.*)/;
			say "Passed through: $_ -> $1";
			@tags = split /\s+/, $1;
			last;
			}

		@tags;
		}
	glob( "_posts/*.md" );

say "tags are @tags";

my $dir = 'tag';
mkdir $dir unless -d $dir;

foreach my $tag ( @tags ) {
	my $path = catfile( $dir, "$tag.md" );
	next if -e $path;

	open my $fh, '>:utf8', $path or do {
		warn "Could not open file <$path>: $!\n";
		next;
		};

	print {$fh} <<~HERE;
		---
		layout: tagpage
		title: "Tag: $tag"
		tag: $tag
		---
		HERE
	}
