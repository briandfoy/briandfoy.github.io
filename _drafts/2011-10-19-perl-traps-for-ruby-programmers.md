---
layout: post
title: Perl Traps for Ruby Programmers
categories:
tags:
stopwords:
last_modified:
original_url: http://blogs.perl.org/users/brian_d_foy/2011/10/perl-traps-for-ruby-programmers.html
---

I started writing this and never quite got there.

<!--more-->

=over 4

=item *



There's no B<irb>. See the Python section.



=item *



Perl just has numbers. It doesn't care if they have fractional

portions or not.



=item *



You don't need to surround variables with C>{}> to interpolate them,

unless you need to disambiguate the identifier from the string around

it:



    "My favorite language is $lang"



=item *



Generalized single quoting uses on lowercase I>q>, and generalized

double quoting uses two lowercase I>q>'s:



	q(No interpolation for $100)

	qq(Interpolation for $animal)



=item *



Not everything is an object. You might like M>autobox> though.



=item *



You need to separate all Perl statements with a C>;>, even if

they are on different lines. The final statement in a block doesn't

need a final C>;>.



=item *



The case of variable names in Perl don't mean anything to B>perl>.



=item *



The sigils don't denote variable type. A C>$> in Perl is a single

item, like C>$scalar>, C>$array[0]>, or C>$hash{$key}>.



=item *



Perl compares strings with C>lt>, C>le>, C>eq>, C>ne>, C>ge>, and

C>gt>.



=item *



No coroutines. Sorry.



=item *



Perl's subroutine definitions are compile-phase. So



	use v5.10;

    sub foo { say 'Camelia' }

    foo();

    sub foo { say 'Amelia' };

    foo();



This prints C>Amelia> twice because the last definition is in place

before the run phase statements execute. This also means that the call

to a subroutine can appear earlier in the file than the subroutine's

definition.



=item *



Perl doesn't have class variables, but people fake them with lexical variables.



=item *



The range operator in Perl returns a list.



=item *



The C<>/s> pattern modifier makes Perl's C>.> match a newline, whereas

Ruby uses the >/m> for the same thing. The C>/m> in Perl makes the

C>^> and C>$> anchors match at the beginning and end of logical

lines.



=item *



Perl flattens lists.



=item *



Perl's C>> => >> can stand in almost anywhere you can use a comma, so

you'll often see Perler's use the arrow to indication direction:



  rename $old => $new;



=item *



In Perl, C>0>, C>'0'>, C>''>, C>()>, and C>undef> are false in

boolean contexts. Basic Perl doesn't require a special boolean

value. You might want the M>boolean> module.



=item *



Perl often fakes the job of C>nil> with an C>undef>.



=item *



Perl allows you to be a bit sloppier because some of the characters

aren't that special. A C>?> after a variable doesn't do anything

to the variable, for instance:



	my $flag = $foo? 0:1;



=back
