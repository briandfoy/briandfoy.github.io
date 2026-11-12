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

Project Euler is not wrong, but you're reading this, so there's that. As with most things, the wrongness is not organic to a problem, but introduced by the incentives for the overall project, which is:

> Project Euler is a series of challenging mathematical/computer programming problems that will require more than just mathematical insights to solve.

For several possibly non-overlapping groups of people each of which have their own goals:

> The intended audience include students for whom the basic curriculum is not feeding their hunger to learn, adults whose background was not primarily mathematics but had an interest in things mathematical, and professionals who want to keep their problem solving and mathematics on the cutting edge.

So, yeah, this is fun. Project Euler is fun. It's something to do, for fun. Yet, I'm here to make it not fun. Or, just differently fun.

Here's Problem #3:

> The prime factors of 13,195 are 5, 7, 13 and 29. What is the largest prime factor of the number 600,851,475,143?

The problems aren't presented with any constraints or restrictions. It asks a question and that's it. For example, am I solving the problem if I just ask a search engine or Claude?

If you answered "no" to that, what do you think the bounds of the solution are? And, when you consider that, probably never in a specific enough way to write it down, what are you doing?

## Just ask

I used to judge science fairs, before I realized that most people, whether they were students, teachers, or judges, were just phoning it in. It was so disheartening I couldn't continue.

The problem is that the teachers have no idea about science, the science fair has no rules, and the judges drawn from the community have no idea what the students were told to do. And, those judges weren't teachers who understood talking to children and often not very good scientists. You know what you call the person who graduated last in medical school? Doctor.

The turning point was a fourth grader's project asking why we salt the roads when it snows. She did the proper thing anyone should do first: ask around. She wrote a nice letter to the local transportation department and got back a detailed response about salt, sand, and clay, the different uses of each, and notes about availability and costs. Perfect.

I like to tell the story of Jacques Costeau, TV hero of my childhood, sailing into a port. The first thing he do, well maybe the second after tying off, is to visit the fisherman and ask "seen anything weird?". The first step in the Scientific Method, despite what you might have been taught, is Observation, and that Observation doesn't have to be you.

But, all the other judges failed her project because this fourth grader asked someone who knew before she started. Fuck those judges.

## Just look it up

