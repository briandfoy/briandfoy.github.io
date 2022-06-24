---
layout: post
title: Do I want to process this file?
categories: programming
tags: perl grep mmap minion
stopwords: EOF ETL MacBookPro filesystems pre randos CPUs SSD eco
last_modified:
original_url:
---

I ran across a question about selecting files to process. In short, the programmer didn't want to process uninteresting files. This might be a case of pre-mature optimization, but more likely, tied-and-true knowledge from ETL. That file might take several minutes (hours) to process; you don't want to waste that on a file you don't want.

<!--more-->

# Who cares?

First, should you care? How often do you think you incur the penalty? For example, if one file out of a thousand doesn't have the pattern, does checking the other 999 actually save work? Maybe it does, but do you know that? Maybe you do for your task, but other readers may like this.

Second, what is the penalty? If it takes you a couple seconds to process a file, maybe it's better just to process it. If it takes a day to process a file, that's a different story.

# What are the constraints?

While processing files, there are two things that are probably sucking up most of your time:

1. The speed at which you can read data
2. Who long you need to process the data once you have it.

If it takes longer to read data than to process it, you are IO-bound (network-bound maybe). If it's the other way around, you are CPU-bound.

Figure out which of those situations you are in.

And, remember that if you change setups, you have to figure it out again. Different hardware can shift the numbers. Changing out an old 5400-rpm green eco disk for an SSD might move your application from IO-bound to CPU-bound, at least until you get even faster CPUs.

# The techniques

*Note: these numbers are relative to each other in my setup and mean nothing for your setup. This is on a MacBookPro13,2, macOS 10.15.7, self compiled default perl v5.34.0*

I've had to do this sort of processing quite a bit on big files, but often I new how far into the file the particular info was. Different techniques may be more appropriate for different situations, and here are just a few.

## When you have no match

Let's see how fast `grep` is when the match isn't there (so we must scan everything). Do this a couple times in a row to ensure that the file gets into the hot cache (the first time might be much slower):

	$ time grep NOT_THERE 500MB.txt

	real	0m8.005s
	user	0m7.583s
	sys	0m0.171s

Okay, 10 seconds. Let's see about `perl` when the match is not there:

	$ time perl -ne 'print if /NOT_THERE/' 500MB.txt

	real	0m4.003s
	user	0m3.610s
	sys	0m0.247s

Wow. That's pretty fast. I expected grep to be several times faster than `perl`. Again, your mileage may vary. Don't take benchmarking advice from randos on the internet, no matter how much you recognize their names. They don't have the same setup that you do and there may be other things that impact your situation.

But, we don't need to read the data at all if we can use [File::Map](https://metacpan.org/pod/File::Map). This pretends that part of your disk is in a variable already:

	$ time perl -MFile::Map=map_file -e 'map_file $map, $ARGV[0], q(<); print q(Found!) if $map =~ /NOT_THERE/' 500MB.txt

	real	0m0.581s
	user	0m0.170s
	sys	0m0.160s

That's pretty good! If you only want to check that the string is there, `mmap` might be a good way to do it.

## When you have one match, toward the end

If you only want to know if the string is anywhere in the file, once you find it you can stop. Now you want to know where you are likely to find it. If it's usually close to the front, that's easy because that's where tools like to start. If it's close to the end in a very large file (and my 500MB file is tiny to some people), then starting from the front might waste a lot of time.

So let's do the match at the end but start from the beginning case first. I know that my file has an "# EOF" as the last non-blank line.

	$ time grep '# EOF' 500MB.txt
	# EOF

	real	0m6.878s
	user	0m6.641s
	sys	0m0.130s

These numbers are slightly lower than the previous `grep`, but that's not a real difference. I don't care about a single second here. That's in the error bars. I run it several times, especially since I can't control all the accesses to the disk. For example, in modern filesystems, the first time you access a file in a long while might be really slow. When I benchmark for time, I ensure that I access all the interesting files before I start the tests to warm up any system caching. I don't want to compare a cold cache file to a warm cache one.

Perl is basically the same as before:

	$ time perl -ne 'print if /# EOF/' 500MB.txt
	# EOF

	real	0m3.611s
	user	0m3.375s
	sys	0m0.166s

