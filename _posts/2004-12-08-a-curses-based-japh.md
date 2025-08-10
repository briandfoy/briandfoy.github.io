---
layout: post
title: A curses-based japh
categories: perl programming
tags: rescued-content japh video
stopwords:
last_modified:
original_url: https://www.perlmonks.org/?node_id=413324
---

*I originally posted this on [Perlmonks](https://www.perlmonks.org/?node_id=413324),
and now I've added a video of it in action*

<!--more-->

<iframe src="https://player.vimeo.com/video/387975820" width="640" height="417" frameborder="0" allow="autoplay; fullscreen" allowfullscreen></iframe>
<p><a href="https://vimeo.com/387975820">Curses-based Perl JAPH (Just another Perl hacker)</a> from <a href="https://vimeo.com/briandfoy">brian d foy</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

Here's the code, with is nothing fancy and a bit verbose, which is just
the opposite of the spirit of the ["Just another Perl hacker,"](https://en.wikipedia.org/wiki/Just_another_Perl_hacker) ethos.

{% highlight perl %}
#!/usr/bin/perl -w
use strict;
use warnings;

use Curses;

my @LETTERS = ( 'A' .. 'Z', 'a' .. 'z', ',', ' ' );
$SIG{TERM} = sub { exit };

my $STRING = 'Just Another Perl Hacker,';
my $LENGTH = length $STRING;

initscr;

my $ROW    = ( LINES() % 2 ? LINES() - 1 : LINES() ) / 2;
my $COLUMN = ( COLS() % 2 ? COLS() - 1 : COLS() ) / 2 -
    ( $LENGTH % 2 ? $LENGTH - 1 : $LENGTH ) / 2;
my $END_COL = $COLUMN + $LENGTH - 1;

my @array;
my $count = 0;

my $x = random( LINES );
my $y = random( COLS );
my $letter = sub { $LETTERS[ int( rand( @LETTERS ) ) ] };

while( 1 ) {
    my $x      = &$x;
    my $y      = &$y;
    my $letter = &$letter;

    next if( $x == $ROW and $array[$y] );

    if( $x == $ROW and $y >= $COLUMN and $y <= $END_COL
        and substr( $STRING, $y - $COLUMN, 1 ) eq $letter ) {
        $array[$y]++;
        $count++;
        }

    put_letter( $letter, $x, $y );

    if( $count == $LENGTH ) { @LETTERS = ' '; }
    }

sub random {
    my $range = shift;
    sub { int( rand($range) ) }
    }

sub put_letter {
    my ($letter, $x, $y) = @_;
    addch( $x, $y, $letter );
    refresh;
    }
{% endhighlight %}
