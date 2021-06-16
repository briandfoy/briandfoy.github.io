---
layout: post
title: Sunsetting Perl's vars pragma
categories:
tags:
stopwords:
last_modified:
original_url:
---

After Sawyer X gave his Perl 5 Porters status talks at conferences this summer, I got a couple of questions about the <code>vars</code> pragma disappearing from Perl.

The <code>vars</code> pragma is still there and as far as I know, it's going to stay there. However, <a href="https://github.com/Perl/perl5/commit/4d457ce0560741d33b57646b4da5e244cee8f8ef#diff-b1508d462171f45972ccee5ef2fb0e82">v5.18 changed its documentation to discourage it</a>, even though it had previously been <a href="https://github.com/Perl/perl5/commit/86a9aef26fb49fa244fdb909e2ecabafc79006a1#diff-b1508d462171f45972ccee5ef2fb0e82">marked as "obsolete"</a> way back in 2000.

However, some changes in v5.28 <a href="https://rt.perl.org/Public/Bug/Display.html?id=132077
">removed <code>use vars</code></a> in favor of <code>our</code> in core modules.

<h2>Declaring package variables</h2>

In <a href="https://www.learning-perl.com">Learning Perl</a>, we write about the ways that you can declare a package ("global") variable so <code>strict</code> doesn't complain:

<ul>
<li>Use the full package specification, such as <code>$main::global</code>
<li>Pre-declare the variable with <code>vars</code>
<li>Declare (and perhaps initialize) the variable with <code>our</code>
</ul>

Lexical variables was a major addition to Perl 5.0. Before that, we only had package variables. Everything was global as long as you knew the package it was in. This was back in the day when the package separator was still <code>'</code>.

<code>our</code> was added later, in v5.006, as a complement to <code>my</code>. Since we had a way to declare lexicals, Perl added a way to declare packages too.


<h2>Drawbacks of vars()</h2>

The <a href="https://perldoc.perl.org/vars.html">vars</a> (and similarly, <a href="https://perldoc.perl.org/subs.html">subs</a>) don't behave like other pragmas.

Most pragmas are lexically scoped. Their effect exists only in their scope and they are disable their effect with <code>no</code>:

<pre class="brush:perl">
use warnings;
my $empty;

print "1. $empty"; # uninitialized warning!

{
print "2. $empty"; # no warning!
no warnings;  # turn off warnings in this scope
print "3. $empty"; # no warning!
}

print "4. $empty"; # uninitialized warning again!
</pre>

This outputs an uninitialized value four times, but warns only three times. The <code>print</code> on line 9 doesn't warn because that pragma was temporarily turned off. At the end of the scope, the pragma reverts to its previous setting:

<pre class="brush:perl">
1. 2. 3. 4.
Use of uninitialized value $empty in concatenation (.) or string at /Users/brian/Desktop/test.pl line 4.
Use of uninitialized value $empty in concatenation (.) or string at /Users/brian/Desktop/test.pl line 7.
Use of uninitialized value $empty in concatenation (.) or string at /Users/brian/Desktop/test.pl line 12.
</pre>

The <a href="https://perldoc.perl.org/vars.html">vars</code> pragma is different. Use it anywhere in the file and it applies to any variable use that comes after it because the parser knows that you want to use that variable:

<pre class="brush:perl">
use strict;

{ # this scope doesn't matter
use vars qw($fred);
}

$fred = 'Flintstone';

print $fred;
</pre>

You also can't turn it off. This compiles and runs, but despite the <code>no vars</code>, it still outputs <code>Flintstone</code>:

<pre class="brush:perl">
use strict;

our $fred = 'Flintstone';

{
no vars qw($fred);
print $fred;
}
</pre>


--------------

#!perl

use v5.10;

say $^V;

use vars qw($foo);
$foo = 123;
say $foo;

__END__

2017-May-31

2018-Apr-20


1218f5ba79  Fri Nov 10 23:01:27 2017 -0600 (1 year, 9 months ago)	 Todd Rinaldo: Remove use vars from B::Deparse
d8f3f638c2  Sat Nov 11 01:08:34 2017 -0600 (1 year, 9 months ago)	 Todd Rinaldo: [MERGE] Remove unnecessary use of 'use vars'
9b78f2106b  Sat Nov 11 01:03:26 2017 -0600 (1 year, 9 months ago)	 Todd Rinaldo: Document the removal of use vars from sources
e64a0c479a  Wed Sep 13 16:52:16 2017 -0600 (1 year, 9 months ago)	 Nicolas R: Replace multiple 'use vars' by 'our' in regen.
83461ff883  Sat Nov 11 00:42:36 2017 -0600 (1 year, 9 months ago)	 Todd Rinaldo: Replace multiple 'use vars' by 'our' in t
3d3a0a8a5e  Tue Sep 12 13:20:25 2017 -0600 (1 year, 9 months ago)	 Nicolas R: Replace multiple 'use vars' by 'our' in utils
fd55ca4fb1  Tue Sep 12 13:20:25 2017 -0600 (1 year, 9 months ago)	 Nicolas R: Replace multiple 'use vars' by 'our' in ext
cc01160e81  Tue Sep 12 13:20:25 2017 -0600 (1 year, 9 months ago)	 Nicolas R: Replace multiple 'use vars' by 'our' in lib
1a58b39af8  Tue Sep 12 13:20:25 2017 -0600 (1 year, 9 months ago)	 Nicolas R: Replace multiple 'use vars' by 'our' in dist
