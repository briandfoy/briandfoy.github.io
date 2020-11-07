---
layout: post
title: Perl Traps for Python Programmers
categories:
tags:
stopwords:
last_modified:
original_url: http://blogs.perl.org/users/brian_d_foy/2011/10/perl-traps-for-python-programmers.html
---

Perl and Python come from common roots, and even came out at the same time (1987 and 1991), and Perl even stole Python's object system.



=for TODO

http://wiki.python.org/moin/PerlPhrasebook



* Variables begin with `$`, `@`, or `%` in Perl.
* Many functions take default arguments or have default behavior, and there's not rule that predicts this.
* The last-evaluated expression is the return value.
* Use `say` if you want an implicit newline on the end of each
* Perl has object features, but it is not an object-oriented language where everything has methods.



* In Perl, you call a function with arguments:

    my $string = join('|', qw(Python Perl Ruby) );

In Python, there's likely a main argument with a method to do it:

    new = '|'.join(['Python', 'Perl', 'Ruby'])



* Perl's match operator floats unless you anchor your patten. Python's `re.match()` only matches at the beginning of a line, although `re.search()` has an implicit `.*` at the beginning of the pattern.
* Python's dictionaries are Perl's hashes; however, Perl's hash keys are plain strings.
* In most cases, Perl does not implicitly dereference things (although Perl 5.12 does for some uses of the array and hash operators, but these features were removed).
* Perl can interpolate variable directly into double-quoted strings, but you can also use `sprintf`
* Perl's strings aren't arrays of characters, so you can't use array operators on them.
* Perl's system calls don't automatically throw exceptions, but you can use M<autodie> to do that.
* Python lets you name your arguments in the function signature. Perl has an experimental feature to support this.
* Perl doesn't have lists of lists, but it can have a list of array references.
* Perl's range operator is inclusive on both sides, so `0..9` includes `0` and `9`.
* To overload operators for your objects, use the `M`overload pragma.