Part of my professional scientific training was how to not do work that has already been done. My first experience with this was the Hooded Nudibranch, *Melibe leonina*, that has a very strong watermelon odor. As a student project, I wanted to isolate that chemical responsible for its fruity smell. But, going through a literature search, I found it had been done a couple of years earlier ([Ayer, S.W., Andersen, R.J. Degraded monoterpenes from the opisthobranch molluscMelibe leonina. Experientia 39, 255–256 (1983).](https://doi.org/10.1007/BF01955289)). It's [2,6-dimethyl-5-heptenal](https://www.chemicalbook.com/ChemicalProductProperty_EN_CB3434408.htm). Well, damn. I guess I'll just have to work on this skunk's anal gland, which does not have a fruity smell.

In the chemistry labs I taught, I made part of each assignment to report how much of each chemical each team used, how much it would cost, and what its shipping time is. That's real-world science there. You have to know where to look, how much of your budget you need, and how soon you can get it. For example, some chemicals cannot be shipped by air. Bench chemists likely just go to their stockroom and ask the support staff, but not only should scientists understand how things happen, but many science students go into support roles rather than scientist roles.

There's a lot of knowledge out there, and we should use it when we can. But we need to know what's available and how to use it, and formal education does so little of that because the "educators" don't know themselves.

In grad school, which I went to right after college, an industrial physicist also matriculated. He'd recently retired and decided to get his advanced degree. His problem is that he knew more physics than any of the professors because he'd done it all for real. In my undergraduate program, a retired IBM surface chemist joined the faculty, and it was the same thing. Most academics get just weeks of "real work" a year, which the industrial sorts do it every day.

And yes, this is still related to what I'm saying about Project Euler.

## Yes, reinvent the wheel

As a counterpoint, even though we know the answer or can easily discover it, practicing reproducing it is part of education and training. You know what the result should be because thousands of people have already done it, and you learn in baby steps. This isn't the less-optimal part of Project Euler. We should go through targeted and limited-universe problems to practice skills. That's kinda the point.

But there's a much richer set of problems to solve even after getting to the answer:

* could I do this faster or better?
* what if I didn't use this feature?
* when does this solution break (overflow, whatever)?
* what did other people do, and why is mine different?


It seems that people get the answer, a number, and that's it. Some other similar things have competitions for the shortest program, fastest program, and so on, and present many different sorts of solutions.

I have, in job interviews, asked the person to sketch out how they would solve some problem, and then, to solve the problem without some feature. I'll tell them that I don't know how to do it either, but let's figure it out. Maybe you can't do it. Maybe you can. Maybe I can't. The point was to see how the person would work on something that might not be doable. Two common things I threw out were "What about not using any conditionals" or "loops" or something. See [https://briandfoy.github.io/no-ifs-ands-or-buts/](https://briandfoy.github.io/no-ifs-ands-or-buts/).

Project Euler doesn't really encourage speed running the problems, but it kinda does, where I might spend a couple days playing with something seemingly so simple. I often recall Jeffrey Nunberg's (a linguist) comment that real linguists don't care about fancy words or vocabulary, but spend their time thinking about what "the" means.

See for instance [my benchmark for the Schwartzian Transform](https://briandfoy.github.io/wasting-time-thinking-about-wasted-time/) that shows there's a break-even point. I think I did the bulk of the work in one day, but it took about a week to go through it.

## Make blinky lights

I feel like I want to write another article on this, but sometimes the Skinnerian impulse to make the light blink is all of the fun. You do something really simple, but because you did it, you get some dopamine. You think the food that you cook tastes better (sometimes worse) than it might taste objectively because of your involvement.

Why buy a loaf of good sourdough for $15 (yeah) when you can spend several weeks making a starter, two days preparing dough, and an hour baking it? Because the effort is the point. Discovering the complexity and breadth of the problem is the point. The end point is not always the product. It was the friends we made along the way, or whatever.

But then, there are occupational video gamers, and people watch them play games, so what is going on there?

## What are the restrictions?

Here's a thing that really annoys interviewers: ask them what's left out of the problem. The best example I have is from an EMT job I didn't get.

First, the question was "An elderly man complains of chest pain. What do you do?" It's a question that wants the robot to answer, "Give him 325mg of chewable children's aspirin sublingually." But that's not the right real-world answer. There's a thought process that you are supposed to go through, and part of that is finding out which medications they are already on. You can't give someone already on blood thinners another blood thinner. There's the book answer, and then there's the real answer, and you have to know what context you are in and how much integrity you want to have.

The next question was, "You come upon a car accident. The driver is complaining of neck pain. What do you do?" The robot answer is to put a C-collar on him to stabilize his neck. But, again, no. If you put a C-collar on someone, it's probably not coming off for hours, and there are poor outcomes from that. Not only that, I haven't even talked to the guy yet. I answered what I'm actually supposed to do. I asked about the mechanism of injury and the damage to the vehicle. If the front end is crumpled, that's one thing, but if the damage is slight, is the neck pain related to the accident? Maybe he has chronic neck pain.

I didn't get that job, and one of my colleagues consoled me by saying they want dumb kids who will just do what they are told. But, someone got that job by giving the wrong answers, and when I have a problem, they are the butchers who are going to show up.

To contrast that, consider my clinicals, where I rode around in an ambulance with a real crew doing real things. After every call, the supervisor quizzed me about what I thought was happening, and I'd go through all the book stuff, and she'd say, "No, it was anxiety." And it's true. Most of them had relaxed when help arrived because their vital signs were reactions to their uncertainty about the future.

But that's the difference between goofing off with hobby programs and learning about programming that's useful to people, where the theory itself isn't useful and is sometimes counterproductive. There's how you do it in school, then all the de-education that the real world has to do to make you useful.

So what do I care about in real-world programming?

* what do you really need? (sometimes that's different than what they think they need)
* what's the bottleneck? I/O? Processing? Network?
* how soon do you need it?
* how long are you going to use this?

For the bottleneck, I'm going to mitigate that with an approach, and I'll discuss that in a moment.

If we need it right now, I'm probably going to skip a lot of good practices, not document what I write, not test to high coverage, and so on. These are typically tasks where I just need the answer, and once I have it, I don't need the program. If I need more later, I'll go back to improve the program later. I can always do more work later, but I can't recover lost time retroactively.

Similarly, if I'm going to need this over and over, I'll take much more care and need a bit more time for delivery. There's a trade-off between the time I spend on this and the value it returns (classic "productivity"). One of [my rules of programming](https://briandfoy.github.io/brians-laws-of-programming/) is to not create something that makes people bother you.

What do I not care about? This is a useful design question because it can shrink the universe of the problem. For Euler Problem #3, I don't:

* care about all the factors
* care about repeated factors
* care about non-prime factors

## We know all the primes

For Problem #3, we need to know which numbers are prime. However, the problem is not determining primality, so does that need to be part of the solution? I surveyed some solutions, and many of them just start at 1 and keep checking for factors until they get up to the number.

If I wanted speed, I could knock this out in a minute for small numbers:

{% highlight perl %}
use List::Util qw(max);
my $n = $ARGV[0];
my @factors = grep { $n % $_ == 0 } ( 2 .. $n );
say "$n -> @factors";
say max(@factors);
{% endhighlight %}

But, this is wrong. Consider the number 1024; its largest non-identical factor is 512. The solution works if I have one input where this is not a problem, but there's often a hidden assumption that the program

So, I need to only check primes for a number that I don't know ahead of time; what do I do? This is an implicit design decision that many working programmers would make. There's a level of generality baked into the work.

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

But this is a lot of work when I already know what the primes are, and why should I do that work again if I want to check more than one number? This is another bias many programmers have: it's not pure enough if the program hard-codes something. That is, anything computable must be computed because maybe it changes, like if Neil deGrasse Tyson decides that 3 is no longer prime because it's too close to 2 because of black holes or whatever [bullshit he makes up](https://briandfoy.github.io/neil-degrasse-tyson-is-not-a-scientist/).

But someone has already done all of this work. Sometimes I check the [On-Line Encyclopedia of Integer Sequences](https://oeis.org/A000040), but then remember they often only have the first 50 or so of anything. There are plenty of lists of primes out there, but many I find are paginated, inside goofy HTML, or something else. To simply download it, process it, and make it useable might be much more work.

All of this in in [my prime-map GitHub project](https://github.com/briandfoy/prime-map).

So, I could make my own prime numbers ahead of time. Here's the program that does that, and it close to what most Project Euler solutions would do:

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

This will take forever, where forever is defined as not being complete when I come back to the terminal the next morning. This works for small numbers, but quickly becomes inefficient. Again, it's no accident that the problem chooses a large enough number for this to be a problem.

And Perl is much too high-level for this task, but it can connect to low-level C things, like [Math::Prime::Util](https://metacpan.org/pod/Math::Prime::Util):


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

But is this even interesting? Maybe after reading the docs, I've learned quite a bit about fast prime number checking. For programming, there's not much going on in this script.

But I know something special here that might not be immediately noticable to Project Euler's audience. The module can handle numbers past Perl's
native precision (probably 64-bit, but some people might have 32-bit perls):

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

{% highlight console %}
$ time perl greatest_prime_factor.pl 123456789435325235234532454367454525635634524556
46115351126989665629677

real	0m0.063s
user	0m0.047s
sys	0m0.014s
{% endhighlight %}


This was quick; in a couple of minutes I had about 20 million primes in a 2 GB file (only 595 MB when gzipped). That's why there aren't lists—I don't want people downloading that much from me. It's easier to simply recompute them locally. But now I've done that, and I never have to compute these again. But "have to" doesn't mean looking them up is a good idea.

But 20 million is not that big a number. I mean, 2 GB might be more than all the storage I had available to me from birth up to the middle 90s when Iomega Zip and Jazz drives became a thing, which is sorta like telling kids about this new technology where you could dial a phone number without talking to the operator. Not only do they not know about dialing, even the push-button sort, but they don't grok phone numbers.

But I don't have to store them as character data. Imagine a very long string of bits, where every bit represents one positive whole number (with 0), I'd still have 512 MB of data, mostly zeros, but I gain something else: very fast lookup. Here's the program to create the

{% highlight bash %}
#!/usr/bin/perl
use v5.42;
use autodie;

use File::Map qw(map_handle sync);
use Math::Prime::Util qw(next_prime);

my $MAX   = 0xFFFF_FFFF;
my $BYTES = ($MAX + 1) / 8;    # 512 MiB

my $file = $ARGV[0] // 'prime_map.dat';

open my $fh, '+>>:raw', $file;

my $size = -s $fh;
die "$file is $size bytes, expected 0 or $BYTES\n"
	unless $size == 0 || $size == $BYTES;
truncate $fh, $BYTES if $size == 0;
map_handle my $map, $fh, '+<';

for (my $prime = 2; $prime < $MAX; $prime = next_prime($prime)) {
	vec($map, $prime, 1) = 1;
	}

sync($map);
{% endhighlight %}

I run this to create the map, which is a lookup table for everything up to
2^32 - 1:

{% highlight console %}
$ just build
rm -f prime_map.dat
time perl make_prime_map.pl prime_map.dat

real    2m4.560s
user    2m1.340s
sys     0m2.908s
{% endhighlight %}

I have a small program to use it, and that can be a subroutine in a larger program:

{% highlight console %}
$ time !!
time perl is_prime.pl 3452356529
3452356529 is prime

real    0m0.026s
user    0m0.011s
sys     0m0.013s
{% endhighlight %}


## Wrapping it up

* The number is not the goal




