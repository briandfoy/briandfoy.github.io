---
layout: post
title: Running all the Simulations
categories: programming science
tags: graduate-school vms dcl
stopwords: Ph
last_modified:
---

Often in classes I'll tell the story of my excessive yet justify use of computing resources while in graduate school in the late 90s. Sometimes I tell it to point out that computers are often idle, and other times to show that programs don't need to be that fast if you don't need the results right away. Mostly, it's about not running the program at all if you can get the answer and remember it.

I barely remember the specifics, and even then, I've probably enhanced the story in my memory through repeated telling. How I tell it is better than the truth anyway. There was a simulation where the input was a beam of some sort of atom or ion impinging on a foil at some energy. The output was what and how much we expected to get out of the collision. This is the basic idea of this sort of nuclear and particle physics—crash two cars into each other then look at the pieces.

In preparation for my time on the equipment, I'd have to run a series of simulations for the beam type, beam energy, and target to find the optimum beam energy. I'd typically want about 8 or 10 different beam energies to find the maximum yield in the curve. Each simulation would take three to four hours, excluding time to notice it had completed and for me to notice. The program would take over the machine such that anything else had to wait.

When scientists had time on the beam, they'd figure out their beam and target then run a bunch of these simulations. Every. Time. I don't think anyone particularly liked it, and I know that I hated it. As a grad student, they expected me to sit in front of a terminal until a simulation finished so I could start the next one. The sooner I got them all done, the sooner they could continue their planning.

This is the sort of hazing that goes on in the sciences in grad school. As my advisor told me, the last thing a Ph.D. learns is whatever they were thinking about right before their dissertation. Although glib, I didn't find it to be untrue.

One night I decide to write a little program to do all of this for me. My program, written in [DCL](http://h30266.www3.hpe.com/odl/vax/opsys/vmsos73/vmsos73/6489/6489pro_005.html), would start a simulation, wait for it to finish, then start the next one as soon as it was done. These are the sorts of skill you develop while sitting in a terminal room with nothing to do other than read the [grey wall](ftp://jttechonline.com/jargon/html/entry/Big-Gray-Wall.html)—the series of manuals in grey, three-ringed binders. Get bored enough and you'll read anything.

This is where I think many scientists failed, and also how I didn't endear myself to the people who could make my life difficult even if I did make friends with people who couldn't make my life easier. I had a task, I looked at the tools available to me, then I learned them. That is, I learned the tools for what they were, not just what I could cobble together to the particular task. You might think you don't need something because it's not immediately useful, but it builds on everything that you've learned before. Everything you've learned feeds into the possibilities you see for future solutions. That's day-to-day science.

A scientist had told me that the real work begins when the scientists go home for the night and the graduate students wake up. That gave me the Idea. I'd have my program start at 5pm every night and run until 8am, when the scientists came back. I'd get four simulations done every night.

There were a limited number of available beam types and targets—maybe 30 combinations—each needing 10 runs, I figured I need a little over two months to get it all done. That wasn't a problem for me because I didn't have an experiment coming up. This would run mostly unattended.

Some nights I'd take a screen shot of the CPU statistics and tape it to my office door. It was usually 100% usage—a badge of honor.

And about two months later I had it all, or at least enough of it that I turned the text-based data files into plots that I printed and put into a binder. Want the results of a simulation? Go to the binder, tab to the beam type, and flip pages until you got to your target type. There's the plot of 10 runs and there's the interpolated curve with its maximum.

The younger scientists were happy. They could look at my binder and have their answer in 5 minutes rather than next week.

I didn't have to stop there. I could run more and more simulations to put more points into my curve fitting. The computer is idle at night, so why not? Just keep creating knowledge because you can never get past time back. Even if your program is slow now, start generating results. You don't know if it will be faster in the future. Once you have the results, save them. Reuse the results locally.

And here's the part of the story that I don't tell in classes.

The chief scientist didn't like the binder. Besides being an asshole, he was a technophobe. He didn't believe my program gave the same results as me sitting physically at the terminal. I hadn't written anything complex—just some automation code. He already had it in for me, liked to haze the graduate students, and didn't care if you were producing as long as you were busy. Everything about him was the wrong way to do science and I think he knew that. He was the chief scientist mostly because he'd been demoted to the minor leagues to work at a university rather than a national laboratory.

I had to hide the binder in a desk drawer, and a couple of the scientists would sneak looks at it. I don't know what happened to it because I left grad school not too long after all that, having become extremely disillusioned at the middle school pettiness of it all.
