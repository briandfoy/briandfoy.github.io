---
layout: post
title: When should I use the & to call a Perl subroutine?
categories: programming
tags: perl
stopwords:
last_modified:
original_url: https://stackoverflow.com/a/1348945/2766176
---

I'm a frequent abuser of `&`, but mostly because I'm doing weird interface stuff. If you don't need one of these situations, don't use the `&`. Most of these are just to access a subroutine definition, not call a subroutine. It's all in [perlsub](http://perldoc.perl.org/perlsub.html).

1. Taking a reference to a named subroutine. This is probably the only common situation for most Perlers:

	my $sub = \&foo;

2. Similarly, assigning to a typeglob, which allows you to call the subroutine with a different name:

	*bar = \&foo;

3. Checking that a subroutine is defined, as you might in test suites:

	if( defined &foo ) { ... }

4. Removing a subroutine definition, which shouldn't be common:

	undef &foo;

5. Providing a dispatcher subroutine whose only job is to choose the right subroutine to call. This is the only situation I use `&` to *call* a subroutine, and when I expect to call the dispatcher many, many times and need to squeeze a little performance out of the operation:

	sub figure_it_out_for_me {
		# all of these re-use the current @_
		  if( ...some condition... ) { &foo     }
		elsif( ...some other...     ) { &bar     }
		else                          { &default }
		}

6. To jump into another subroutine using the current argument stack (and replacing the current subroutine in the call stack), an unrare operation in dispatching, especially in `AUTOLOAD`:

	goto &sub;

7. Call a subroutine that you've named after a Perl built-in. The `&` always gives you the user-defined one. That's <A href="http://www.learning-perl.com/2013/05/why-we-teach-the-subroutine-ampersand/">why we teach it in <i>Learning Perl</i></a>. You don't really want to do that normally, but it's one of the features of `&`.

There are some places where you could use them, but there are better ways:

1. To call a subroutine with the same name as a Perl built-in. Just don't have subroutines with the same name as a Perl built-in. Check [perlfunc](http://perldoc.perl.org/perlfunc.html) to see the list of built-in names you shouldn't use.

2. To disable prototypes. If you don't know what that means or why you'd want it, don't use the `&`. Some black magic code might need it, but in those cases you probably know what you are doing.

3. To dereference and execute a subroutine reference. Just use the `->` notation.


