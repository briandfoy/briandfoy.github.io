---
layout: post
title: The coming schism in Perl
categories: programming opinion perl
tags: chip-salzenberg
stopwords: Allbery CVEs Gurusamy beancounters blead downstreams mindshare raison rsyncing wikilawyering
---

*I wrote this something in early 2012 and did not publish it. Rereading it, I like the first part that covers some history. The second part not so much, but I've added a 2020 update at the end*.

<!--more-->

In 2000, Chip Salzenberg summoned several notable Perl people, me included, to a room during OSCON in Monterey and told us to think about a new Perl. His Topaz experiment to reimplement Perl in C++ had failed for various technical reasons, and if Chip can't get it done, it probably is impossible. If he could get it done, it still might have been impossible. Chip's a excellent developer and his experience taught him a lot about what a new `perl` codebase needed to be. Chip's motivation was simple: the codebase behind `perl` was becoming more and more intractable and past designs were in the way of future progress.

At the end of that meeting, a completely new venture had been group-conceived. Larry Wall, Perl's father, called this Perl 6 and make the announcement before the assembled conference, causing as much excitement as trepidation. Emotions were high on both sides.

Gurusamy Sarathy had just released Perl 5.6.0 in March, after a series of incremental releases, and just short of two years since he had released 5.005, the previous major release of Perl. There are two interesting things there: 5.005 is a stable, "maintenance" release and ends with an odd number, 5. It was also the last release where we customarily said something like "5 double o 5" instead of "5 point 6". A month later, [he proposed a set of rules for perl5-porters](http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2000-04/msg00574.html) since in-fighting has caused several key developers to leave Perl 5 maintenance altogether.

Perl was sick. It wasn't dead, but it looked destined for hospice care.

## Some perspective

