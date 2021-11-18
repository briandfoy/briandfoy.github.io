---
layout: post
title: Perl's Problems
categories: opinion programming
tags: perl tom-christiansen randal-schwartz
stopwords: CMS Tachibana notest
last_modified:
original_url:
---

In [Perl's Problems](https://perlhacks.com/2014/09/perls-problems/), David Cross misattributes Perl's popularity to Matt Wright and Selena Sol (Eric Tachibana). I think that's a simplistic view of history, and I was there. Dave Cross was there too, though, and are views intersect in some areas, but I think we start from different assumptions.

<p class="callout">
We think we should change their minds instead of solve their problems
</p>

Tom Christiansen and Randal Schwartz made Perl popular by making new Perl programmers, explaining Perl, and documenting it. People who needed the things Perl allowed them to do latched on and kept going. This was, at first, a market of system administrators. These people are constantly and consistently making their own tools for novel tasks. They would work with computers for free. You might pay them at work but then they go home to work their side projects.

People like Matt and Selena fulfilled a market demand that didn't care anything about Perl. They would have happily used Java had it worked, but Java didn't (and I worked at the company that had the very first Java applet on the web since one of the principals worked at JavaSoft). Nothing that was client-side worked reliably. Matt and Selena built tools for people who didn't want to need them in the first place. They most likely be happy not being near a computer at all.

Perl succeeded in the CGI space for the same reason that the PHP products such as WordPress and MediaWiki succeed now. You could upload files over FTP (most of you kids might have never used that) and that was it. The people who used the programs in the scripts archives didn't care what they were using. They were never part of the Perl market. They were going to jump ship as soon as something better came along. "Better" means they spend less (money, time, whatever) to get the same effect or more—even if we disagree that they should want what they want. When PHP showed up, they migrated to something that was easier for them. If you ask an economist about this, he might mention [utility function](https://www.investopedia.com/ask/answers/072915/what-utility-function-and-how-it-calculated.asp), or how consumers measure preferences for inputs and outputs. A savvy economist might even note that what people say don't matter because you can only observe what they actually do.

Some Perl people like to say that they are bad at marketing, and usually right after that, they tell you what they think you need to know about Perl. That's advertising, not marketing.

The tech community is bad at marketing mostly because they don't care what other people think. Or, if they care, it's to point out how they are wrong or which minor fact they misrepresented. The culture grew up in Usenet where people would reply line-by-line to something someone posted, rather then picking up a couple of the main points and expanding on those. In this method, no point, however trivial, goes unchallenged. Indeed, one of the ways to completely miss the point is to respond to every point, thus giving everything the same import.

People who want to use Perl have two complaints:

* The syntax is too confusing

* CPAN has become a morass of dependencies

It doesn't matter if you agree with those complaints or if you think they are valid. The people who complain about them voice these two particular pain points. We're not working on those two things because we don't care that people think that. We think we should change their minds instead of solve their problems. That ignores their preferences, stated or revealed.

Perl has been doing worse on both counts. We like new things like [postfix dereferencing](http://www.effectiveperlprogramming.com/2014/09/use-postfix- dereferencing/), but it's more syntax with weird characters. I love this syntax, but it's now a bigger language. Since v5.10, new features have shown up and they've mostly been broken and lightly tested. Smart matching has been a big black eye, along with lexical `$_`, and `given`. The `state` keyword is nice, but we still can't initialize named arrays and hashes. We can initialize scalars, which can be references, but when I teach this, I have to talk about that because people naturally want to use `state` with something other than a scalar.

CPAN used to be easy, then we went a bit crazy on testing. Many of the problems I have with installation stem from test dependencies, not the code. Miyagawa created cpanminus and gave it the one feature that really matters, `--notest` (there's also a [pull request in to make this a feature in cpan](https://github.com/andk/cpanpm/pull/77), which I wrote). ExtUtils::MakeMaker now supports `TEST_REQUIRES` and `CONFIGURE_REQUIRES` which makes it easier to compartmentalize those, but inside the test modules we've taken code reuse too far to make it much more complicated and fragile than it needs to be.

The fundamental problem is that this poor Perl marketing has no fundamental goal. People assume that it's to make Perl more popular, but who cares? What does that even mean? And, should you care?

Plenty of companies make money from their Perl-based technologies, and Perl is well-supported. It's easy to find help and get fixes. Authors on CPAN respond quickly, and when they do not, we have a way to handle that too. There are Perl workshops, hackathons, or conferences every month of the year. What more do we need?

Some people contend we need more Perl applications. If we had a CMS like WordPress, people would think of Perl differently. But what would that matter? How many jobs would that create and how would it help? I use WordPress, and by dint of long experience I could probably fix small things in PHP, but that doesn't make PHP any more popular with me. It doesn't make it a better language and it doesn't change my mind. I don't use it because it's PHP. The utility I get is more than the work I put it, even despite WordPress's many flaws.

Who cares if there are more people using Perl things? Unless they are making my life better in some way, I don't care what they use. Perl isn't going to make their technologies any better. It's a language that's only as good as they people who use it. Most people don't contribute anything in return. That's what we talk about in DarkPAN. If we create a many more people who use Perl but never give anything back, does that really help us?

I've spoken to many people over the years about why anyone would want Perl to be more popular, and it usually boils down to the job market. People want Perl to be more popular so they have more work opportunities. Even that's a canard, though, because their options are limited more by geography than popularity. Furthermore, it's easy to create Perl jobs. Invent a technology and start a company that uses it. Make people work on Perl.

I think that is fundamentally flawed. I contend there's no valid reason that any technology, including Perl, should expect to survive in the marketplace. Supply is driven (in the long term) by unmet demand. Most people are surprised that solutions from twenty or thirty (or longer!) years ago still work (where is my flying car?). Trying to force a technology onto a task is the wrong way around and prevents progress. We can't get better tools if we keep using the old tools.

But even that isn't the real issue. Below all of this is the assumption that someone else should create all of the opportunities and take all of the risk. People wait for someone else to take the lead (the bystander effect). Nothing you do to Perl is going to fix that.

Still, The Perl Foundation has just announced [they've engaged a public relations firm](http://news.perlfoundation.org/2014/09/the-perl-foundation-to- increas.html). The problem is that nobody is really fuzzy on the idea of Perl. Anyone who might be able to use it already knows about it. People who might think about it don't pay attention.
