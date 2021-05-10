---
layout: post
title: CPAN's Social Continuity of Code
categories:
tags: cpan perl
stopwords:
last_modified:
original_url: http://radar.oreilly.com/2014/02/cpans-social-continuity-of-code.html
---

Open source software has been about a large enough collection of people scratching their own itches, but as more and more people, especially those less able to scratch in the same way as the people who contribute. It's how we handle those situations that show the strength of crowd-sourcing and open source.

I contribute heavily in the Perl community, and I'm consistently impressed by the pains we take with code and assets when personally have no interest in. There's a group of Perl people who shepherd (camelherd?) code and projects that have lost their maintainers. I'm one of those people.

First, let me explain the very simple system CPAN uses, which has been working since around 1994. Basically, CPAN is a big directory structure that other mirrors rsync (see Jarkko Hietaniemi's [The Zen of Comprehensive Archive Networks](http://www.cpan.org/misc/ZCAN.html)). People contribute code through the [Perl Authors Upload Server (PAUSE)](http://pause.perl.org), which does some light verification for identity and permission for the namespaces in that code. No one really "owns" a namespace in Perl, but developers have permissions to control it, including extending that permission to other developers. This is a small bit of social control  (As an aside, Perl 6's design handles this differently [by allowing people to specify an "authority" for modules](http://perlcabal.org/syn/S11.html)).

Problems arise when the developers who have those permissions wander off. Some of them might move jobs where they no longer need that code, they stop using Perl, and in recent years and with increasing frequency, they pass away. And, CPAN is growing faster than it ever has, both in numbers of new accounts and amount of code uploaded. There are more and more developers who can disappear—over 11,000 on PAUSE now.

People could fork code, but that's not very scalable and doesn't work well for the community if they have to continually change their code to keep up with development. We also don't want to require more work from new maintainers. If people can simply pick up where the work left off, we expect more people to take over existing code.

For years, PAUSE has had a [documented way for someone to "takeover" a namespace](https://pause.perl.org/pause/query?ACTION=pause_04about#takeover). We ask the the new maintainer try as diligently as they can to contact the old maintainer, including public announcements of their intent. After a suitable period, usually several weeks to account for holidays and busy lives, PAUSE admins feel safe manually transferring the permissions. It's a bit annoying in the automated world we live in, but for the most part its worked as an effective social tool to balance the rights of the original maintainers and the desires of the new ones.

In the world of [GitHub](http://www.github.com), where forking a repo is common, we see much more activity. Indeed, one of the most prolific Perl authors and a Subversion stalwart, Adam Kennedy, is moving some code to GitHub as he sees [remarkable spikes in contributions and pull requests](http://blogs.perl.org/users/adam_kennedy/2013/12/moving-ppi-to-github-encourages-some-new-activity.html#comments). Adam had created his own collobrative system around SVN with an amazing number of ways for people to sign up and contribute, but his system pre-dated GitHub's popularity. When GitHub developers wander off, it's easy for someone to pick up the code but not the permissions.

For PAUSE maintainers, the trick is knowing when the old maintainer has given up. People who [register modules in PAUSE](https://pause.perl.org/pause/authenquery?ACTION=apply_mod) (account required) can mark it as "abandoned", but people who wander off don't spend their time on such things. Even then, PAUSE is phasing out module registration since even active developers tend not to update their module metadata through PAUSE. We mostly leave this work to the person who wants to maintain the code. In some cases, that's too onerous for them, which is understandable.

A couple of years ago I created the fake PAUSE user [ADOPTME](https://metacpan.org/author/ADOPTME) as a way to keep track of which modules have lost a maintainer <i>before</i> a new maintainer showed up. Someone may have taken over one module from an unresponsive maintainer, but we then know that the other modules need new maintainers. When someone passes on, we know the same thing.

If someone asks to takeover an [ADOPTME](https://metacpan.org/author/ADOPTME) module, we can do it right away. The [HANDOFF](https://metacpan.org/author/HANDOFF) virtual user is similar, but mostly with active maintainers who don't need their project anymore. When people know they can get to work and release the updated code right away, they are more likely to continue the work of existing code instead of doing something else.

[Neil Bowers](http://neilb.org) (featured in my last post [The State of Perl](XXX Add URL)) went a step further. Where I marked modules based on affirmative information, he's trying to guess which modules have lost maintainers by looking at activity. It's not enough that a module hasn't had commits. Mark Jason Dominus notes in his [12 Views](http://perl.plover.com/yak/12views/samples/notes.html#sl-9) talk that his [Text::Template](http://www.metacpan.org/module/Text::Template) isn't dead, it's *finished*.

His work looks at the number of filed issues, the last release date, and more importantly, the number of other modules that use that code. From that, he developed his [adoption list](http://neilb.org/adoption/). Not only does this identity useful code without a maintainer, but useful code with an overworked maintainer. We now have a way to predict these problems before they happen and attract new maintainers. Active developers can check the list to see which modules they depend on is at risk of going stale, and either takeover the module or find another maintainer for it. The community can take action before it's a problem.

There's more that we can do, but it's still amazing to me that people like Neil and the PAUSE admins spend so much time thinking about code they don't necessarily use or even care particularly about. That's the attractive thing about open source and the Perl community.

I'm curious how other communities handle these situations? Do people simply abandon code in favor of shinier or new libraries, or fork code (even internally)? How do other communities handle social control? Let me know in the comments (or convince your own favorite programming blogger to spell it out).

