---
layout: post
title: Backups and resiliency for open source code
categories:
tags:
stopwords: Satya Nadella SSDs HDDs
last_modified:
original_url:
---

The 3-2-1 rule is the basic advice about backups: have three copies, on two different types of media, in at least one far away location. That's a good start, but there are other things to consider.

<!--more-->

In this post I'm mostly thinking about my open source code. There are various laws and regulations that may control what you can do based on the type of data you have. For example, HIPAA or GDPR. I'm not writing about anything that secures or protects data, and probably writing things that do the opposite.

I already [use several git services at once](https://briandfoy.github.io/use-several-git-services-at-once/). I push to several different places so I have multiple copies and at least one far away location. I solve the two different sorts of media with various SSDs, HDDs, and the magical fairy dust of "internet".

Pushing things to multiple git services, such as GitHub, GitLab, and Bitbucket, protects me from outages or adverse action at any of them. If GitHub is down, I still have access to my local copies, but also the copies on other services if I don't have a local copy.

That's a good enhancement to 3-2-1, but then I started thinking about where these services actually store my data. For example, if everything is just AWS us-east, then I might not have any sources available for a single AWS outage.

I looked at what I had and where it might be and what it might be using. Sometimes the technical details leak out where the business side would not be so open. I can't verify these, so if I'm wrong, correct me:

* GitHub - Rackspace? Azure? (Virginia, Seattle)
* GitLab - Google Cloud Project, us-east (South Carolina, Virginia)
* BitBucket - AWS us-east (Virginia)
* Linode - Philadelphia or Southern New Jersey area (Akamai)
* Pair Networks - Pittsburgh, or maybe the US midwest?

Suppose a hurricane takes out Virginia; how many of those services stored my data in the same building? In the same row of racks? In the same cabinet? I'm not surprised that most of these are coy about where my data actually live. I suppose I could ask them, but I don't want to kick the bee hives.

For me, those are all hosted in the United States, and mostly in the same hurricane-prone area. The weather could be a big threat. I want at least one data store to be in a different weather regime.

Suppose that there is some adverse regulatory action that denies me access to my US accounts. I have been locked out of Gmail for a couple of weeks with no warning and no later explanation, for example. Maybe that was a glitch, but maybe I got caught up in some sort of weird government action, accidentally or otherwise. Consider [GitHub and Trade Controls](https://docs.github.com/en/site-policy/other-site-policies/github-and-trade-controls), where GitHub prevailed, but "[a]s a result of our advocacy and hard work with U.S. regulators". I don't believe if you are doing nothing wrong you have nothing to worry about, and neither should you if the mitigation and resiliency is easy.

## Politics

Along with that, sets of politics have entered the chat. What if my account is shut down because I use the default branch "master" instead of some other branch? No one has gone that far, and I don't really care, and the argument is not about "master". There are political reasons that a service may suddenly deny me service because I either ignore their instructions to change something or I am blindsided by something I had no chance to respond to. The US business culture seemed to be moving toward a cancel first and ask questions later.

I don't really care about "master" beyond the fact that all the tools are set up to look for it. I'd have to change quite a bit in my workflow to recognize a new name because it would still have to support the old default name for existing copies. You've probably experienced the chained nuclear reaction knock-on effects of seemingly trivial changes. It's not simply using a new name.

# Corporate transfers

While researching this, I realized that SourceForge is still a thing. I used to host everything there because SVN was the new hotness. Then they were acquired, got really weird, and everyone left. Some people complained that SourceForge [became a clickbaity malware hosts](https://www.howtogeek.com/903218/what-is-google-go-on-android/), and I certainly noticed that they obfuscated what you were supposedly downloading. I'll never trust them again, even though they changed hands again in 2016.

Some people were worried about the same thing when Microsoft acquired GitHub. I think they were unfounded as people have inculcated reactions based on the evil days of Bill Gates and Steve Balmer. Now we are in the days of Satya Nadella, who isn't laying awake at night trying to destroy Steve Jobs or IBM. He seems like the adult in the room. GitHub has become flakier, maybe because it's on Azure, but I think that would have happened because of scale in any situation.

But know this: everything that you love will eventually be sold and will eventually abandon the thing you loved about them. Google used to "Do no evil", and is probably considered to be evil now. Travis CI said free open source "forever", until they sold out. Consider that volunteer projects eventually scale to the point where they can't be volunteer, hobbyist endeavors anymore. Consider that the hot shot engineers who made your cool service will eventually have children and their entire relationship to the world will change. People with families will absolutely take the big bucks from an acquisition over supporting your use case for eternity for free. Plan on it.

# Bus factor

Additionally, the point of open source is that people should have access to my work product even without me. Maybe I'm on vacation, or maybe I'm in a coma in the hospital (a true story from my first company, but with a different founder). It's not merely my own access to my materials, but the world's access. Suppose sanctions are applied against my country by some other country—part of the world might not be able to access my code (see where [GitHub isn't available by US law](As a result of our advocacy and hard work with U.S. regulators)). Some single action could obviate everything I've done, so far, to keep my stuff available.

# What else is out there?

I started to look around at what else there might be.

* Create new repos with an API call
* free for open source projects
* lets me host several hundred repos

I don't find much that's suitable:

* Codeberg.org is a gitea installation hosted by a volunteer group in Berlin. It has an API and is outside the US and outside the US jurisdiction. Germany is a US ally though, so if the US was really mad at me, I could still be bitten.
* The granddaddy of all services, [repo.or.cz](https://repo.or.cz), which has mirror mode. There's no API, but the website is so simple I could probably wrap it very easily.

# Where does that leave me?

I guess I'm mostly hosting in the Virginia.
