---
layout: post
title: Why I didnt submit that patch
categories: perl programming
tags: github dzil dist-zilla
stopwords: IDEs Rik SourceForge devs
last_modified:
original_url: http://www.defectiveperlprogramming.com/2014/01/08/why-i-didnt-submit-that-patch/
---

*I originally posted this on a blog that no longer exists*

[Ovid notes his three requirements for submitting a patch](http://blogs.perl.org/users/ovid/2014/01/why-i-didnt-submit-a-patch.html):

<!--more-->

* The other devs should be pleasant to work with
* The code base should be relevant to me or at least fun
* The barrier to entry should be as low as possible

I don't particularly care about the first two, but the third is why I became a Perl user. When I started with Perl, I liked that I didn't have to have any special tools, IDEs, editors, or anything else. If I had `perl` and `vi` (emacs you had to install extra!), I could work, even if it was with Randal “I never leave emacs” Schwartz. I could work in a way that was comfortable for me, and I think this is a big part of why Perl and PHP have been so successful.

Point 3, though, is why I recently posted to twitter “Maybe all these Dist::Zilla users can add something to their repos that tells people what to do with them to build them.” after encountering another repo (not on CPAN) that I wanted to use but had no instructions on what to do with it.

If I want to do a drive-by patch—something I think I can do in under five minutes, then ease of process is paramount. That's what GitHub has done for us. If I have to install Dist::Zilla again (like for the Perl v5.18.2 I just installed), I've used up my five minutes for thinking about the problem and I'm on to the next thing. It's not because I don't want to contribute, but that the developer has intentionally made it difficult to contribute.

Ovid's particular problem is with Adam Kennedy's SVN repo. Those who have been around long enough know that Adam had a really nice setup with existing technology. Subversion was good because it fixed a few very annoying things with CVS, but sharing was still hard enough that SourceForge couldn't figure it out. Adam made it so anyone could get an account and in ways that were convenient to them. As I recall, you could do it by text message. He solved the problem of getting the account and fetching the sources without waiting for a human. But, git killed most interest in Subversion and people forget what Adam had started with (even if he was a git holdout).

With `dzil`, which I don't use just because I don't, easy is not the case. I have to replicate a development environment before I can start. It becomes something that's blocking my to-do list instead of filling a spare moment when I take a break. Installation from my local CPAN took six minutes, and that's just the base package without the plugins I don't know that I need yet. `dzil` people counter that I can still use `prove` without all that, but what if my patch is something that's not code? More than a couple of times I couldn't discover where the text from a file came from and I suspected it was a plugin problem. I'm not going to chase down those problems, and I might not even report it because by that time I realized I've spent too much time on the problem. You may not like that attitude, but I assert that's what how people react to this. Not most people you know, but most people in the universe.

I had talked to Rik about this at some workshop and he said he'd realized that he'd have to accept reports with test cases on the released distribution instead of a patch on the repo and he was fine with that. That always feels weird to me and I hate when people do that to do instead of just sending a pull request.

It gets to be a religious war, and if you aren't part of the clique, you're sometimes told explicitly to go away, in the same way people divided themselves into the “Modern Perl” camp and everyone else. Other people start to evaluate you based on which flag you fly; I've known really good programmers who were denied jobs because they hadn't read [Modern Perl](http://modernperlbooks.com) when they were the sort who could have written it. It's the same problem with the blind adherents to *Perl Best Practices*. Moose is a bit of the same way. I was interested in it early on, and I won't out the person who promised—not just told, but promised—that it would be three self-contained files. Now it's a fractured and confusing landscape of variants and extra plugins.

If this had been the state of Perl when I started, I probably would not have kept at it. I didn't have to choose sides. The dirty secret of Open Source (the capitalized version) that Ovid notes is that people are selfish and work when it's economic for them. If you want people to contribute, you have to make it easy for them, or at least easy enough that they've contributed before they realized they spent too much time on it. The more you make contributors into a clone of yourself, the fewer people you have available as collaborators.
