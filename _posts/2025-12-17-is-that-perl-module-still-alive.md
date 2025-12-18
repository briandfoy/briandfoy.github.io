---
layout: post
title: Is that Perl module still alive?
categories: perl pause
tags:
stopwords:
last_modified:
original_url: https://www.reddit.com/r/perl/comments/1por46u/poe_module_still_alive/
---

How do you determine if a Perl module is "alive"? This question from [/r/perl](https://www.reddit.com/r/perl/comments/1por46u/poe_module_still_alive/), and I think it deserves a thoughtful answer. I did [answer in that thread](https://www.reddit.com/r/perl/comments/1por46u/comment/num52ex/), but I thought I'd expand that.

<!--more-->

These ideas apply to any software, but the particulars are for Perl. The question was specifically about the [POE](https://metacpan.org/pod/POE) module.

Consider what I typically look at when I'm evaluating a module. Although we are looking at POE, this is the same sort of evaluation you might go through with a distro, judging based on your context how much these matter to you.

## Is there a more alive alternative?

Is there any other way to do this that's current and maintained? For example, I "maintain" Net::SSH::Perl, which I paid another contractor (who paid yet another contractor) to write for one of my clients. But, people should use [Net::OpenSSH](https://metacpan.org/pod/Net::OpenSSH).

Part of this is to not be fooled by release dates, since minor things, such as a *LICENSE* or *SECURITY.md* file to bring the distro up to current standards, doesn't make the code any more recent. Have the releases included substantive changes or bugfixes?

My goal is that all of my distros pass the same basic checks so I can maintain them in bulk. If one gets a new file, like *SECURITY.md*, they all get that file (as appropriate).

## How old is the current release, and what's the velocity?

The last release of POE was at the end of 2022. Some things are just done and don't need new releases; Dominus's [remarks on his Template module](https://perl.plover.com/yak/12views/samples/notes.html#sl-9) are interesting. I don't think POE is in that bucket.

The most recent merged pull request is from 2019, and that's a Pod fix. The last substantive merged pull request is from 2015. ([closed pull requests](https://github.com/rcaputo/poe/pulls?q=is%3Apr+is%3Aclosed))

## What are the open issues?

On [MetaCPAN](https://metacpan.org/), you can look at the number of open issues in the left menu. POE still uses the sunsetted [rt.cpan.org](https://rt.cpan.org) (red flag), and there hasn't been a maintainer reply to an opened issue since Dec 2022 there (and even later in the GitHub pull requests).

Likewise, the "Testers" link to CPAN Testers is helpful. Even if a module is maintained and has repeated failures on your platform across several versions, it's not really "maintained" for your purposes.

The GitHub repo, [rcaputo/poe](https://github.com/rcaputo/poe) has open pull requests, most of which are simple usability fixes for the distro.

## Who is involved?

Some of the people involved with POE are the sort to adopt modules merely to keep the lights on. If you see my name (on a module I didn't invent myself), Todd Rinaldo, and a few others, it's a sign that the module has reached the point where no one is interested in fixing it.

Indeed, I have more than a few modules that I keep alive (usually at the request of clients) but have never used, never substantially edited, and have no idea how they work. I will apply fixes if they work and make sense, so I'm really just a janitor.

## Are those people active?

Along with that, you can look at the activity of any of the comaintainers of a module. In this case, that's BERGMAN, APOCAL, BINGOS, BSMITH, CFEDDE, HACHI, MARTIJN, and XANTUS. But, I only know that because I am a CPAN author, looked into PAUSE, and used "View Permissions". (a comaintainer is merely a person who is allowed to upload a new release). Without a PAUSE account, you can use [cpanmeta.grinnz.com](https://cpanmeta.grinnz.com/perms).

Beware, though, that their most recently uploaded release in the PAUSE data files might not be their most recent activity. Say BINGOS released a new POE yesterday, and CFEDDE then did that again today, you wouldn't immediately see BINGO's activity. However, MetaCPAN shows you prior versions, the uploader, and the date in the "Jump to version" pull-down. RCAPUTO made a release in 2015, BINGOS revived it in 2020, and then there's the 2022 release.
