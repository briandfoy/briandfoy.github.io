---
layout: post
title: Sunsetting Perl's vars pragma
categories: perl
tags:
stopwords:
last_modified:
original_url:
---

After Sawyer X gave his Perl 5 Porters status talks at conferences this summer, I got a couple of questions about the `vars` pragma disappearing from Perl.

<!--more-->

The `vars` pragma is still there and as far as I know, it's going to stay there. However, [v5.18 changed its documentation to discourage it](https://github.com/Perl/perl5/commit/4d457ce0560741d33b57646b4da5e244cee8f8ef#diff-b1508d462171f45972ccee5ef2fb0e82), even though it had previously been [marked as "obsolete"](https://github.com/Perl/perl5/commit/86a9aef26fb49fa244fdb909e2ecabafc79006a1#diff-b1508d462171f45972ccee5ef2fb0e82) way back in 2000.

However, some changes in v5.28 [removed `use vars`](https://rt.perl.org/Public/Bug/Display.html?id=132077) in favor of `our` in core modules.

<h2>Declaring package variables</h2>

In [Learning Perl](https://www.learning-perl.com), we write about the ways that you can declare a package ("global") variable so `strict` doesn't complain:

* Use the full package specification, such as `$main::global`
* Pre-declare the variable with `vars`
* Declare (and perhaps initialize) the variable with `our`

Lexical variables were a major addition to Perl 5.0. Before that, we only had package variables. Everything was global as long as you knew the package it was in. This was back in the day when the package separator was still `'`.

`our` was added later, in v5.006, as a complement to `my`. Since we had a way to declare lexicals, Perl added a way to declare packages too.


## Drawbacks of vars()

The [vars](https://perldoc.perl.org/vars.html) (and similarly, [subs](https://perldoc.perl.org/subs.html)) don't behave like other pragmas.

Most pragmas are lexically scoped. Their effect exists only in their scope and they are disable their effect with `no`:

```perl
use warnings;
my $empty;

print "1. $empty"; # uninitialized warning!

{
print "2. $empty"; # no warning!
no warnings;  # turn off warnings in this scope
print "3. $empty"; # no warning!
}

print "4. $empty"; # uninitialized warning again!
```

This outputs an uninitialized value four times, but warns only three times. The `print` on line 9 doesn't warn because that pragma was temporarily turned off. At the end of the scope, the pragma reverts to its previous setting:

```perl
1. 2. 3. 4.
Use of uninitialized value $empty in concatenation (.) or string at /Users/brian/Desktop/test.pl line 4.
Use of uninitialized value $empty in concatenation (.) or string at /Users/brian/Desktop/test.pl line 7.
Use of uninitialized value $empty in concatenation (.) or string at /Users/brian/Desktop/test.pl line 12.
```

The [vars](https://perldoc.perl.org/vars.html) pragma is different. Use it anywhere in the file and it applies to any variable use that comes after it because the parser knows that you want to use that variable:

```perl
use strict;

{ # this scope doesn't matter
use vars qw($fred);
}

$fred = 'Flintstone';

print $fred;
```

You also can't turn it off. This compiles and runs, but despite the `no vars`, it still outputs `Flintstone`:

```perl
use strict;

our $fred = 'Flintstone';

{
no vars qw($fred);
print $fred;
}
```
