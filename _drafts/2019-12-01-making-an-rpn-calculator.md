---
layout: post
title: Making an RPN calculator
categories:
tags:
stopwords:
last_modified:
original_url:
---


git@github.com:enhydra/perl_rpn.git


#!perl
use v5.30;
use strict;
use feature qw(signatures);
no warnings qw(experimental::signatures);

use Curses;
use Scalar::Util qw(looks_like_number);


initscr();
END { endwin() }
our $win = Curses->new;

my %Operations;

setup_operations( \%Operations );

while( <<>> ) {
	state @stack;
	chomp;

	if( looks_like_number($_) ) {
		push @stack, $_
		}
	elsif( exists $Operations{$_} ) {
		push @stack, $Operations{$_}->( \@stack );
		}

	draw_stack( \@stack );
	}

sub setup_operations ( $operations ) {
	$operations->{'+'} = sub ( $s ) {   pop( @$s ) + pop( @$s ) };
	$operations->{'-'} = sub ( $s ) { - pop( @$s ) + pop( @$s ) };
	$operations->{'*'} = sub ( $s ) {   pop( @$s ) * pop( @$s ) };
	$operations->{'/'} = sub ( $s ) { my $d = pop( @$s ); pop( @$s ) / $d };
	$operations->{'%'} = sub ( $s ) { my $d = pop( @$s ); pop( @$s ) % $d };
	}

sub draw_stack ( $stack ) {
	foreach( 0 .. 6 ) {

		}

	}
