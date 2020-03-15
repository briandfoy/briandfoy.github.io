---
layout: post
title: The Perl Bus Factor
categories: opinion perl
tags:
stopwords: Klint
last_modified:
original_url:
---


Klint Finley's article for *Wired*, [Giving Open-Source Projects Life After A Developer's Death](https://www.wired.com/story/giving-open-source-projects-life-after-a-developers-death/), discusses the trouble taking over Ruby projects when the lead developer dies. He interviewed Neil Bowers, one of the people who helps maintain the Comprehensive Perl Archive Network (CPAN), but then he mangles the information to make it seem like the Neil by himself sometimes finds volunteers to take over projects if he feels like it at the time.

The PAUSE (Perl Authors Upload Server) admins do much more than that. We've had an official policy around it for years. I remember the first time we had to deal with this. Over a decade ago [Iain Truskett, an important Perl developer, passed away](http://archive.oreilly.com/pub/post/perl_loses_contributor_and_col.html). Andy Lester took it upon himself to act as a executor of the developer's CPAN packages. He didn't want to maintain them necessarily but he would transfer them to anyone who wanted to handle them. As I recall he took over the CPAN account and merely used its existing tools to transfer permissions.

Some time after that [I created the virtual user ADOPTME](http://blogs.perl.org/users/brian_d_foy/2013/02/mark-your-modules-as-adoptable-if-you-dont-want-them.html) on CPAN. When a developer passed away I used my PAUSE authority to transfer the ownership of their modules to ADOPTME. Their code and their uploads were still there but if someone else saw that the owner was ADOPTME, all of the PAUSE admins knew they could immediately transfer the modules to a new maintainer. Otherwise we followed our purposely slow process of trying to verify the ghosting of a developer. If after several weeks we could not get a response we'd transfer the module. If the original developer showed up and objected we could reverse everything.

I don't recall when we created HANDOFF, but we used that as a virtual comaintainer. A developer could add HANDOFF as a virtual person to their projects to signal that if anyone wanted to maintain that code the original developer would give it up. This virtual developer owns no code and makes no releases.

If I added HANDOFF to my code and disappeared from the Perl world any of the PAUSE admins would know that I wouldn't care if they transferred it to another developer immediately. They wouldn't have to go through the slow process of trying to find me then get a response. We encourage people to add that virtual user before they think it will be a problem.

We also have the virtual user NEEDSHELP. Developers use that to signal that their code needs comaintainers and they are open to collaboration.

Recently Neil took the lead on developing a more formal PAUSE policy for the informal actions that we had been allowing. This wasn't a new thing though. Neil (and many other admins and non-admins) had been thinking about and acting on this for years. Neil created and maintains the [CPAN Adoption Candidates](https://neilb.org/adoption/). The PAUSE admins try to solve these problems before they are problems.

We've been thinking about this for 15 years and have ways to handle it. But, CPAN is different in another way that helps this. PAUSE doesn't care where you develop your code, which source control you use, and so on. You package your code (usually a simple tar archive) and upload it. Once uploaded it's checked then mirrored to several hundred servers across the world. It's just the packaged files. If the original developer disappears, CPAN doesn't need to transfer his various third-party accounts. A developer can fork a GitHub project and keep going (although the transfer of issues and so on is a problem).

The trick is to capture the value as soon as possible. CPAN would have a much harder time if it was just a list of GitHub projects. Those can change URLs, go private, or be deleted. It's also much harder to use a particular version. Once uploaded, PAUSE controls the packages with the actual code. Although a developer can delete uploaded packages we also have a historical record, the BackPAN, that has almost everything ever uploaded modulo some legal takedowns and not even then. Anyone can rsync the BackPAN and never delete anything.

I've spoken to more than a few communities about how they can run something as hardy as CPAN for their language. They usually ignore all of the low tech advice.