## When you have one match, toward the middle or beginning

`grep` can stop after a certain number of matches (maybe, I don't know all of the implementations). With `-m 1` I tell it to stop after one match, and as expected, I get about half the time for half the file:

	$ time grep -m 1 '177.22.32.0/23' 500MB.txt
	route:      177.22.32.0/23

	real	0m4.861s
	user	0m4.300s
	sys	0m0.092s

I change around `perl` to break out after a match, and again halve the time:

	$ time perl -ne 'if( /177.22.32.0\/23/ ) { print; last }' 500MB.txt
	route:      177.22.32.0/23

	real	0m1.637s
	user	0m1.481s
	sys	0m0.081s

The `mmap` solution is the same. It was basically already stopping once it knew. But now notice that it's not as attractive a solution. It's still faster, but a second might not matter to you:

	$ time perl -MFile::Map=map_file -e 'map_file $map, $ARGV[0], q(<); print q(Found!) if $map =~ /177.22.32.0\/23/' 500MB.txt
	Found!
	real	0m0.697s
	user	0m0.330s
	sys	0m0.327s

So, once more, with something in the first tenth of the file. As the times get shorter, the startup costs (fixed costs) are more controlling:

	$ time grep -m 1 '122.152.52.0/22' 500MB.txt
	route:      122.152.52.0/22

	real	0m1.081s
	user	0m1.022s
	sys	0m0.028s

	$ time perl -ne 'if( /122.152.52.0\/22/ ) { print; last }' 500MB.txt
	route:      122.152.52.0/22

	real	0m0.448s
	user	0m0.384s
	sys	0m0.031s

	$ time perl -MFile::Map=map_file -e 'map_file $map, $ARGV[0], q(<); print q(Found!) if $map =~ /122.152.52.0\/22/' 500MB.txt
	Found!
	real	0m0.685s
	user	0m0.301s
	sys	0m0.332s

How controlling? What if the match is the first line? Now `grep` looks much better, and that's what I expect. It's fixed costs are low:

	$ time grep -m 1 'a' 500MB.txt
	aut-num:       AS372

	real	0m0.021s
	user	0m0.006s
	sys	0m0.010s

`perl` is now about the same (remember that the uncertainties here make these virtually indistinguishable). What's amazing is that `perl` is even in the same ballpark, but the people creating `perl` have been insanely creative about quickly processing text:

	$ time perl -ne 'if( /a/ ) { print; last }' 500MB.txt
	aut-num:       AS372

	real	0m0.027s
	user	0m0.008s
	sys	0m0.012s

The `mmap` solution is the same as it ever was because it's not doing anything different, but its fixed costs are the same:

	$ time perl -MFile::Map=map_file -e 'map_file $map, $ARGV[0], q(<); print q(Found!) if $map =~ /a/' 500MB.txt
	Found!
	real	0m0.600s
	user	0m0.250s
	sys	0m0.296s

## So what do I want to do now?

It's all about how you want to decompose your problem. First, I'd assume that any file given to your program is meant to be processed. That way your program doesn't have to think about that.

That turns the problem to listing the files that you want to process:

	$ for f in radb*; do grep -m 1 -l '# EOF' $f; done
	radb-role.pl
	500MB.txt
	500MB.txt2
	500MB.txt3

With `perl`, that might look like:

	$ perl -le 'for $F (@ARGV){ open F; while(<F>) { if(/# EOF/){ print $F; last} } close F }' radb.*
	500MB.txt
	500MB.txt2
	500MB.txt3

Now that I have the list of files that I need to process (all the filtering is already done), I can process them. Or, more likely, as I get the list, I can start processing the first file right away as I'm developing the rest of the list.

# A proper job queue

Depending on the time this takes and how parallel you can go, you could then think about some sort of job queue system, such as [Minion](https://metacpan.org/pod/Minion). I'd think about a several stage setup where everything is happening concurrently:

* Add a job for each file that needs to be scanned
* Run one or more jobs to scan files.
* When a scanned file has a hit, add a new job to process that file

The nice thing about the job queue is that you don't have to have completed any part of the process to schedule new work. As new work
comes it, it can run as you are doing other things. As you do long
processing on a file, you have time to scan other candidate files.



