---
layout: post
title: Fixing a Perl module in the middle of a GitHub workflow
categories:
tags:
stopwords:
last_modified:
original_url:
---

A third-party Perl module updated its minimum Perl version and broke a large part of the automated testing and release of one of my Perl modules. I had to do a little brain surgery to fix this, and it's not even the fix I'd really like for this sort of situation.

<!--more-->

Back in March, [HTML::Tagset](https://metacpan.org/pod/HTML::Tagset) released a v0.24, which bumped up its minimum Perl version of v5.10. This new minimum version means that it eventually blocks the installation of [LWP](https://metacpan.org/pod/LWP), the original Perl web user-agent code, which works on v5.8.

## Discovering the minimum version

However, none of the code uses v5.10 features, which is something I'll get to in a moment. First, what should the minimum version be if we looked at just the code?

[Perl::MinimumVersion](https://metacpan.org/pod/Perl::MinimumVersion), which you can run from some other perl, can analyze the syntactical features you use and guess the minimum perl you need to run just that code (but maybe not that for whatever you load). It comes with `perlver`:

{% highlight text %}
$ perlver lib/HTML/Tagset.pm

   -------------------------------------------------
 | file               | explicit | syntax | external |
 | ------------------------------------------------- |
 | lib/HTML/Tagset.pm | ~        | v5.6.0 | n/a      |
 | ------------------------------------------------- |
 | Minimum explicit version : ~                             |
 | Minimum syntax version   : v5.6.0                        |
 | Minimum version of perl  : v5.6.0                        |
   -------------------------------------------------
{% endhighlight %}

Even then, many times you don't need some of the later features. I'm often bitten by the defined-or operator  (`//`) when I'm working on v5.8 legacy code. I use it out of habit, but the conditional operator gets me to the same place:

{% highlight perl %}
$answer //= $default;  # v5.10 defined-or binary assignment

$answer = $answer ? $answer : $default;  # v5.8
{% endhighlight %}

I'd much rather have the binary assignment (`//=`), but code that other people want to use isn't always (almost never) about what I want. As much as I hate to accept it, there are people doing things in old perls.  I try to support whatever perl version the tool started with. With new stuff, and no installed user-base, I try to support whatever the common system perl is (which is around v5.30 now I think).

Some of these tools want to use LWP, which supports v5.8 in its own
code. In general, I prefer
[Mojolicious](https://www.mojolicious.org)), but the current
Mojolicious supports only v5.16 and later. For anything before that,
LWP it is.

## Breaking the build

There are two types of people in the world: those who have broken the build, and those who will break the build. We're all either there now or will be there. It's not a big deal that these things happen and they aren't that hard to fix, say, relative to everyone affected by CrowdStrike who had to physically visit every affected machine. Still, it's annoying when my time is hijacked to fix something that shouldn't have changed.

I have a set of standard GitHub workflows ([briandfoy/github_workflows](https://github.com/briandfoy/github_workflows)) that work all the way back to Perl v5.8. These change frequently to respond to GitHub changes and are updated in each of my repos as I work on them. As such, I won't see some breaks until I work in a repo again.

I have thought about weekly builds to merely test against current CPAN, but so far I haven't set that up; GitHub Actions won't run [a scheduled action after 60 days of no action](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#schedule) on a repo. I haven't wanted to administer that yet, but that would probably use the REST API to [enable the workflow](https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#schedule) when it's disabled. That's a whole other thing.

Installing LWP is going to install its dependencies too. That means that anything that LWP depends on needs to support the same minimum perl version, or, LWP needs to take on the minimum perl version of its dependencies. When there's a mismatch, such as a using v5.8 to install LWP, but then getting to HTML::Tagset, which declares it needs v5.10, the HTML::Tagset installation fails. When that fails, the LWP installation fails too. This breaks the workflow even though it doesn't break my code.

In this case, the failure comes from two lines in the *Makefile.PL*. First, there's `use 5.010000`. When perl with a version less than that tries to run that *Makefile.PL*, the script fails to run. This is how CPAN Testers knows to issue an "NA" (not applicable) report: it sees and recognizes this particular error message from *Makefile.PL*.

There's also the `WriteMakefile` metadata line `MIN_PERL_VERSION` which also declares the minimum version. That information shows up in the *META* files, which other tools look at to decide if they should continue.

Those are the only two things that go wrong in this case. Without those, everything works fine. The code runs just fine on v5.8 and all of the tests pass.

## Updating workflows

As an aside, I have my own, bespoke tool to manage my Perl module repos. My [bmt](https://github.com/briandfoy/app-bmt), which is targeted at my own sort of development and is not for people who want to do everything different (which is everyone but me, I bet). I make the change in one place and easily get it when I update a new workflow. This just pulls from the latest files in [briandfoy/github_workflows](https://github.com/briandfoy/github_workflows):

{% highlight plain %}
% bmt update_workflows
{% endhighlight %}

In reality, I use a more expansive function that updates everything that might need updating in a repo. Not all of this is related to files in the repo:

{% highlight plain %}
% bmt update_all
{% endhighlight %}

But, workflows, and most CI things, tend to be very brittle. One thing in the environment changes and it's a pain in the ass to get it working again. Failing to install LWP is that sort of change. Yes, there are fallbacks to wget, ftp, and so on, but I've found those to be flaky in GitHub Actions, which reinvents the shell, but as YAML. Well, there goes my weekend I guess.

As with everything, the first thing is to report the issue and make a pull request to the offending code. I've done that work in [libwww-perl/HTML-Tagset#14](https://github.com/libwww-perl/HTML-Tagset/pull/14), and it's only been a week.

## The fix

I have more to write on this matter, but it's time to give you the answer if you want to bail out of this article. I took two parallel approaches. One is the right, general approach but is harder to implement in GitHub workflows and I will push off onto a different article. The other is the kludgey, specific approach which you'll get here. This is the duct tape and bubble gum holding things together until someone fixes HTML::Tagset.

However, there's something I have to take into account.

One of Perl's biggest hidden, current challenges if that much of its third-party code is virtually unmaintained. There are approved pull requests in foundational modules that go nowhere (e.g. [Perl-Toolchain-Gang/CPAN-Meta#139)](https://github.com/Perl-Toolchain-Gang/CPAN-Meta/pull/139), or my patches to my own code in [CPAN.pm](https://github.com/andk/cpanpm/pulls/briandfoy) where I do not have repo permissions), there are fixes to user-reported issues, but no action. These contributions aren't even acknowledged by the maintainers.

This situation should inform and moderate changes to deep dependencies. We shouldn't make changes if we are going to be the unresponsive author, and we shouldn't be the caretaker of something that we are going to ignore. Or, at least, give other people the power to fix things. This is different than the power to develop new features, which should be more judicious and slower.

Part of this is that people do not have good processes, just like almost everyone is before they get a good process. It's easy to forgot about things, or not even realize there's something for you to do. Until I stopped using email as my To Do list, I had the same problem. Sometimes I wouldn't even know there was an issue because I never saw the email.

Now I have a link I look at everyday (and have yet to turn into an RSS feed). In GitHub issues, I can construct a search of all of the issues in all of my repos. It looks like this: *https://github.com/issues?q=is%3Aopen+-author%3Abriandfoy+user%3Abriandfoy+-label%3Astalled+-label%3A%22Status%3A+stalled%22+-label%3A%22help+wanted%22+-label%3A%22Status%3A+needs+help%22*

This breaks down to:

* author (repo owner) is me
* issue is open
* label does not include "stalled", "help wanted", or "needs help"

Along with this, I try to respond to every issue right away, even if that is to say that I can't look at it right away. Even then, it stays in the list of issues I see behind that link.

To make this work, I have an expansive set of labels that I normalized across all my repositories. It's all inside that *bmt* tool, but it's easy for me to update when I add or rename these shared labels:

{% highlight plain %}
% bmt update_github_labels
{% endhighlight %}


### CPAN.pm distroprefs

First, the fix I won't discuss in this article.

CPAN.pm is amazing; it has a way to know about and locally apply patches to unfixed distributions that need adjustment. I wrote about these in [A CPAN distroprefs example](https://briandfoy.github.io/a-cpan-distroprefs-example/).

But, this involves adjusting the CPAN.pm configuration to provide two values (maybe one outside of GitHub workflows). CPAN.pm needs to locate the distroprefs configuration, which is a text file, and the directory that holds patches. If these could be environment variables this would be so much easier, but that doesn't exist.

I'm still trying to figure out how to make this work. So far the problem is getting CPAN.pm configured using only shell commands. Seems easy and I'll write about that later once I get all the pieces working.

### Cut-rate brain surgery

Instead of the nice way, I'll simply download the latest HTML::Tagset distribution and fix it in place. I could do this with patches and would be that if the changes were extensive, but this fix is simple. I add a little bit to my standard GitHub workflow, which is easy to revert if this problem is fixed.

Here's the new step in my [perl-module-ubuntu.yml](https://github.com/briandfoy/github_workflows/blob/master/perl-module-ubuntu.yml) (version 20240920.001):

{% highlight yaml %}
            - name: fix html-tagset for v5.8
              if: env.PERL_VERSION == 'v5.8'
              run: |
                curl -L -O https://cpan.metacpan.org/authors/id/P/PE/PETDANCE/HTML-Tagset-3.24.tar.gz
                tar -xzf HTML-Tagset-3.24.tar.gz
                cd HTML-Tagset-3.24
                rm META.*
                mv Makefile.PL Makefile.PL.orig
                perl -n -e 'next if /(^use 5)|(MIN_PERL)/; print' Makefile.PL.orig > Makefile.PL
                cpan -T .
                cd ..
{% endhighlight %}

The process is mostly simple:

* download the dist, unpack, and change into its directory (easy)
* remove all the META files (hacky, but they have references to `MIN_PERL_VERSION`). I ignore the warnings about these missing.
* modify `Makefile.PL` to remove lines with references to v5.10. This works in this case because the entire line needs to go away.
* install the local distribution without testing (`-T`)
* change back to the parent directory

After this, HTML::Tagset is installed on v5.8 and another distribution that needs it will see it is already up-to-date.

Note that I have a condition on this step so it only happens when the Perl version is the affected version. I set up `PERL_VERSION` in an earlier step since I also need it to guard some other steps.

# It didn't have to be this way

The [*Changes* file for HTML::Tagset](https://github.com/libwww-perl/HTML-Tagset/blob/dev/Changes) notes that the maintainer doesn't have the infrastructure to test on v5.8:

{% highlight text %}
2024-03-09  Andy Lester

        * Release 3.22

        HTML::Tagset now requires Perl 5.10.1. It might run on earlier
        Perls but I don't have the infrastructure to test them.
{% endhighlight %}

But, of course GitHub workflows have that, because I'm doing it. I don't even have to do anything that special.

And, how does GitHub get Perl v5.8? It downloads a pre-built image. If you have Docker, you can get that image too.

Beyond that, there is CPAN Testers. Upload your distribution as a trial version, let CPAN Testers take a whack at it, and in a week you have tens, or even hundreds, of test reports on different systems, different perl versions, and so on. Back in the day before CI services, this was amazing. Now you're saying "wtf waiting a week?". But, in many cases you don't need to release your code immediately. This isn't a CVE hotfix; take the time to act responsibly for something that's going to affect the basic Perl toolchain.

## Testing on old perls

It's not hard to test on old perls. The easiest way is to just ask someone to test it for you if you don't want to do it yourself.

You used to be able to say "But Windows!" and everyone would sigh and commiserate with you. But now you have Docker or WSL. There are cases where this won't work, but I think those are uncommon. And, even if that doesn't work, there are at least three easier ways to do this.

I don't know what systems were available or preferred on the developer's side. [perlbrew](https://metacpan.org/pod/App::perlbrew) can do this for you, but the process is simple:

* download the source from [CPAN.org](https://www.cpan.org/src/README.html). These go back to v5.8.9
* use [Devel::PatchPerl](https://metacpan.org/pod/Devel::PatchPerl) to run `patchperl` to adjust the legacy perl sources to build with modern tools. I built v5.8.9 on my M2 MacBook Pro.
* compile and install perl

Don't go past this point too quickly. Perl has tools to install old perls and maintains patches to those old distributions for current tool sets. Does anyone else do that? Maybe they do but I don't know about them.

There's also CPAN Testers. Release a trial version and wait a bit for the network of volunteer testers to download your trial, run its tests, and report what it finds. The current [CPAN Testers results for HTML-Tagset](http://www.cpantesters.org/dist/HTML-Tagset) show at least three reports for v5.8.

# Final thoughts

In short, this change should have never happened. If you maintain something, eventually you'll make some sort of bad mistake like this. I've probably done it somewhere. It happens.

I understand that people don't want to support v5.8. That's fine. But when the thing you are working on supports something that supports v5.8, you have limited good reasons to subvert that. It's certainly worth guarding a deep dependency with the minimal effort to check if your version upgrade would upset things. MetaCPAN will show you [reverse dependencies](https://metacpan.org/module/HTML::Tagset/requires), but these are only the distros that explicitly depend on that module.

It's a dependency on highly upstream Perl modules that declare they run on v5.8. You don't get to decide that they don't support v5.8 because you don't want to. This is even worse
