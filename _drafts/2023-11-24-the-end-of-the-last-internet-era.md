---
layout: post
title: The end of the last internet era
categories:
tags:
stopwords:
last_modified:
original_url:
---

<!--more-->

Two years ago, the "Web" was bad enough that I consciously changed how I decided to interact with it. I started way back in the days of gopher, and NCSA's Mosaic browser (and lynx), and content was interesting since it was much tougher to publish. The NASA Photo of the Day was fun, even if it took forever to load.

Now it's much different. I don't know who I soured on first: Amazon or Google. Either way, I've decided to divest from both of them and have been surprised at how easy it is. But, the "Web", not so much.

## Amazon

Let me tell you about Amazon. I was a Prime customer since the first day they offered it until about a year ago. The selection of products was fantastic: almost anything I wanted was available in two days. For the kids out there who don't know what two days means, I'd take the date I ordered something, add two to it, and that's the day I'd receive it. I'll write more about this in a moment.


I think January 19 is the day I decided not to give Amazon <s>$99</s>, <s>$199</s>, <s>$129</s>, $139.

There were so many reasons I decided to block this retail juggernaut. I saw the beginnings of this with the Amazon Vine program, where I was sent products that I didn't pay for in return for a review. I joined when it started 20-something years ago. At first, it was amazing. I could get quality stuff as long as I gave a review, with no restrictions on what I could say. If it was crap, it was crap.

About five years ago, something happened where most of the products Vine offered were just cheap junk. I was interested in security cameras and requested several to review, only to find out that they are all the same camera, perhaps in different housings, using the same white-labeled software, and all connecting to the same Chinese servers. You've probably noticed these products on Amazon with all-caps nonsense brand names that use the same pictures for the same product.

But then, various US tax laws prompted Amazon to declare the retail value of the products they gave me as ordinary income, which meant I was actually paying for this junk.

This started to leak over into the stuff I bought on Amazon. You can find plenty of reports of Amazon's inventory mixing the same SKU from different sources. There's the genuine product, then the knock-off version that steals the SKU. Amazon apparently puts all of that in the same bin in its warehouses, so not even Amazon knows whether it's sending you the real product. The Amazon Marketplace, which lets third-party sellers sell through Amazon (and lets Amazon even manage the inventory), besides all of its anti-competitive abuses, was another source of junk. Amazon had good return policies, but those disappear with third-party sellers.

Amazon's main attraction, the fast shipping, had also slipped, in a boiling the frog fashion in what I'm sure was a multi-year plan to shift expectations. Two day shipping, which meant that I could have my stuff in two days (even Sundays in some places), turned into "ships in two days". There are some valid reasons for this. At first, Amazon only had nexus in the state of Washington. This is the fancy term that means they only have to collect sales tax when they sell to a Washington address. They resisted submitting sales taxes to any other state by not having physical locations in those states. Eventually they got so big they had to relent. Once they lost the sales tax battle, they opened shipping facilities and warehouses all over the country.

Then they tried to push out UPS. Amazon wanted to be its own shipper, but they weren't that good on the last mile. In my part of the world, they use LaserShip, a fly-by-night delivery agent where random people in street clothes using their own car ring my bell and attempt to deliver packages. Sometimes they wear a red vest, sometimes they don't. In NYC, you don't (shouldn't) buzz in these sorts of people. Sure, a dedicated burglar could boost a UPS brown uniform (it happens), but hey, street clothes aren't even trying. I've even asked to see a fire marshal's tin (and he was surprised but happy to show it). There's also a ConEd scam where kids ring doorbells and claim to be ConEd (or National Grid or whatever) to get into a building.

Not only that, but these LaserShip people would sometimes not actually deliver but say they did. That's understandable (but unacceptable) given Amazon's moronic metrics. You know that's going to happen.

I tried shifting some purchasing to Walmart, a company that practically invented real-time national logistics. Some people think they are also an evil company and there's some merit to that; Walmart has it's own Marketplace which is copying Amazon's shifty practices.

In 2023, everyone else has caught up. Selling stuff on the web is boring technology now. For many of the things I want, I can go directly to the manufacturer or publisher. Many of them have

## Google

I remember the days when Yahoo! was a web directory and how one found websites. My first company even made a knock-off that people could manage themselves. I literally copied Yahoo! feature for feature. As an aside, we had a few porn customers, and they were the best organizers and drivers of the service. Seriously. When you are not at your work computer, look at some porn sites—their classification and cross-referencing would make John Dewey do what the porn sites do for most people.

Then there was the game-changing AltaVista, which was an uncategorized search, and eventually Google, which was page-ranked search. Google's killer feature was that they got ahead of the web explosion with the idea of rating pages based on their quality and putting the higher quality sites at the top of the search results.

Someone starting with Google today would have no idea that PageRank ever existed. Instead, the first page of their results would be explicit advertising, implicit advertising, and crap. About two years ago, I noticed that my search kung-fu had to change because I needed to be much more specific about searches.

I tried using Bing and DuckDuckGo, but they weren't any better. I think they have much better business models (and if Microsoft has a better business model, you must really suck), but crappy search results are crappy search results. The food here is awful, and such small portions!

For years, I have blocked most Google trackers through /etc/hosts. That's a file that lets me tell my computer what numeric address goes with a domain. When I find a Google tracker, I black hole it:

0.0.0.0 googleads.g.doubleclick.net
0.0.0.0 ssl.google-analytics.com
0.0.0.0 www.google-analytics.com
0.0.0.0 www.googletagservices.com
0.0.0.0 tpc.googlesyndication.com
0.0.0.0 www.googletagservices.com
0.0.0.0	pagead2.googlesyndication.com
0.0.0.0	plusone.google.com
0.0.0.0	googleads.g.doubleclick.net
0.0.0.0	pagead2.googlesyndication.com
0.0.0.0	www.google-analytics.com
0.0.0.0	ssl.google-analytics.com
0.0.0.0 www.mygooglepagerank.com
0.0.0.0 google.tucows.com
0.0.0.0 googleadsense.ya.com

This means that parts of the web don't work for me, but I've learned to live with that.

Now I use Kagi, and have only rarely felt the need to try a different search engine. I pay for it, but that's the new Internet. Quality is no longer free.

## GMail

I was also a big user of Gmail, which was a step ahead of other email services at the time, but it rested on its laurels, besides feeling slightly icky about Google reading all my mail and feeding it into their algorithms.

GMail's big push when it was launched was that you'd never need folders because you could search your mail very easily. And this was true when I had only a couple years of mail sitting there. When you have 20 years of mail, searching is next to useless. GMail even had to reinvent folders as "labels" and allow filters to sort things into "labels".

I switched my mail over to FastMail (through POBox), and it was actually very easy. I paid for five years in advance. There are a few Gmail features I miss, but I'm generally happy.


