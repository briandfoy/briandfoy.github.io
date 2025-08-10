---
layout: post
title: Data::Dumper's surprising side effect with Useqq
categories: perl
tags: data-dumper
stopwords:
last_modified:
original_url:
---

I ran across some unexpected output from [Data::Dumper](https://perldoc.perl.org/Data::Dumper), and it turns out that this is already an issue in [Perl/perl5#19449](https://github.com/Perl/perl5/issues/19449). I don't think [Data::Dumper](https://perldoc.perl.org/Data::Dumper) will change, but if you realize that the `Useqq` setting has unintended side effects, you don't have to worry about seeing those unintended side effects.

<!--more-->

# Where I go down the wrong path

Most of the problem is that the output leads to a red herring, perhaps when it shouldn't. In my case, I didn't initially consider that [Data::Dumper](https://perldoc.perl.org/Data::Dumper) would be doing anything weird, so I thought I must be doing something weird. That assumption is usually correct, so it might be the wrong way to think but it's a useful way to think.

First, I spend a lot of time testing Mojolicious things, so I have [Mojo::Util](https://metacpan.org/pod/Mojo::Util) because it makes nice things nicer (and unpleasant things more pleasant). Start with [Data::Dumper](https://perldoc.perl.org/Data::Dumper):

{% highlight text %}
$ perl -MData::Dumper -lE "say Dumper({'abc' => '123', 'xyz' => '987'})"
$VAR1 = {
          'xyz' => '987',
          'abc' => '123'
        };
{% endhighlight %}

That's really nice, although many people may not find it that surprising because they don't remember the Before Times. But, there are some things that are unpleasant. First, the keys are not sorted, which makes it hard to find the key you want if there are many keys. Second, Perl has had hash randomization for a long time so they don't come out the same way every time, so another run gives a different order:

{% highlight text %}
$ perl -MData::Dumper -lE "say Dumper({'abc' => '123', 'xyz' => '987'})"
$VAR1 = {
          'abc' => '123',
          'xyz' => '987'
        };
{% endhighlight %}

And, although I don't ever really noticed the `$VAR1` becasue I go directly to the bit of data I want to see, it's still a bit ugly. [Mojo::Util](https://metacpan.org/pod/Mojo::Util) makes that look a bit nicer:

{% highlight text %}
$ perl -MMojo::Util=dumper -lE "say dumper({'abc' => '123', 'xyz' => '987'})"
{
  "abc" => 123,
  "xyz" => 987
}
{% endhighlight %}

That looks nicer, has reproducible output, takes up less space, and so on. But, I had another thing going on in my code where I was serializing some JSON incorrectly (or so I thought) where a string of digits was turned into a JSON number.

But, notice the other thing that happened in the `dumper` output. There are no longer quotes around the numbers. I now know this is a weird thing with [Data::Dumper](https://perldoc.perl.org/Data::Dumper), but when I was debugging I didn't know why `Dumper` quoted the numbers (parts of the code outside the Mojo part), and `dumper`, which is also [Data::Dumper](https://perldoc.perl.org/Data::Dumper), didn't quote these. Did something happen to the values between those calls? If something is doing math (maybe like `sprintf "%5d", $zip_code`?), I probably need to fix that.

As such, I started throwing around `dumper` statements to see where the data switch from being quoted to not being quoted. What happened to my data? But, every `dumper` call shows it quoted.

# A short digression, just for fun

I still thought I must be doing something wrong, so I reached for [Devel::Peek](https://metacpan.org/pod/Devel::Peek) so I could look at what's set in the scalar values (`SV`) in the perl guts. This turns out to be irrelevant to this situation, but I didn't know it at the time:

{% highlight perl %}
use v5.10;

use Devel::Peek;

my $n = '7654';
say STDERR "As string\n=========";
Dump($n);

say STDERR "\nAs new number\n=========";
Dump($n+0);

say STDERR "\noriginal var again\n=========";
Dump($n);
{% endhighlight %}

Here's the output. The first shows the scalar value when its data have only been a string (quoted string assignement). There's a pointer value, `PV`, and that's it.

The second shows the value created by using `$n` in a numeric context (`$n+0`). It has an integer value (`IV`) and no `PV`. The third shows `$n` after it was used as a number. `perl` had to convert its string value into a number to do the numeric operation, so it kept the result of that conversion so it doesn't have to do it again. Now the `SV` has a `PV` and an `IV` (a dualvar):

{% highlight text %}
As string
=========
SV = PV(0x14c80b690) at 0x14c82dcd0
  REFCNT = 1
  FLAGS = (POK,IsCOW,pPOK)
  PV = 0x600003b18150 "7654"\0
  CUR = 4
  LEN = 16
  COW_REFCNT = 1

As new number
=========
SV = IV(0x14d008310) at 0x14d008320
  REFCNT = 1
  FLAGS = (PADTMP,IOK,pIOK)
  IV = 7654

original var again
=========
SV = PVIV(0x14c82ae20) at 0x14c82dcd0
  REFCNT = 1
  FLAGS = (IOK,POK,IsCOW,pIOK,pPOK)
  IV = 7654
  PV = 0x600003b18150 "7654"\0
  CUR = 4
  LEN = 16
  COW_REFCNT = 1
{% endhighlight %}

# Back to dumper

But here's `dumper`, which is [Data::Dumper](https://perldoc.perl.org/Data::Dumper) in its object form with several features enabled:

{% highlight perl %}
sub dumper { Data::Dumper->new([@_])->Indent(1)->Sortkeys(1)->Terse(1)->Useqq(1)->Dump }
{% endhighlight %}

The `Indent` and `Terse` make the output less yucky, and the `Sortkeys` make it easy to find keys. All of those are fine because I went through all the permutations to see who was doing what. It's that `Useqq` that is being weird:

{% highlight perl %}
use v5.10;

use Data::Dumper;

my $data = {
    luggage  => '12345',
    zip_code => '02021',
    long     => '123456789',
    negative => '-123456789',
    longer   => '1234567890',
    };

say 'DEFAULT: ' . Dumper( $data );

foreach ( qw(0 1) ) {
    local $Data::Dumper::Useqq = $_;
    say "Useqq $Data::Dumper::Useqq: " . Dumper( $data );
    }
{% endhighlight %}

The output has three groups, where the first two are the same. These first two quote everything and use single quotes:

{% highlight text %}
DEFAULT: $VAR1 = {
          'negative' => '-123456789',
          'luggage' => '12345',
          'zip_code' => '02021',
          'long' => '123456789',
          'longer' => '1234567890'
        };

Useqq 0: $VAR1 = {
          'negative' => '-123456789',
          'luggage' => '12345',
          'zip_code' => '02021',
          'long' => '123456789',
          'longer' => '1234567890'
        };

Useqq 1: $VAR1 = {
          "negative" => -123456789,
          "luggage" => 12345,
          "zip_code" => "02021",
          "long" => 123456789,
          "longer" => "1234567890"
        };
{% endhighlight %}

The third group, where `$Data::Dumper::Useqq` is true, shows some oddities. Some of the numbers are quoted (and with double quotes), but some aren't. Why? In `Data::Dumper::_dump`, there's this branch in `_dump`:

{% highlight text %}
538:     elsif ($val =~ /^(?:0|-?[1-9][0-9]{0,8})\z/) { # safe decimal number
539:        $out .= $val;
550:      }
{% endhighlight %}

What doesn't get quoted?

* `0` by itself
* strings starting with a non-zero decimal digit, up to nine digits, with optional `-` sign (but not `+` sign)

# Why might we want this?

Okay, so now I know that happens. It often helps to consider these are decisions that might have made sense at one point, even if we find out later they weren't the right decision.

But, I didn't ask for [Data::Dumper](https://perldoc.perl.org/Data::Dumper) to think about numbers and strings. I told it to use double quotes instead of single quotes, but it's decided to use no quotes. What use might that be?

I don't know why this specialized handling is here. At best, it's trying to do something it didn't fully commit to (allowing 32-bit values to be represented as unquoted numbers). Back in the day, we thought that [Data::Dumper](https://perldoc.perl.org/Data::Dumper) would be a way to serialize data and bring it back into a program. Yes, there was a time before YAML and JSON where this was really easy, and when *perl* was not 64-bit everywhere.

If that's the case, either do it correctly or not at all. Why is the cut off 9 digits? It would be much easier to see the pattern if the cut off matched the true data boundaries:

{% highlight text %}
$ perl -MData::Dumper -lE '$Data::Dumper::Useqq = 1; say Dumper({q(abc) => q(999999999)})'
$VAR1 = {
          "abc" => 999999999
        };

$ perl -MData::Dumper -lE '$Data::Dumper::Useqq = 1; say Dumper({q(abc) => q(1000000000)})'
$VAR1 = {
          "abc" => "1000000000"
        };

$ perl -MData::Dumper -lE '$Data::Dumper::Useqq = 1; say Dumper({q(abc) => q(4294967295)})'
$VAR1 = {
          "abc" => "4294967295"
        };
{% endhighlight %}

Notice that perl can handle very large numbers, but at some point the format output is going to change it and the numeric representation is not longer the same as the string and count round trip. That's probably why the ancient code wants to stay under `0xFFFF_FFFF`:

{% highlight text %}
$ perl -lE 'say 0xFF_FF_FF_FF'
4294967295

$ perl -lE 'say 0xFF_FF_FF_FF_FF'
1099511627775

$ perl -lE 'say 0xFF_FF_FF_FF_FF_FF_FF'
72057594037927935

$ perl -lE 'say 0xFF_FF_FF_FF_FF_FF_FF_FF'
18446744073709551615

$ perl -lE 'say 0xFF_FF_FF_FF_FF_FF_FF_FF_FF'
4.72236648286965e+21
{% endhighlight %}

First, I don't want [Data::Dumper](https://perldoc.perl.org/Data::Dumper) to make this decision. Just leave it as a string. Doing it correctly is a pain in the ass. And, there's really no reason to do it anyway.

But, if [Data::Dumper](https://perldoc.perl.org/Data::Dumper) wants to change strings to number, make that a different setting.

# Another bonus just for fun

[Data::Dumper](https://perldoc.perl.org/Data::Dumper) can be coaxed into outputing JSON by using the double quotes and changing the pair separator to a colon:

{% highlight perl %}
use v5.10;

use Data::Dumper;

my $data = {
    luggage  => '12345',
    zip_code => '02021',
    long     => '123456789',
    negative => '-123456789',
    longer   => '1234567890',
    };

$Data::Dumper::Pair = ': ';
$Data::Dumper::Terse = 1;
$Data::Dumper::Useqq = 1;
say Dumper( $data );
{% endhighlight %}

This output is valid JSON, which requires double quotes:

{% highlight text %}
{
  "negative": -123456789,
  "luggage": 12345,
  "longer": "1234567890",
  "long": 123456789,
  "zip_code": "02021"
}
{% endhighlight %}

Send it into `jq` and it comes out again:

{% highlight json %}
$ perl test.pl | jq -r .
{
  "zip_code": "02021",
  "longer": "1234567890",
  "luggage": 12345,
  "negative": -123456789,
  "long": 123456789
}
{% endhighlight %}

However, JSON distinguishes between numbers and strings, so things such as OpenAPI might reject some JSON that has numeric values that it expected to be strings.

# The conclusion

[Data::Dumper](https://perldoc.perl.org/Data::Dumper) has been like this virtually forever, so the best thing might be to leave it alone and simply to realize this is what it does.
