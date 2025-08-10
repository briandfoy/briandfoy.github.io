---
layout: post
title: Indirect measures and bad conclusions
categories:
tags:
stopwords:
last_modified:
original_url:
---

There are several things to consider when people show you data. Although outright lies are a concern, I'm more worried that they don't understand their own data. With machine learning and big data analytics being a Thing, it's more common to find people who know how the turn the crank who don't understand what they are putting in the sausage.

I originally wrote this as a reply to something on the internet about a study that claims to have measured the energy efficiency of programming languages, but decided it wasn't worth it. I didn't think that anyone would really disagree, but I also didn't think anyone would read the whole thing.


This concerns [Ranking Programming Languages by Energy Eﬃciency](https://haslab.github.io/SAFER/scp21.pdf), a paper that thinks it is interesting to think about the energy a program uses based on the programming language it used.

<!--more-->

# What are you measuring?

My first thought in these comparisons is to look at the program they are testing, which are in in [greensoftwarelab/Energy-Languages](https://github.com/greensoftwarelab/Energy-Languages/tree/master/Perl); they are all very short toy programs. For very short programs, the compilation time is going to dominate because the runtime is so quick. The paper says:

> Second, we present a second large study in order to provide a validation of our previous energy ranking that uses a more idiomatic and day-to-day code example base. Indeed, we consider a chrestomathy repository, Rosetta Code, ...

But, we don't write toy programs to do real work, and the Rosetta Code game isn't representative of actual programming. Those programs are short demonstrations of a low-level task, isolated from scale. When we want to do real thing with real data, the runtime portion of the work dominates the compilation time. For example, for a webserver that runs for months, who cares if the startup costs are 1 or 10 seconds?

Also, toy programs take virtually no development time, and some (many?) of the toy programs in Rosetta Code have been optimized to within an inch of their lives. They are very short programs that do not have to interact with a person or its environment, don't deal with network or databases, and ignore many other real-world factors.

That a C toy program runs faster than the same toy program written in some other language has no interest for me. How much energy did the developer use to get to the point where they are running the program? How much energy is used to maintain that program once it is in production? What are the relative risks; is a memory-unsafe program's energy savings worth the extra risk of using a memory-safe program that uses slightly more?

For example, if the C program took one year to develop, but runs only slightly faster, how do we account for all of the power and resources in that year?

There's no point in thinking about any of this if we are not going to change our behavior. The world, for the most part, isn't choosing C or C++ despite the fact that everyone knows that those programs can be very fast. The world affirmatively accepted alternatives because it was easier to get things done even if the power trade-offs are worse. The program that works today is better than the one which doesn't work yet, and higher level languages handle that much better.

What kind of programs are likely to be better in the "low-energy" languages? Most of the Rosetta code programs are simple math problems. Even the [FASTA program](https://github.com/greensoftwarelab/Energy-Languages/blob/master/Perl/fasta/fasta.perl) is not really anything about FASTA but just stitching together fixed strings in random arrangments based on some simple math. Not only that, the Perl version is actually a program that creates a Perl program it then `eval`s, which Perl programmers typically do not do.

The people making the measurements have a probe that gives them numbers, but they don't understand the titular subject. This is the sort of project a university group does, and once done, forgets. Some people get a publication, satisfy their degree requirements, and so on.

## Why those data?

Things that are easy to measure tend to be the things that get measured, and real measures are too hard to fit within the time frame of a grant, or the semester the student has to look at it. This sort of science doesn't create the experiment it needs, it accepts the experiment it can do with what is available and convenient.

Toy programs in "isolation" are easy to measure. Toy programs that already exist are even easier to meausure. Therefore, the conclusions are about toy programs that are available, after much effort, and without anything to say about programming in the large.

## How university research works

People don't study interesting questions. They torture questions out of what they can study.

Read some psychology studies. Are you surprised that the sample size is 73 people? Are you surprised that they were all college students? Are you surprised they were paid to take part in the experiment?

The study used 73 paid students because the research is at a school and those are the sorts of people who would show up to get $15. Actually, 80 students took part, but they removed seven outliers that adversely affected the *p* value. This is *selection bias*

That study might then predict what poor college students from that school might do, but that's about it. And, it has to be students poor enough that they'll show up for $15 (or a gift card) instead of doing what people that age would normally do. Almost none of these sorts of studies are reproducible, even at other colleges, because most people aren't poor college students who need $15 more than they value doing anything else.

Finally, why college students? The researchers didn't have to go far to find them or work that hard to include them. In short, this sample is convenient.

For what it's worth, I had friends in the psychology department in my undergraduate school and took part in some experiments to help them out, because why not? But, I was also extremely poor in school.

If you really want to dive into this, read about the fake results of the Stanford Prison Experiment. Some sources hold this up as an amazing result, but did anyone outside of a university not know that prison guards can be mean or abusive? Is anyone going to take that result and change anything?

Did you know they had to cancel the experiment? Not many people talk about that. Did you know that the [principal researcher Philip Zimbardo faked the results to get the outcome he wanted](https://www.vox.com/2018/6/13/17449118/stanford-prison-experiment-fraud-psychology-replication), and he had a history of doing this? The guards were instructed to be mean, and the prisoners played the roles of prisoners (literally doing improv theater), because people in psychology experiments act like they think you want them to act. Don't let lazy writers such as Malcolm Gladwell make you think otherwise.

<div class="youtube"><iframe width="560" height="315" src="https://www.youtube.com/embed/qg5V-A3-qco?si=MoCAULYg1l-ZluFA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe></div>

Don't let this Bill Murray scene fool you. Zimbardo perved on his graduate student and ended up marrying her. Also, consider that after the prison experiment had to shut down over ethical violations, Standford did nothing and let Zimbardo keep his job without oversight or sanction. Let's also not forget this si the same school where Marc Tessier-Lavigne resigned as president after accounts of his research misconduct, including fake data and image manipulation, were widely reported?

So yeah, that's what you are dealing with here. People measure things that no one cares about and hardly anyone will ever read because the money source doesn't care because there is almost no chance for downstream profit (or bankruptcy).

## How are you measuring?

Almost anything we want to quantify, in any field, is an indirect measure that we have to correalate with the actual effect.

Most of this study seems to be trying to justify an indirect measurement and meaningful for the actual research question. Indeed, this paper is a second go at something that didn't pan out the first time. So, that didn't work, but they'll double down anyway:

> First, we have considered an alternative dimension within our earlier work. Indeed, one of the objectives we considered was peak memory usage, which did not prove to be correlated with memory energy consumption. Now, we are presenting total memory usage, or the accumulative amount of memory used through the application’s lifecycle, as another possibility for analyzing memory behavior.

There are two very important things to take from this statement. First, they have no idea how much energy something uses. They did a previous experiment looking at peak memory use, and then had to decide that was nonense. Now they are looking at "acculumative" memory. Why? Because that's something they can measure. However, at this point no one has proven that measurement is connected to total energy use, is isolate-able, is repeatable, or any of the other criteria a serious study needs to show that we can trust it.

Consider this thought experiment: Program A allocates a very large chunk of RAM and then sleeps for one day. Program B uses a very small chunk but adds one to every byte as fast as it can for one day. Which one uses more energy? Then, consider one being a C program and one being whatever language you desire, and further consider the results if you flipped that around?

But who cares about total memory use? There's a way to measure energy directly: look at the current draw directly. Attach electrical engineering tools to the mains.

Again, why don't they do that, instead of using virtual machines? They didn't do that because they aren't trying to isolate the problem. They don't care about a problem. They have one probe into a system, and they are going to use that probe, and only that probe, to make a connection that they have yet to prove they can connect.

But, they also can't attach equipment to the mains because they aren't actually running the program on the host machine. They are inside a virtual machine, meaning the memory is even less isolated. Not only is the host computer doing all the extra things an operating system and all its services do, but the virtual machine sitting on top of it is doing even more.

# What is the scale?

These things are tricky because the graph looks like there's a dramatic difference between one side and the other. The Y Axis is in Joules, a unit of work, and one of the definitions of that is a watt-second. I looked up the [thermal output of my M2 MacBook Pro](https://support.apple.com/en-us/102839). At idle, it's running at 494 BTU/h, which is 145 J/s. That's 145 J/s for just being on, every second. With 70 Joules, we're talking about a half second of idle time in my laptop.

This energy comsumption argument seems to me much like that for sending UTF-8 instead of ASCII over the internet. Sure, you might save a kilobyte, but that one image on the page, or the SSL, or many other things swamps that savings. The numbers are so insignificant and it's not even worth thinking about.

Consider the case of shark attacks on humans going up 100% in January? Does it matter that the spike is one additional shark attack since the previous value was 1? 100% sounds alarming, one more does not. A program using 70 joules seems that horrific because 70 is a big number, but a big number compared to what? That number could be 70,000 millijoules, and that it's 70,000 doesn't make it interesting.

If the goal is some sort of climate-friendly behavior for programmers, the easier thing is simply using less computing power, fewer data centers, and no AI.

## What could they have done?

What could they have done instead? Run programs that do interesting things that operate on the order of minutes.

I would compare programs that extract columns from a millions rows of CSV data and sorts a string column by frequency. This is a well-understood solution that any programming language should be able to handle.

A program to download a large JSON file and parse it into a usable data structure in another interesting problem. Do this several hundred thousand times.

Likewise, if they want to measure numbers, let the programs use the same algorithm to find the first 100,000 prime numbers. Do something that takes a lot of time.

But even then, it's not the language that matters as much as the efficiency of the library. Any particular language will have competing libraries for the same task, and one of them is going to be more efficient.

I don't particularly care what the programs should do as long as those programs perform some task that real world programmers have to complete.

## Further reading

* [Energy efficiency of Programming languages](https://www.reddit.com/r/elixir/comments/1acai5h/energy_efficiency_of_programming_languages/)
* [Hacker News](https://news.ycombinator.com/item?id=15249289)
* [*Energy, Entropy and
the Theory of Wealth*](http://www.libellus.co.uk/uploads/jc_energy_entropy_wealth_2016.pdf) by John Constable
