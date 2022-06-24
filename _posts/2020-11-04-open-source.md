---
layout: post
title: Open source is not about money, or you
categories: open-source
tags: randal-schwartz simon-phipps clojure
stopwords: Bianculli READMEs Cognitect's Stallman's emptor deps gifter offerer codebase NYU contraindicative codebase
last_modified:
original_url:
---

A friend sent me a link to a gist from Rich Hickey, the inventor of Clojure, discussing his idea of the community's relationship to his open source project. In [Open Source is Not About You](https://gist.github.com/richhickey/1563cddea1002958f96e7ba9519972d9), he lays out his idea of the relationship:

<!--more-->

> Just because someone open sources something does not imply they owe the world a change in their status, focus and effort, e.g. from inventor to community manager.

He's ranting and his frustration is clear. It happens. As the head of a community, elected or otherwise, that's how it goes sometimes. Leadership is hard, and not saying everything you think is part of that. It's regrettable, but we all make mistakes.

But, Rich also makes a dubious claim:

> We are in no way building Clojure for profit.

"No way" is pretty strong qualifier. Rich is the CTO of Cognitect, a company that sells Clojure services. They develop Clojure projects for pay. There's a very identifiable and apparent economic motive, and there's very identifiable and apparent economic activity. There's no problem with that.

It's a staple of the "open source" ethos that money or gain is immoral. Open source people have to pretend that money is meaningless, mostly because some of the notable people who started this movement had other political ideas and tended to ignore anything outside of coding to the point that they were literally homeless or couchsurfing. It's a convenient fiction that celebrates a false virtue for acceptance.

This fiction is so ingrained in the open source culture that most people don't even realize its there. It's one of the reasons that open source has the heroes it does. The people who want to live indoors, have and feed families, and prepare for retirement have different motivations. People who want to run businesses have different motivations.

Consider what else Rich says:

> I spend significant portions of my time designing these features - spec, tools.deps, error handling and more to come. This is time taken away from earning a living.

You don't get to say in one breath that you aren't doing it for the money then imply that you should be making money. But it's virtue signaling.

For what it's worth, any good coder is going to spend considerable non-billable time learning and exploring things. That's what allows them to make a good living.

There's no heroism here and there shouldn't be any pity. That's capitalism—you put up the initial resources for the chance to do what you want in the way that you want. You make money and you help other people make money. You're a job creator. That's a good thing.

## Actual open source

Open source isn't about doing free work or not making money. That's an extra political layer that's been bolted on quite early in the free software movement, which went from [Richard Stallman wanting the source](https://www.gnu.org/philosophy/rms-nyu-2001-transcript.txt) for a proprietary printer to thinking that any corporate interest was wrong.


