---
layout: post
title: wasting time thinking about wasted time
categories: programming
tags: rescued-content perl
stopwords:
last_modified:
---

https://www.perlmonks.org/?node_id=393128

## The Problem



I'm teaching our (Stonehenge's) Alpaca course (Packages, References,
Objects, and Modules) this week. Day 2 is sponsored by the letter R,
so after we talk about references, we throw in some stuff about the
Schwartzian Transform, which uses a reference to do its magic.



In one of the exercise,to prove to our students that the transform
actually boosts performance, we ask them to sort a bunch of filenames
in order of their modification date. Looking up the modification time
is an expensive operation, especially when you have to do in N*log(N)
times.



The answer we gave in the materials is not the best answer, though. It
is short, so it fits on one slide, but it makes things seem worse than
they really are. The Schwartzian Transform performs much better than
our benchmark says it does.



{% highlight perl %}
use Benchmark qw{ timethese };

timethese( -2, {
	Ordinary => q{
		my @results = sort { -M $a <=> -M $b } glob "/bin/*";
		},
	Schwartzian => q{
		map $_->[0],
		sort { $a->[1] <=> $b->[1] }
		map [$_, -M],
		glob "/bin/*";
		},
	});
{% endhighlight %}



First, if we are going to compare two things they need to be as alike
as we can make them. Notice that in one case we assign to @results
and in the other case we use map() in a void context. They do
different things: one sorts and stores, and one just sorts. To
compare them, they need to produce the same thing. In this case, they
both need to store their result.



Second, we want to isolate the parts that are different and abstract
the parts that are the same. In each code string we do a glob(),
which we already know is an expensive operation. That taints the
results because it adds to the time for the two sorts of, um, sorts.



<readmore>
## The solution



While the students were doing their lab exercises, I rewrote our
benchmark. It's a lot longer and wouldn't fit on a slide, but
it gives more accurate results. I also run Benchmark's timethese()
function with a time value (a negative number) and then an iteration
count. The first runs the code as many times as it can in the given
time, and the second times the code run a certain number of times.
Different people tend to understand one or the other better, so I provide
both.



I break up the task in bits, and I want to time the different bits
to see how they impact the overall task. I identify three major parts
to benchmark: creating a list of files, sorting the files, and assigning
the sorted list. I'm going to time each of those individually, and I
am also going to time the bigger task. I also want to see how much
the numbers improve from the example we have in the slides, so I use
the original code strings too.



{% highlight perl %}
#!/usr/bin/perl
use strict;

use Benchmark;

$L::glob = "/usr/local/*/*";
@L::files = glob $L::glob;

print "Testing with " . @L::files . " files\n";

my $transform =
	q|map $_->[0], sort { $a->[1] <=> $b->[1] } map [ $_, -M ]|;
my $sort   = q|sort { -M $a <=> -M $b }|;

my $code = {
 assign        => q| my @r    = @L::files       |,
 'glob'        => q| my @files  = glob $L::glob     |,

 sort_names      => q| sort { $a cmp $b } @L::files     |,
 sort_names_assign  => q| my @r = sort { $a cmp $b } @L::files |,
 sort_times_assign  => q| my @r = $sort       @L::files |,

 ordinary_orig    => qq| my \@r = $sort glob \$L::glob    |,
 ordinary_mod     => qq| my \@r = $sort   \@L::files    |,

 schwartz_orig    => qq|     $transform, glob \$L::glob |,
 schwartz_orig_assign => qq| my \@r = $transform, glob \$L::glob |,
 schwartz_mod     => qq| my \@r = $transform, \@L::files   |,
 } ;

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
print "Timing for 2 CPU seconds...\n";

timethese( -2, $code );

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
my $iterations = 1_000;

print "-" x 73, "\n";
print "Timing for $iterations iterations\n";

timethese( $iterations, $code );
{% endhighlight %}



First, I create some package variables. Benchmark turns my code
strings into subroutines, and I want those subroutines to find these
variables. They have to be global (package) variables. Although I
know Benchmark puts these subroutines in the main:: package, I use
L::*.



The $L::glob variable is just the pattern I want glob to use. I
specify it once and use it everywhere I use glob. That way, every
code string gets the same list of files. If I were really fancy, I
would set that from the command line arguments so I could easily run
this with other directories to watch how performance varies with list
size. The transform is going to be slow for a small number of files,
but be a lot better for large number of files ( N instead of N*log(N)
).



I also want to run some code strings that don't use a glob, so I
pre-glob the directory and store the list in @L::files.



To make the code strings a bit easier to read, I define $transform and
$sort. I use these when I create the code string. I avoid
excessively long lines this way, and the code still looks nice in my
terminal window even though I've blown it up to full screen (still at
80x24) and projected it on a much larger screen.



