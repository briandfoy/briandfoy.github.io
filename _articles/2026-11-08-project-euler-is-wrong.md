---
layout: post
title: Project Euler is wrong
categories:
tags:
stopwords:
last_modified:
original_url:
status: _drafts
---

Project Euler is not wrong, but you're reading this, so there's that. As with most things

> Project Euler is a series of challenging mathematical/computer programming problems that will require more than just mathematical insights to solve.

And:

> The intended audience include students for whom the basic curriculum is not feeding their hunger to learn, adults whose background was not primarily mathematics but had an interest in things mathematical, and professionals who want to keep their problem solving and mathematics on the cutting edge.

So, yeah, this is fun. Project Euler is fun. It's something to do, for fun.

So here's Problem #3:

> The prime factors of 13,195 are 5, 7, 13 and 29. What is the largest prime factor of the number 600,851,475,143?

The problems aren't presented with any constraints or restrictions. It asks a question and that's it. For example, am I solving the problem if I just ask a search engine or Claude?

## Just look it up

That's not as glib as that sounds. Part of my professional scientific training was how to not do work that has already been done. My first experience with this was the Hooded Nudibranch, *Melibe leonina*, that has a very strong watermelon odor. As a student product, I wanted to isolate that chemical. But, going through a literature search, I found it had been done a couple of years earlier ([Ayer, S.W., Andersen, R.J. Degraded monoterpenes from the opisthobranch molluscMelibe leonina. Experientia 39, 255–256 (1983).](https://doi.org/10.1007/BF01955289)). It's [2,6-dimethyl-5-heptenal](https://www.chemicalbook.com/ChemicalProductProperty_EN_CB3434408.htm).

In the chemistry labs I taught, I made part of the assignment to report how much of each chemical each team used, how much it would cost, and what it's shipping time. That's real-world science there. You have to know where to look, how much of your budget you need, and how soon you can get it. For example, some chemicals cannot be shipped by air. Bench chemists likely just go to their stockroom and ask the support staff, but, not only should scientists understand how things happen, but many science students go into support roles rather than scientist roles.

There's a lot of knowledge out there, and we should use it when we can.

## Yes, reinvent the wheel

As a counterpoint, even though we know the answer, practicing reproducing that is part of training. You know what the result should be because thousands of people have already done it. This isn't the less-optimal part of Project Euler. We should go through targeted and limited-universe problems to practice skills. That's kinda the point.

But, there's a much richer set of problems to solve even though got to the answer:

* could I do this faster or better?
* what if I didn't use this feature?
* when does this solution break (overflow, whatever)?

It seems that people get the number and that's it. Some other similar things have competitions for the shortest program, fastest program, and so on.

## Make blinky lights

I feel like I want to write another article on this, but sometimes the Skinnerian impulse to make the light blink is all of the fun. Do you something really simple, but because you did it, you get some dopamine.

But then, there are occupational video gamers, and people watch them play games, so what is going on there?

## What are the restrictions?

Here's a thing that really annoys interviewers: ask them what's left out of the problem. The best example I have is for an EMT job I did not get. First, the question was "An elderly man complains of chest pain. What do you do?" It's a question that wants the robot to answer "Give him 325mg of chewable children's aspirin sub-lingually." But that's not the right real-world answer. There's a thought process that you are supposed to go through, and part of that is finding out which medications they are already on. You can't give someone already on blood thinners another blood thinner. The next question was "You come upon a car accident. The drive is complaining of neck pain. What do you do?" The robot answer is the put a C-collar on him to stabilize his neck. But, again, no. If you put a C-collar on someone, it's probably not coming off for hours and there are poor outcomes from that. Not only that, I haven't even talked to the guy yet. I answered what I'm actually supposed to do. I asked about the mechanism of injury and the damage to the vehicle. If the frontend is crumpled, that's one thing, but if the damage is slight, is the neck pain related to the accident? Maybe he has chronic neck pain.

I didn't get that job, and one of my colleagues consoled me by saying they want dumb kids who will just do what they are told.

But that's the difference between goofing off with hobby programs, and learning about programming that's useful to people where the theory itself isn't useful, and sometimes counterproductive.

So what do I care about in programming?

* what's the bottleneck? I/O? Processing? Network?
* how soon do you need it?
* how long are we going to use this?

For the bottleneck, I'm going to mitigate that with an approach, and I'll discuss that in a moment.

If we need it right now, I'm probably going to skip a lot of good practices, not document what I write, not test to high coverage, and so on. These are typically tasks where I just need the answer and once I have it, I don't need the program. If I need more later, I'll back to improve the program later.

Similarly, if I'm going to need this over and over, I'm going to take a lot more care and need a bit of time for more delivery. And, there's a trade off to the time I spend on this and the value it returns (classic "productivity").

Project Euler says that most people take three minutes to complete the task. Okay, that's fine. I don't believe it, but whatever.

What do I not care about? This is useful design question because it can shrink the universe of the problem. For Euler Problem #3, I don't:

* care about all the factors
* care about repeated factors
* care about non-prime factors

## We know all the primes

For Problem #3, we need to know which numbers are prime. However, the problem is not determining primality, so does that need to be part of the problem? I surveyed some solutions, and many of them just start at 1 and keep checking for factor until they get up to the number.

If I wanted speed, I could knock this out in a minute:

{% highlight perl %}
use List::Util qw(max);
my $n = $ARGV[0];
my @factors = grep { $n % $_ == 0 } ( 2 .. $n );
say "$n -> @factors";
say max(@factors);
{% endhighlight %}

But, this is wrong. Consider the number 1024, who's largest, non-identical factor is 512. The solution works if I have one input where this is not a problem, but there's often a hidden assumption that the program

So, I need to only check primes for a number that I don't know ahead of time, what do I do? This is implicit design decision that many working programmers would make. There's a level of generalities baked into the work.

So let's only look at primes by filtering out those that aren't:

{% highlight perl %}
use List::Util qw(max);
my $n = $ARGV[0];
my @factors =
	grep { $n % $_ == 0 }
	grep { is_prime($_) }
	( 2 .. $n );
say "$n -> @factors";
say max(@factors);

sub is_prime ($i) {
	return 1 if $i == 2;
	my @c = grep { $i % $_ == 0 } 2 .. sqrt($i);
	return @c ? 0 : 1;
	}
{% endhighlight %}

But this is a lot of work when I already know what the primes are, and why should I do that work again? This is another bias of many programmers: it's not pure enough if the program hard-codes something. That is, anything computable must be computed because maybe it changes, like if Neil deGrasse Tyson decides that 3 is no longer prime because it's too close to 2 because of black holes or whatever [bullshit he makes up]().

But, someone has already done all of this work. Sometimes I check the [On-Line Encycopedia of Integer Sequences](https://oeis.org/A000040), but then remember they often only have the first 50 or so of anything. There are plenty of lists of primes out there, but many I find are paginated, inside goofy HTML, so something else.

So, I could make my own prime numbers ahead of time, but this is a lot of work and I'll check back in a couple days to see if it's even close to finishing. This is so slow that it's not even worth trying:

{% highlight perl %}
use v5.42;

foreach ( 2 .. 0xFF_FF_FF_FF ) {
	say if is_prime($_);
	}

sub is_prime ($i) {
	return 1 if $i == 2;
	my @c = grep { $i % $_ == 0 } 2 .. sqrt($i);
	return @c ? 0 : 1;
	}
{% endhighlight %}


Perl is much too high level for this task, but it can connect to low-level C things, like [Math::Prime::Util](https://metacpan.org/pod/Math::Prime::Util):


{% highlight perl %}
use Math::Prime::Util qw(primes);

$|++;
foreach my $p ( primes(0xFFFF_FFFFF)->@* ) {
	say $p;
	}
{% endhighlight %}

At this point, I might as well use [Math::Prime::Util](https://metacpan.org/pod/Math::Prime::Util):

{% highlight perl %}
use v5.10;
use List::Util qw(max);
use Math::Prime::Util qw(factor);
say max(factor($ARGV[0]));
{% endhighlight %}

But I know something special here. That module can handle numbers past Perl's
native precision (probably 64-bits, but some people might have 32-bit perls):

{% highlight bash %}
$ perl greatest_prime_factor.pl 600851475143
6857
137
$ perl greatest_prime_factor.pl 1024
2
$ perl greatest_prime_factor.pl 123456789
3803
$ perl greatest_prime_factor.pl 12345678943532523523453245
113570479219286357789
{% endhighlight %}

And, it's fast:

{% highlight bash %}
$ time perl greatest_prime_factor.pl 123456789435325235234532454367454525635634524556
46115351126989665629677

real	0m0.063s
user	0m0.047s
sys	0m0.014s
{% endhighlight %}


This was quick; in a couple of minutes I had about 20 million primes in a 2 GB file (only 595 when gzipped). That's why there aren't lists. It's easier to simply recompute them locally. But now I've done and I never have to compute these again. But "have to" doesn't mean looking them up is a good idea.

But 20 million is not that big a number. I mean, 2 GB might be more than all the storage I had available to me from birth up to the middle 90s when Iomega Zip and Jazz drives became a thing, which is sorta like telling kids about this new technology where you could dial a phone number without talking to the operator. Not only do they not knowing about dialing, even the push button sort, but they don't grok phone numbers.

But, I don't have to store them as character data. Imagine a very long string of bits, where every bit represents one positive whole number (with 0), I'd still have 512 MB of data, mostly zeros, but I gain something else: very fast lookup.







<!--more-->

