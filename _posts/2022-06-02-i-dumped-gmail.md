---
layout: post
title: I dumped GMail
categories: technology
tags:
stopwords: Arendt's Budaev Carlota Compuserve FastMail GCal Geocities Hollyfield IMAP Lazlo Maps's Schoolman Sergey comsumers de facto mak naïve organiz pobox slimey
last_modified:
original_url:
---

I've stopped using GMail as my main email account. I'm not completely shutting down my *brian.d.foy@gmail.com* account, but I'm changing over all my account contact emails in various services and so on. Maybe in a couple of years I'll shut down GMail completely.

<!--more-->

As you read this, you might ask "What about Facebook?". I tried Facebook once when it started, but then gave it up completely. I don't do social media, IRC, chat, and so on. Specifically though, I easily saw the evil that Facebook was before people really knew about it. GMail is different because it's supposed to be just mail.

Instead, I've switched to *briandfoy@pobox.com*, which is backed by FastMail. I've know about *pobox.com* forever and maybe I tried it out for awhile a long time ago. That was the extent of my research to my email alternative. I paid $250 for five years, used their easy import tools, and I was on my way. It's not as slick, it's a bit clunky, but I only miss one thing: "Filter messages like these". That's a different story.

# In the beginning

There were plenty of reasons to use GMail for as long as I did:

* I wanted to get my email from any computer, including those in hotel business centers. That seems like an odd requirement now that everything is cloud based.
* I'm inclined to use Apple services, but they are possibly more inept at services than Google has been. And their old-school email clients are the reason I preferred GMail anyway.
* I hate running my own mail server. I've done it, and that's just not how I want to spend my time.
* GMail and GCal cooperated nicely since various things such as ticket purchases automatically showed up in my calendar.

# That was then, this is now

There are plenty of reasons that people are leaving GMail:

* It was interesting in 2004, when it was better than Yahoo!, Geocities, AOL, Compuserve, and whatever else we were trying to use.
* It had virtually unlimited storage when it started, but after 17 years using it, I was bumping up against its limit. That's right, my GMail account was almost old enough to vote.
* Originally, GMail had the idea that we would never use folders because we could search, but with a couple hundred thousand email, searching doesn't work anymore. It's hard to find anything and I often don't understand how it decides what should be in the results. Labels were fancy folders.
* There were various technical oddities about IMAP and so on, but these never really mattered to me since I always used the web interface.
* Google can cut you off for any reason, or even no reason. I was locked out of my GMail account for a week with no recourse. I think I may have only got it back because a friend inside Google said something. I never found out why I was suspended. The no-customer-service module of free products worries me, and I'm worried that by using free products, I'm complicit in enticing other people to accept bad trade-offs.
* Inbox looked interesting, but was abandoned, as many interesting Google products have been. The Big Tech company doesn't have the courage or mindset to innovate. I suspect that any company that size can't innovate because their customer base won't keep up. Microsoft has the same problem. As such, GMail is legacy. Curiously, those Inbox developers left to create [Mimestream](https://mimestream.com), a desktop client for GMail.

For what it's worth, I met a Google Plus Circles developer at a launch party for that idea and I told him it was the stupidest thing ever to think that information wouldn't escape the circles. He protested, and I was a bit taken aback by the casual arrogance and condescension. It wasn't personal and it wasn't about me; these engineers literally believe they know what is best for people.

Now Google+ no longer exists; it was abandoned the same year they abandoned Inbox.

# Google makes me feel slimey

My reasons are a bit different from other people who have written about leaving GMail. I had become increasingly uncomfortable dealing with the company that removed "don't be evil" from their ethics. They instead used "Do the right thing", but that's not the same thing. The techie idea of "right" is generally naïve and tyrannical. It's the Lazlo Hollyfield Problem—all science, no philosophy.

![](/images/real_genius/passed_but_failed.gif)

It's not just GMail that believes this. It's all of Big Tech, and they are all mostly playing with other people's money. When the person using the service isn't the one paying, incentives are misaligned and

I've been troubled thinking about the Smothers Brothers and their fight with CBS. The Smothers Brothers stance on the Vietnam War threatened CBS's advertising revenue. Tom and Dick realized that the show wasn't the product—their audience was the product and they were essentially selling it to CBS. They fought back, and the both won and lost.

A couple years after the Smothers Brothers lost their show, Richard Serra and Carlota Fay Schoolman made [Television Delivers People](https://www.youtube.com/watch?v=nbvzbj4Nhtk) and paid TV to broadcast it.

> The Product of Television, Commercial Television, is the Audience

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/watch?v=nbvzbj4Nhtk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

I knew I was Product of GMail, but little evils didn't seem that important (but isn't that Hannah Arendt's entire thesis in the *Origins of Totalitarianism*?). Google was a small company differentiating itself in an unsophisticated marketplace and that was compelling. But, it was also boiling the frog. Over time, many tiny things turn into a big thing that I wouldn't have accepted all at once. Exchanging free email for innocuous ads was one thing and unlimited storage with full text search gave way to mandatory participation in the entire G-Suite, surreptitious location tracking, and cooperation with police overreach (even if the courts do allow it).

I was taking part and enabling a system that I knew was hurting the world. Commercial advertising hurts the world, and Google's particular model is an insidious version of it. It is bad for comsumers and it is bad for advertisers, and it is bad for the world.

Instead of "organiz[ing] the world's information and mak[ing] it universally accessible and useful", Google is corrupting and misdirecting information to separate people from their money. And, they aren't even doing a good job on the information. My willing participation in a system that I know does this bothered me more and more.

Google Maps is a good example of this. It was the coolest thing ever, but increasing overwhelmed users with commercial listings rather than good map information. It was making mapping details less useful. Why is My Maps so much different from Maps, and why is it so hard to share information between the two (my guess is that they are run by separate teams that don't collaborate or My Maps is *de facto* abandoned). And why are both so far away from Google Earth?

It's increasingly harder to navigate Maps's crowded interface of businesses. Even searching for an exact match business is now difficult because Google obscures it under the distractions of their preferred results.

# I had already cut off most of Google

I had slowly cutting off Google by disallowing my computers to talk to their computers. There are 150+ entries in my */etc/hosts* file:

{% highlight plain %}
0.0.0.0		googleads.g.doubleclick.net
0.0.0.0		ssl.google-analytics.com
0.0.0.0		www.google-analytics.com
0.0.0.0		plus.google.com
0.0.0.0     www.googletagservices.com
...
{% endhighlight %}

This breaks some of the internet for me, but that's just the price I pay. But I'm also surprised when I see the web from a computer that's not my own.

# Other articles

* [Goodbye Gmail](https://medium.com/@sbudaev/goodbye-gmail-7849f8c23baa) from Sergey Budaev
* [Scrap your reliance on the useless Gmail service! Stop using gmail.](https://www.reddit.com/r/GMail/comments/e9qdlw/scrap_your_reliance_on_the_useless_gmail_service/)