The $code anonymous hash has the code strings. I want to test the
pieces as well as the whole thing, so I start off with control strings
to assign the list of files to a variable and to run a glob.
Benchmark is also running an empty subroutine behind the scenes so it
can adjust its time for that overhead too. I expect the "assign" times
to be insignificant and the glob times to be a big deal. At the
outset, I suspect the glob may be as much as a third of the time of
the benchmarks.



The next set of code strings measure the sort. The "sort_names"
string tries it in void context, and the "sort_names_assign" does the
same thing but assigns its result to an array. I expect a measurable
difference, and the difference to be the same as the time for the
"assign" string.



Then I try the original code strings from our exercise example, and
call that "ordinary_orig". That one uses a glob(), which I think
inflates the time significantly. The "ordinary_mod" string uses the
list of files in @L::files, which is the same thing as the glob()
without the glob(). I expect these two to differ by the time of the
"glob" code string.



The last set of strings compare three things. The "schwartz_orig"
string is the one we started with. In "schwartz_orig_assign", I fix
that to assign to an array, just like we did with the other original
code string. If we want to compare them, they have to do the same
thing. The final code string, "schwartz_mod", gets rid of the glob().



Now I have control code to see how different parts of the overall
task perform, and I have two good code strings, "original_mod" and
"schwartz_mod" to compare. That's the comparison that matters.



## The results



The Benchmark module provides the report, which I re-formatted to make
it a bit easier to read (so some of the output is missing and some
lines are shorter). The results are not surprising, although I
like to show the students that they didn't waste an hour listening to
me talk about how wonderful the transform is.




{% highlight perl %}
albook_brian[519]$ perl benchmark
Testing with 380 files
Timing for 2 CPU seconds...
Benchmark: running assign, glob, ordinary_mod, ordinary_orig, schwartz_mod, schwartz_orig,
	schwartz_orig_assign, sort_names, sort_names_assign for at least 2 CPU seconds...
  assign:      (2.03 usr + 0.00 sys = 2.03 CPU) (n=  6063)
   glob:      (0.81 usr + 1.27 sys = 2.08 CPU) (n=  372)
ordinary_mod:     (0.46 usr + 1.70 sys = 2.16 CPU) (n=   80)
ordinary_orig:     (0.51 usr + 1.64 sys = 2.15 CPU) (n=   66)
schwartz_mod:     (1.54 usr + 0.51 sys = 2.05 CPU) (n=  271)
schwartz_orig:     (1.06 usr + 1.03 sys = 2.09 CPU) (n=  174)
schwartz_orig_assign: (1.20 usr + 0.87 sys = 2.07 CPU) (n=  156)
sort_names:      (2.09 usr + 0.01 sys = 2.10 CPU) (n=3595626)
sort_names_assign:   (2.16 usr + 0.00 sys = 2.16 CPU) (n=  5698)
-------------------------------------------------------------------------
Timing for 1000 iterations
Benchmark: timing 1000 iterations of assign, glob, ordinary_mod, ordinary_orig, schwartz_mod,
	schwartz_orig, schwartz_orig_assign, sort_names, sort_names_assign...
  assign:      1 secs ( 0.33 usr + 0.00 sys = 0.33 CPU)
   glob:      6 secs ( 2.31 usr + 3.30 sys = 5.61 CPU)
ordinary_mod:     28 secs ( 5.57 usr + 21.49 sys = 27.06 CPU)
ordinary_orig:    34 secs ( 7.86 usr + 24.74 sys = 32.60 CPU)
schwartz_mod:     8 secs ( 5.12 usr + 2.47 sys = 7.59 CPU)
schwartz_orig:    12 secs ( 6.63 usr + 5.52 sys = 12.15 CPU)
schwartz_orig_assign: 14 secs ( 7.76 usr + 5.41 sys = 13.17 CPU)
sort_names:      0 secs ( 0.00 usr + 0.00 sys = 0.00 CPU)
sort_names_assign:   0 secs ( 0.39 usr + 0.00 sys = 0.39 CPU)
{% endhighlight %}



The "sort_names" result stands out. It ran almost 2 million times a
second. It also doesn't do anything since it is in a void context.
It runs really fast, and it runs just as fast no matter what I put in
the sort() block. I need to know this to run a good benchmark: a
sort() in void context will always be the fastest. The difference
between the sort() and the map() in void context is not as pronounced
in "schwartz_orig" and "schwartz_orig_assign" because it's only the
last map that is in void context. Both still have the rightmost map()
and the sort() to compute before it can optimize for void context.
There is an approximately 10% difference in the number of extra
iterations the "schwartz_orig" can go through, so the missing
assignment gave it an apparent but unwarranted boost in our original
example.



