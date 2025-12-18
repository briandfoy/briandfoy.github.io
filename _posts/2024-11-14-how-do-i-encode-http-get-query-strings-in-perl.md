---
layout: post
title: How do I encode HTTP GET query strings in Perl?
categories:
tags:
stopwords:
last_modified:
original_url: https://stackoverflow.com/a/79850071/2766176
---

*I wrote this answer for a [Stackoverflow question](https://stackoverflow.com/q/449158/2766176), but didn't publish it for ages.*

At the time of this question (January 2009), [Mojolicious](https://metacpan.org/pod/Mojolicious) was about a year away, I think, so [LWP::UserAgent](https://metacpan.org/pod/LWP::UserAgent) seemed like a reasonable choice. CPAN had yet to present anything better. So, the answers here are correct then, and correct now in that they do the right thing, but today, you shouldn't have to think about this.

<!--more-->

The short, modern answer is that [Mojolicious](https://mojolicious.org) does this with a cleaner, more integrated interface because it doesn't have the long history it has to support. First, it started much later, and second, it is willing to break backward compatibility (see [several of the FAQ answers](https://docs.mojolicious.org/Mojolicious/Guides/FAQ)).

## Why you wouldn't use Mojolicious

There are some reasons you would not use [Mojolicious](https://mojolicious.org), though. Since it is willing to break backward compatibility, it will not support all versions of Perl. I think the current minimum version is Perl v5.16, which is still quite a chunk of time, but if your ancient perl is older, you are out of luck.

Also, [Mojolicious](https://mojolicious.org) will change things, so a couple times a year, you might have to update some minor things within the same major release. For example, `Mojo::File` changed the `spurt` method to `spew`. The former works (for a while), but with deprecation warnings. And, [Mojolicious](https://mojolicious.org) won't let deprecations go on for decades, as Perl has historically done.

Finally, don't go through a legacy application and rip out LWP until you have all the free time in the world. It's nothing to do with LWP or Mojolicious, but any big change tends to mess with everything. Don't mess with what's working.

## There is no one best

I'm not really concerned about clarifying "best practices" for this answer, but it's one of the things I like to bring up when I see people use that term. There's only best in a certain context. No context, no best. There's getting work done.

But in this context, "best" includes using proven libraries so you don't recreate all of the bugs.

## LWP's deficient interface

LWP, or libwww-perl, was one of the first comprehensive libraries dealing with the web, and its first version was released around the same time as Perl 5. That is, it began when we hadn't developed better ideas about employing Perl for some of these problems.

LWP constantly banged up against interface issues where there was a common situation, but couldn't easily support it, so it pushed that work too high in the chain of abstraction. For dealing with anything beyond the simplest requests, you actually had to do a lot of work.

For example, the example code shows you call a method and you get back a response object:

    my $response = $ua->get($url, %extra_headers);

I often want to inspect the request object to verify what was sent, confirm I gave it everything it needed, and confirm it was all in the right place. But, I have to do that work:

    use HTTP::Request::Common qw(GET);
    my $request = GET $url, %extra_headers;
    my $reponse = $ua->request( $request );

But `GET` has a deficient interface. It's the same as the arguments to the `get()` method, which means there's no way to give it query fields. Again, that work is pushed up to the application, rather than hidden in the thing that knows about HTTP and URLs.

However, the other HTTP verbs in the module have a `Content` field, which really means that if they see a key within all the key-value pairs named `Content`, they will not add that as an HTTP header and do something else with it. That something else does the same thing in `GET`, but since `GET` requests typically don't have message bodies, the docs simply ignore that as an argument. `GET` could have taken that same value just as `POST` does and turn a hashref into the right thing, but it doesn't.

As a side note, this is one of the reasons you should use containers (references to arrays or hashes) to separate things that don't go together and don't have a definite position in the argument list. Even then, after three or so arguments, positional parameters become a huge pain.

## The Mojolicious way

Now, contrast this with [Mojolicious](https://mojolicious.org), which came much later, with the benefit of hindsight. Its interface is much better, and unified across the various pieces it needs:

	use Mojo::UserAgent;

	my $ua = Mojo::UserAgent->new;
	my $url = 'https://example.com';
	my $query = {
		foo     => [qw(1 2)],
		bar     => 2,
		snowman => chr(0x2603),
		};
	my $tx = $ua->get( $url => $headers => form => $query );

	# they are all there as a tidy package
	my $request = $tx->req;
	my $reponse = $tx->res;

First, the `get` returns a transaction (`$tx`) that wraps the original request and the response (and maybe more requests and responses in a chain of redirects).

I often find myself doing things with the base url with different queries and with the Mojo interface, I don't have to rebuild the entire URL each time:

	use Mojo::UserAgent;
	my $ua = Mojo::UserAgent->new;

	my $url = '...';
	foreach my $query ( get_queries(...) ) {
		my $tx = $ua->get( $url => $headers => form => $query );
		...
		}

Next, the `get` has a much more rich interface. I can pass `get` different things to add headers, add query fields as a Perl hash, and many other things. Indeed, I can even create my own content generators (look for `add_generator` ):

	my $tx = $ua->get( $url => $headers => my_custom_transformer => $ds );

Now I don't have to know all sorts of low-level details. I don't have to think about the encodings of anything. It's a hidden detail that just works.

