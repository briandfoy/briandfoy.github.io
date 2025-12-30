---
layout: post
title: Perl v5.36 broke the -X switch
categories: perl
tags:
stopwords:
last_modified:
original_url:
---

For a few years, I've been using perl's `-X` switch to turn off all warnings. I don't want those in production, but I do want them in development.  And, I want those two to use the same source, so I don't get to edit away a `use warnings`.

[The `-X` switch is broken](https://github.com/Perl/perl5/issues/21427) in Perls v5.36 and v5.38. It should be fixed for v5.40.

<!-- more -->

## Adding non-numbers

Here's a small program to add up a list of numbers. It uses the numeric addition operator, and with warnings enabled, that calls out non-numeric operands:

{{% highlight perl %}}
use warnings;
use List::Util qw(reduce);
printf "Sum is %d\n", reduce { $a + $b } @ARGV;
{{% end highlight %}}

Here are a few runs. The first uses all decimal numbers for its arguments and issues no warnings. The second sneaks in the argument `m`. Now the numeric addition operation thinks it doesn't have a number and warns. The third run uses the same arguments as the second, but disables all warnings with `-X`. Here are some runs with the system perl on macOS:

{{% highlight text %}}
$ perl5.30.3 sum.pl 1 2 3
Sum is 6

$ perl5.30.3 sum.pl 1 2 m
Argument "m" isn't numeric in addition (+) at warnings.pl line 5.
Sum is 3

$ perl5.30.3 -X sum.pl 1 2 m
Sum is 3
{{% end highlight %}}

When I'm running a program from a cronjob (or maybe the equivalent in systemd), I can include the `-X` as part of the `perl` command:

{{% highlight text %}}
PERL=perl -X

13 7 * * * ${PERL} periodic-job.pl
{{% end highlight %}}

I have to do it this way because perl does not allow `-X` in `PERL5OPT`, the environment variable that automatically adds command-line options to a perl invocation.

## More complex problems

That's a simple error, but consider something more complex. Perhaps a new perl that you haven't tested against added a new deprecation warning for something your legacy program uses.

This danger is generally why I've only wanted warnings only during development. Once the thing is in production, I've either fixed all the warnings or ignored the ones I didn't care about. When I deploy, it's warnings-free and my logs aren't flooded with any warnings. A new `perl` might change that, and that new perl might be out of my control (which is why we've also suggested that you don't use the system perl for your project). Now the logs are flooded with warnings, and if I've stopped paying attention because it's been warning-free for a long time, I might fill up that log file and that disk. That actually happened once, and I've been shy about that situation since.

## Broken for implicitly enabled warnings

But there's now a problem. Perl v5.36 enables warnings for me if I declare the minimum version with `use`. My program changes to this:

{{% highlight perl %}}
use v5.36;
use List::Util qw(reduce);
printf "Sum is %d\n", reduce { $a + $b } @ARGV;
{{% end highlight %}}

But now I can't turn off warnings with `-X`. This is a bug ([GitHub #21427](https://github.com/Perl/perl5/issues/21427)) that's fixed for v5.40.0 (but not v5.36.3 or v5.38.2):

{{% highlight text %}}
$ perl5.36.3 -X sum.pl 1 2 m
Argument "m" isn't numeric in addition (+) at warnings.pl line 3.
Sum is 3

$ perl5.38.2 -X sum.pl 1 2 m
Argument "m" isn't numeric in addition (+) at warnings.pl line 3.
Sum is 3

$ perl5.38.1 -X sum.pl 1 2 m
Argument "m" isn't numeric in addition (+) at warnings.pl line 3.
Sum is 3

$ perl5.40.0 -X sum.pl 1 2 m
Sum is 3
{{% end highlight %}}