Simon Phipps expressed it best in his interview with Randal Schwartz on [FLOSS Weekly #39](https://twit.tv/shows/floss-weekly/episodes/326) (starting around 14:30):

> Randal [Schwartz], I don't care what your motivations are for being involved in Perl. They're of no relevance to my life because our relationship around Perl depends on code. And, the code and the community are transparent. But your motivations and my motivations for participating in it are opaque. They are private to me. ... So I'm able to maintain my privacy around my motivations and the degree of my involvement and how I'm funding it. I maintain responsibility for that what is private as well. On the other hand, I'm able to work in an environment of transparency where all the code is known, all of its origins are known, all of its defects are potentially known. And that combination of transparency with privacy is in my opinion what characterizes open source. Trying to define open source in terms of licenses is kinda outmoded in my view. Open source is about the transparency at the community level but also the privacy in terms of my motivations and belief systems.

When I contribute to a project, I don't care if they are making money or even what their political beliefs are. I care that the thing I want to use works as designed and works for my use case. If I don't contribute, I'm worse off no matter how much money the other side makes. It's much easier to have those patches upstream.

## Gifts aren't free

But that's not the main issue:

> Open source is a no-strings-attached gift, and all participants should recognize it as such.

Gifts aren't free and are often statements on what people think of you and how they want to influence you. Consider Richard Stallman's inchoate idea of free software: Xerox gave MIT a "gift" of a laser printer, and that "gift" didn't quite work. He tells the story in his 2001 speech at NYU—["Free Software: Freedom and Cooperation"](https://www.gnu.org/philosophy/rms-nyu-2001-transcript.txt).

A "gift" is a trap. When you use a free service, or a 30 day free trial, or whatever, you aren't really getting that for free. The offerer wants a certain conversion rate and you are participating in that market research for free. Even if you don't convert to a paying customer, your actions and feedback are valuable to the gifter. Typical, this works out for both sides, but its not equally valuable.

Cognitect, by pushing Clojure as a good way to do things, has a monetary interest in making people believe their assertion. Community size, widespread adoption, books, conferences, and many other things feed into the reputation of the project and Cognitect's ability to sell it to customers.

But, as Tommy Smothers said about the audience of his CBS show, _The Smothers Brothers Comedy Hour_, "if you aren't paying for it, you are the product". Network TV creates shows to build audiences, then sells those audiences to advertisers. Everyone understands that today because that's the dominant business model of Google and Facebook, but there was a time when it wasn't so apparent. David Bianculli goes through the sordid affair in [Dangerously Funny: The Uncensored Story of "The Smothers Brothers Comedy Hour"](https://amzn.to/2U4LFoC).

Likewise, open source projects build audiences to give projects legitimacy. The more users, the better able you are to sell into a client. It's a virtuous cycle of more GitHub stars gaining more GitHub stars. That popularity unlocks book contracts and conference gigs. Eventually, some team of developers in some commercial enterprise will want to play with the hot new tech and will get their employer to allow them to carry out that speculative development. Some of those teams buy consulting services.

That "customer" investment isn't free and it's valuable to the open source project. Both sides typically realize that. _Caveat emptor_. But, I've seen very few places that can get past the sunk cost fallacy, and there's one side that counts on that.

## Free labor

One of the original ideas of "Open Source" is that "all bugs are shallow". We know that's not scientific, and most developers probably have contraindicative experiences. Most people can't reliably identify or fix bugs, and many bugs require far more than casual inspection. Part of this idea, which Eric Raymond calls "Linus' Law", it the formal statement that echos the [infinite monkeys idea](https://en.wikipedia.org/wiki/Infinite_monkey_theorem):

> Given a large enough beta-tester and co-developer base, almost every problem will be characterized quickly and the fix obvious to someone

This mathematically-correct but implausible idea has other consequences. An open source developer gets free labor by releasing code then encouraging people to use it. You don't need a testing or QA team when you crowdsource it from the internet.

Identifying and reporting those issues are a cost to the user. This is even a worse position than so-called "gig-work", although the dirty secret of open source is that companies pay for all those contributions because most people carry out these activities on the clock.

## Project stewardship

But, as Rich explains, contributions to Clojure are often low quality (but so is feedback from testers, often). They know something is weird, but not how to fix it. Not only that, as casual participants, they aren't aware of all of the processes and history. Read [Should Cognitect Do More for Clojure?](https://lispcast.com/cognitect-clojure/) for some of the flavor of the tension between the maintainers and the community.

Clojure is a very conservative project with a strong, single-person leader. I think that's that best model for global success. Someone has to be the spiritual guardian of the project so it doesn't turn into a Homer Simpson's dream car.

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/1kshrfvkLZE" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

But, as Steve Jobs like to quote Henry Ford saying:

> If I had asked people what they wanted, they would have said faster horses.

However, Henry Ford's conservative actions after that ("Any color you like as long as its black") allowed General Motors to eat his lunch. Ford was selling most of the cars in the US when it came up with the Model T, but had fallen to about 15% of the market with the Model A.

Low-quality contributions are just a fact of life. Incomplete thoughts, whims, and wishes are high noise and low signal, but the signal is there. Ignore it at your peril. You have to become comfortable with that messy environment. It's not perfect or optimal, but it's never going to be. Although written about the node community, [Healthy Open Source](https://medium.com/the-node-js-collection/healthy-open-source-967fa8be7951) is an interesting read in this area.

You don't expect a casual contributor who's spent a weekend on the problem to understand your processes and codebase. Even if you outline all of that in READMEs and other documents, people are going to mess it up.

The trick is then to take the good ideas and whip them into shape and to handle the bad ideas so that the next time, that contributor does better. This process is frustrating enough for Clojure that this gist exists.

Oh, and just ignore the assholes. If you don't have some being bitterly complaining, you aren't doing anything important in the world.

