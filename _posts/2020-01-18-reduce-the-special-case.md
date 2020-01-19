---
layout: post
title: Reduce the Special Case
tags: edge-cases
stopwords:
---

Can I make the edge case look just like the rest of the cases?

Consider this problem where I want to fetch a URL, extract links, then fetch those links.

The first pass on this problem maps the cognitive model into code. I fetch a link and do things, and then I need to start looping. In this way, I prime the pump by providing the initial set of links for the `while` loop to work on. Here's what that might look like with [Mojolicious](http://mojolicious.org):

{% highlight perl %}
use v5.12;

use Mojo::UserAgent;

my $ua = Mojo::UserAgent->new;

my $tx = $ua->get( $ARGV[0] );
my @links = extract_links( $tx );

while( my $this = shift @links ) {
    say "Processing $this";

    my $tx = $ua->get( $this );
    push @links, extract_links( $tx );

    ...; # do something interesting
    }

sub extract_links ( $tx ) {
    my @links = $tx->result
        ->dom
        ->find( 'a' )
        ->map( attr => 'href' )
        ->grep( sub { Mojo::URL->new($_)->scheme =~ /https?/ } )
        ->each;
    }
{% endhighlight %}

But, I know there are extra steps in that code. Not only are there extra steps, but the extra steps at the beginning might not be the same as those inside. Repeated code leads to divergent code.

I already have the array `@links`, so I can put the initial URL in there and let the `while` do the rest:

{% highlight perl %}
use v5.12;

use Mojo::UserAgent;

my $ua = Mojo::UserAgent->new;
my @links = $ARGV[0];
while( my $this = shift @links ) {
    say "Processing $this";

    my $tx = $ua->get( $this );
    push @links, extract_links( $tx );

    ...; # do something interesting
    }

{% endhighlight %}

This still has extra steps because there are two places that I add to `@links`. There has to be something in `@links` for the `while` to start its work. I have this structure because I'm compelled to choose a descriptive variable name for my collection of links.

This makes me aware of another constraint that I've artificially added to the problem. I only deal with one link because I was focused on starting with one link and took the first command line argument.

But should I care about only one link? I write this program and someone else (maybe me!) wants to try it with multiple initial URLs. That's just the argument list and it's a normal array:

{% highlight perl %}
use v5.12;

use Mojo::UserAgent;

my $ua = Mojo::UserAgent->new;
while( my $this = shift @ARGV ) {
    say "Processing $this";

    my $tx = $ua->get( $this );
    push @ARGV, extract_links( $tx );

    ...; # do something interesting
    }

{% endhighlight %}

I don't particularly like using `@ARGV` like that because it represents a different idea that I'm willfully perverting. Perhaps it's a step too far.