I like to look at the second set of results for the comparisons, and
use the wallclock seconds even though they are not as exact as the CPU
seconds. The "glob" code string took about six seconds, and the
"schwartz_orig_assign" code string took 14 seconds. If I subtract
those extra six seconds from the 14, I get the wallclock time for
"schwartz_mod", just like I expected. That's over a third of the
time! The "ordinary_*" times drop six seconds too, but from 34 to 28
seconds, so the percent difference is not as alarming.



So, "ordinary_orig" and "schwartz_orig_assign" take 34 and 14 seconds,
respectively. That's 2.5 times longer for the ordinary sort(). I
expect the first to be O( N*log(N) ), and the second to be O( N ).
Their quotient is then just O( log( N ) ), roughly. There were 380
files, so log(N) = log(380) = 6, which is a lot more than 2.5. The
"ordinary_orig" could have been a bit worse (although the transform
has some extra overhead that is probably skewing that number).



The modified versions, "ordinary_mod" and "schwartz_mod", have times
28 and 8 seconds, for a quotient of 3.5. That extra glob() obscured
some of that because it added a constant time to each.



## Burning even more time



This is the point where a good scientist (or any business person)
makes a chart using Excel. That's what I did for my Benchmark article
in [The Perl Journal #11](http://www.foo.be/docs/tpj/issues/vol3_3/tpj0303-0009.html) I want to see how the
difference scales, so I try the same benchmark with more and more
files. For the rest of the comparisons, I'll use the actual CPU time
since the round-off error is a lot higher now.



### 873 files



Notice that the glob() still has a significant affect on the times,
and that the original transform that was in the void context is still
shaving off about 10% off the real time. The quotient between the
transform and the ordinary sort() is 73 / 20 = 3.6, which is a little
bit higher than before. Now log( N ) = log( 873 ) = 6.8, so although
the transform still outperforms the ordinary sort(), it hasn't gotten
that much better. The sort() performance can vary based on its input,
so this comparison to log( N ) doesn't really mean much. It isn't an
order of magnitude different (well, at least in powers of 10 it isn't), so
that is something, I guess.



{% highlight text %}
Benchmark: timing 1000 iterations of glob, ordinary_mod, schwartz_mod, schwartz_orig_assign...
   glob:      14 secs ( 6.28 usr + 8.00 sys = 14.28 CPU)
ordinary_mod:     73 secs (14.25 usr + 57.05 sys = 71.30 CPU)
ordinary_orig:    93 secs (20.83 usr + 66.14 sys = 86.97 CPU)
schwartz_mod:     20 secs (14.06 usr + 5.52 sys = 19.58 CPU)
schwartz_orig:    32 secs (17.38 usr + 13.59 sys = 30.97 CPU)
schwartz_orig_assign: 34 secs (19.95 usr + 13.60 sys = 33.55 CPU)
{% endhighlight %}

### 3162 files



Idle CPUs are wasted CPUs, but I think I'd rather have an idle CPU
instead of one doing this benchmark. My disk was spinning quite a bit
as I ran this benchmark. The quotient could be as bad a log(N) =
log(3162) = 8.0, but with the real numbers, I got 603 / 136 = 4.4.



How is the transform scaling? The quotient with 873 files was 19.6.
So, does 3612 / 873 come close to 136.2 / 19.6? For a four-fold
increase in files, the map took about 7 times longer. How about the
ordinary sort(), with 603.8 / 71.3? It took 8.4 times as long. Don't
be fooled into thinking that the transform and the sort() are close:
the sort() took 8.4 times as long as an already long time. It's
paying compound interest!



Look at the huge penalty from the glob()! Now the glob() takes almost
as much time as the transform. If we stuck with the original solution,
students might think that the transform wasn't so hot.



{% highlight text %}
Benchmark: timing 1000 iterations of glob, ordinary_mod, schwartz_mod, schwartz_orig_assign...
   glob:      148 secs ( 31.26 usr + 102.59 sys = 133.85 CPU)
ordinary_mod:     675 secs ( 86.64 usr + 517.19 sys = 603.83 CPU)
ordinary_orig:    825 secs (116.55 usr + 617.62 sys = 734.17 CPU)
schwartz_mod:     151 secs ( 68.88 usr + 67.32 sys = 136.20 CPU)
schwartz_orig:    297 secs ( 89.33 usr + 174.51 sys = 263.84 CPU)
schwartz_orig_assign: 294 secs ( 96.68 usr + 168.76 sys = 265.44 CPU)
{% endhighlight %}



## In summary



If we want to believe our benchmarks, we have to know what goes into
their numbers. Separate out the bits of the task and benchmark those
separately to provide controls. Ensure that the actual code strings
that you want to compare give the same result. If they don't end up
with the same thing, we don't have a useful comparison.



In this case, separating the glob() from the rest of the code removed
a huge performance hit that had nothing to do with the comparison. This
penalty only got worse as the list of files became longer.


</readmore>