What happened in the rest of 2000 shaped today's Perl development. In the general panic that followed after Larry's announcement, Jarkko Hietaniemi returned to Perl 5 Porters (p5p), the group of developers behind `perl`, [having given up only recently](http://markmail.org/message/fm4wce5xttubbldz), leading to a re-vitalization of Perl 5 development. "You can have my Perl 5 when you pry it from my cold, dead silicon", or something like that. He started an experimental branch called Perl 5.7 and made his first release a couple of months after Larry's announcement. It then took almost two years to get to the next stable release, Perl 5.8. Still, all was fine because that conformed to the idea of previous major releases. Just the idea of Perl 6 had lit a fire under Perl 5's ass. And, honestly, Perl 6 sucked away some of the toxic personalities involved.

Then things went weird. The Perl 5.9 development track lasted from late 2003 until the end of 2007. During that time, Perl appeared to die, and rightfully so. The developers, for whatever reason (and it's not worth squabbling about here), didn't make another stable release. It really did look like, to the casual observer, the Perl 6 had killed Perl 5. Perl people will deny this vehemently, or wring their hands about "perl marketing". There was no sign to the outsider that betting on Perl would be a wise choice.

Larry Wall, the benevolent dictator of Perl 5, had disappeared for various reasons, both public and private. He was working on Perl 6, so he was no longer the driving force of Perl 5, real or emeritus. He had various health issues that distracted him.

Perl 5 had lost its leader. It also lost it's way. Perl development has two Rules, simply stated:

*Rule 1: Larry is always right
*Rule 2: Larry can change his mind later.

"Rule 1" ended debates among competing concerns because Larry acted as the court of last appeal. Perl 5 developers could say "Rule 1 has been invoked", and even the losing side would move on, usually. However, the future might change Larry's mind, so "Rule 2" meant the Perl development was not by precedent and common law. This paucity of rules gave everyone a lot of flexibility, but they depended on Larry's participation. Larry provided the golden apples that kept everyone young and vital.

As Perl development stalled, third-party distributors, or "downstreams", such as the various Linux distributions, stopped paying attention because it appeared the water was gone. Perl 5.8, the last major release, solidified it's position as the only Perl you'd ever need to learn. As Perl attracted new people, their entire Perl experience was only Perl 5.8. They didn't have the idea that there would be another Perl 5 release.

At the same time, Perl's competitors for dynamic language mindshare were active and vocal. They were doing things and increasing version numbers. Ruby was making at least yearly releases, and Python was making a release every two years. They, however, didn't use the Perl two-track model. If you looked just at that activity, the conclusion seems obvious. As a newcomer choosing a technology that might run your software for the next five to ten years, do you want the seemingly maintained or unmaintained one? Sure, it's a facile argument devoid of technical merit. Do you say the same of C or C++? It doesn't matter what's right, it matters what people think, and people thought p5p development was forever stalled.

This is not to say that Perl 5 was ignored. Perl 5.8 had roughly semi-annual "point" releases until January 2006, mostly thanks to Nicholas Clark. Even Perl 5.8, with whatever features we would miss from current releases, is still good enough for most of the people using Perl. From my experience, very few people use more than you'll find in [Learning Perl](https://www.learning-perl.com) (the first edition even). However, that doesn't fix the notion that you need a new car with fancy features that you'll never use. In the minds of many people, new is simply better even if you never figure out how to use the navigation system.

Nicholas released Perl 5.8.8 in January 2006, and it was almost two years until Rafael released Perl 5.10.0 in December 2007, the first stable release to see new features since the middle of 2002. Some people called this a "Perl rennaissance", but you can't have a such a rebirth without a Dark Ages. In reality, this was just a re-energizing. We were still stuck with the entire history of p5p development, warts and all. It wouldn't have been any better for all the books and emails and presentations to disappear. The rennaissance was Perl 6, the fresh start, and it wasn't doing any better at the time.

From there, Jesse Vincent, who was the Perl 6 project manager, starting whipping Perl 5 development into shape. There was a lack of direction and many new contributors and committers. Many good things got done: there's a stated Perl policy for new development that codifies conventions and also heads off conflicts. There's a stated schedule for releases: monthly for the development track, at whatever state it's in, and yearly for the stable releases, so, 11 development releases leads to the next stable release. There are no more hold ups for half-features that haven't finished. If the feature isn't done, it gets moved into the next stable release. p5p development switched from its Perforce repository, hosted by ActiveState and limited in user-friendliness, to git, allowing anyone to play with the repository with no special permissions. Instead of rsyncing a Perforce copy, everyone could play with a clone of the same repository that p5p used with the same  Since then, process-wise, Perl 5 development is on track. *UPDATE: In 2019, Perl development moved to GitHub*

## The advent of policy

Since Perl 5 development now has a policy, that policy has become the focus. In my opinion, this is the wrong focus. A policy gives a structure to the work, but it is not the work itself. These leads to a tension people two paradigms of management: the legalistic, policy wonks and the just-get-it-done developers. On one side, there's a clear need to have some structure to the development, but on the other side, some things that need to happen don't fit into the policy.

To be fair, parts of the policy are designed to keep Perl developers from wasting their time and ensure that various things happen before they release the next version of Perl. However, policy leads to "letter of the law" behavior, where the wisdom of something is less important than the way it happened.

Policy gives people who can't and don't want to think a way to move forward without reflection. It also gives people a way to shut down thinking that they'd like to avoid because they have rules that they can point to. This is a significant change to Perl's longstanding two Rules, which don't work without Larry. As often happens in the disappearance of the spiritual leader, a bible becomes the most important stand-in. Look at Wikipedia or StackOverflow, for instance. Both were very interesting projects as long as their originators had the time to actively participate. As they grew, however, both got too big and developed a middle layer of management based on those who could stomach their policy-by-committee approach.

That's not to say that policy is bad. However, this leads to another problem in Perl 5: the developers prefer incremental changes over sweeping changes. They prefer incremental changes not only in code, but in their new process, which is already accreting. Once established, rules don't often disappear. Worse than that, prior decisions overwhelming influence new ones. Instead of making a big change that might solve many problems, committees rework rules to handle cases as they arise, leading to a patchwork of hidden history that newcomers don't understand. This selects the people who can work on the policy to the ones who have done it in the past and know the history and stakeholders. Additionally, every new change requires all current developers to constantly track the changes in policy. Although it's not yet that bad in Perl 5, Wikipedia has a word for it: "wikilawyering". You may have seen this situation in the [Mythical Man Month](https://amzn.to/38Ayqkv), which recommends a policy, but also realizes that the more communication you require for it, the less time you specify in useful work.

## The tyranny of schedule

An *a priori* schedule trumps quality. You have to release once a year, even though you don't know what you are going to add to the language yet. But, because you must release, you must add features to give the release a reason to exist.

There's currently no long range plan for `perl`. There are plenty of things that `perl` could fix (and Dave Mitchell has been steadily and modestly fixing some of these with grants from The Perl Foundation). There are larger issues, such as Unicode support, that need plenty of attention. There are serious design and implementation bugs with smart matching as well as `given`. These issues don't fit in the yearly release schedule. They're too big to think about on that time scale, so the attention goes to the things that can fit into the monthly releases, those medium features that don't appear to need long range planning.

Since each new release needs new features, the focus is constantly on new features. Once a new `perl` meets its schedule, it's on to the next one and its new features. But, do we really need new features, and for those needs, is the feature the right way to get the value that programmers want? Does the release schedule allow adequate time for testing?

## Current policy

When policy becomes King, the perceived goals of the workers displace the actual goal of the work. So, what is the goal of Perl 5 development? The perlpolicy document first showed up in perl-5.12.0, not counting development releases, where any appearance of anything is not yet official. It was the [Social Contract about Contributed Modules](https://perldoc.perl.org/5.12.0/perlpolicy.html#A-Social-Contract-about-Artistic-Control) written by Russ Allbery. It dealt with the modules that people contributed to Perl's Standard Library. It was a statement of a guiding philosophy first, not a set of rules:

> What follows is a statement about artistic control, defined as the ability of authors of packages to guide the future of their code and maintain control over their work. It is a recognition that authors should have control over their work, and that it is a responsibility of the rest of the Perl community to ensure that they retain this control.

This Social Contract did list three guidelines built around that philosophy.

The perlpolicy that shipped with perl-5.12.1 is much different. The additions dealt with policy for changes to a maintenance version:

*New releases of maint should contain as few changes as possible. If there is any question about whether a given patch might merit inclusion in a maint release, then it almost certainly should not be included.
*Portability fixes, such as changes to Configure and the files in hints/ are acceptable. Ports of Perl to a new platform, architecture or OS release that involve changes to the implementation are NOT acceptable.
*Documentation updates are acceptable.
*Patches that add new warnings or errors or deprecate features are not acceptable.
*Patches that fix crashing bugs that do not otherwise change Perl's functionality or negatively impact performance are acceptable.
*Patches that fix CVEs or security issues are acceptable, but should be run through the perl5-security-report@perl.org mailing list rather than applied directly.
*Updates to dual-life modules should consist of minimal patches to fix crashing or security issues (as above).
*New versions of dual-life modules should NOT be imported into maint. Those belong in the next stable series.
*Patches that add or remove features are not acceptable.
*Patches that break binary compatibility are not acceptable. (Please talk to a pumpking.)

Most of those make sense. However, there's no guiding philosophy in this policy; it is just a list of rules without a reason for them being there. That's not to say that there is no reason for them being there; it's just not part of the policy.

Those rules mostly have stayed the same until perl-5.15.0, except for a change to the documentation rule, which is now much more restrictive:

> Documentation updates that correct factual errors, explain significant bugs or deficiencies in the current implementation or fix broken markup are acceptable.

Still, there's no reason for this. And, it's not a very good rule. It lists some things that are acceptable but doesn't say that's a complete list. It doesn't say that everything else in unacceptable. Instead, it *implies* by omission that everything else is unacceptable by policy. Is there any exception that is possible? You can't tell because you don't know the philosophy of these rules and what they are trying to achieve. You can't argue against a rule when you don't know why it is there.

This means, in effect, that any other improvement to the documentation will, by policy, have to wait for the next major release of perl. When the *.0* release of a stable version makes it to the public, there's no more major documentation changes for a year.

Does this rule make sense? For that, you have to consider the source of the rule. Rules don't spring into existence for no reason. The only offered explanation of this policy was that every commit to a maintenance branch causes the release manager to spend 5 to 15 more minutes preparing the release.

I think this "5 to 15 minutes" is almost wholly due to the way the Perl 5 developers handle [perldelta](https://perldoc.perl.org/5.12.0/perldelta.html), the file that lists the changes to the previous release. That file has been a problem since it's usually an afterthought, even more so than normal documentation. When it comes time for a release, some poor slob most go through all the changes since the last version and explain them in [perldelta](https://perldoc.perl.org/5.12.0/perldelta.html).

If that's really the reason, what is the rule's goal? It certainly isn't making Perl 5 better. It's a reaction to something else that's not happening in the process but papering over that problem. This is a policy designed to please the developers instead of benefit the users. Developers don't have to do the work they should be doing, the managers don't expect it and don't want to force it, and the users don't matter. Simply put, code is the only thing that matters and if it isn't fun, it doesn't happen.

The weak argument that users benefit from frequent releases simply lacks imagination to have both at the same time because that would be too big a shift in the codified policy, which is now the most important thing.

A better reason might be out-of-sync documentation changes in both the stable and experimental branches. That's not a tough thing to handle unless the documents change significantly, and it's that not much of a problem when they diverge because those source control branches will never merge. There is some extra work involved, but, should that matter? If someone wants to do the extra work, why should anyone stand in the way?

## The other side

What then, should the rule be? To answer that, you have to figure out what the philosophy of the rule should be. There can be many philosophies, some overlapping, but you have to choose one that's palatable to not only the developers so they keep working, but also the users who want to keep using Perl. This is where many managers fail: they become beancounters stuck in a process rather than a force to manage resources toward the valuable goal that made them managers.

So, what is the goal? Simply put, I think it should be that **people have the best code, tools, and documentation that we can reasonably provide in each release**. We should evaluate every rule, policy, process and action against that goal. That should be the one line *raison d'être* of Perl 5 Porters. That's the new Rule 1 in the absence of Larry Wall, and the foundation of everyone's involvement.

I base this philosophy on one main concern: that most of our users do not follow the Perl upgrade cycle. Most people are not going to move to the next stable release every year. That works for people who know a lot about Perl and are in it up to their elbows, but that is a very small group of people. Once stable at 5.14.1 or .2, for instance, there's often not a need for most people to migrate to Perl 5.16. The critical bug fixes make it into the maintenance releases already, and people using Perl 5.14 aren't using features that are in Perl 5.16.

The common case, I assert, is that most people will upgrade to a major version less frequently than once a year. Many of the people I talk to are still using Perl 5.10, which isn't even officially supported anymore. Some people have moved to Perl 5.12 even just as Perl 5.14 has come out.

This isn't an unreasonable case, either. How much testing and deployment and configuration management do we want to force onto users? How much of their work should be managing Perl and how much of that should be using Perl to make the world a better place? The users want to stabilize their installations and spend their time on other things.

Knowing this, how long does it take a significant documentation change, such as the [my revamped version of perlvar](https://github.com/Perl/perl5/blob/7fd683ff3c3d87594a83a2b7f05232241c17d44b/pod/perlvar.pod), to get into the hands of users? It's available immediately through the online documentation, but for a version of Perl most people aren't using.

## The future (circa 2012)

We know what the future is when defending the policy is the paramount goal; it either kills development or changes it so that everyone leaves. I don't think Perl is there yet, but I think it's heading in that direction. Instead of being a land of possibility and exploration, it's turning into a cubicle farm.

There are many other things that the Perl 5 developers might do. Since they are using Git, they aren't stuck with mainline, centralized development, which *blead* still is. Much larger and more complex projects, such as Linux, effectively use source control to handle many lines of development.

## Looking back from 2020

I never published this (as far as I know). I was worried about this at the time, but in hindsight I didn't need to worry about most of this. Things stabilized, there was no major disaster to avert, and life moved on.

However, as I recall, this is near the time I stopped contributing to the documentation after a couple of release managers and the pumpking outright told me my contributions weren't important. At the time I was keeping the *perlfaq* up-to-date and working to re-organize other small parts of the Perl documentation.

Part of that sentiment I certainly think was a holdover from Perforce. A limited group of people had commit bits, so the process was setup for someone to actively capture and merge contributions. With git, things were fuzzier and the transition to someone actively capturing to someone more passively merging was a bit painful. The diffusion of responsibility didn't make it immediately clear what the new process should be.

This limited-access situation continued somewhat with *git* because Perl5 Porters had a privately-hosted git server. Someone had to deem you worthy of commit access and a representative of the corporate sponsor had to then configure that.

But, in October 2019, Perl gave up its insistence on doing their own
thing and moved to GitHub. Part of this was to escape Request Tracker as the bug reporting mechanism (another "not invented here" problem). In short, the burden of maintaining an email based system was too distracting and increasingly fragile. GitHub Issues solves most of this: no maintenance, better interface, easy public access, and metadata. Most of all, there's a way for any GitHub user to make and watch a pull request.

Perl 5 is doing fine. The very capable Sawyer X has been shepherding the effort for many years and many people have worked hard to right the ship. So, no worries.

## Looking back from 2021

Maybe I was too optimistic last year. Some Perl maintainers led a coup that deposed Sawyer X and installed a committee in his place. That's the best tactic to prevent change and progress. As Nicholas Clark pointed out, this committee has no power because nobody has to obey it either affirmatively or even passively.






