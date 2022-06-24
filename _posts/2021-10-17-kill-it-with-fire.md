---
layout: post
title: Notes on Kill It With Fire
categories: software-lifecycle
tags: legacy
stopwords: px Etsy's href img js br Bellotti's
last_modified:
original_url:
---

<a target="_blank" href="https://www.amazon.com/gp/product/B08CTFY4JP/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B08CTFY4JP&linkCode=as2&tag=hashbang09-20&linkId=e0c15536e295a4fdca05586fb603fa7c" ><img style="padding-top: 0; padding-right: 20px" align="left" border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B08CTFY4JP&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=hashbang09-20"></a>

I just finished Marianne Bellotti's [Kill It with Fire](https://amzn.to/3G0pXbW) (a book, not he video game). These are my notes, rather than a summary of the book.
Things that I've already known or considered don't appear here. Marianne writes about legacy modernization projects, but not from the usual tactics and techniques
perspectives that most technologists would take. Instead, this is real world experience, mostly working on government projects.

<!--more-->

<br clear="all" />

## Chapter 1, "Time is a flat circle"

* technology moves in spirals, not a line
* everything old will be new again
* chasing trends means you just undo it later

## Chapter 2, "Cannibal Code"

* some goals are *alignable*; they can be compared to existing expectations
* some goals are *non-alignable*; they have no reference frame
* COBOL was for people who want to get work done with existing capabilities, and Algol60 was for people who want to create new capabilities
* *artificial consistency* is the work we do to fit into an idea even though the work does not produce additional value. For example, new libraries that provide the same capabilities as existing ones (Node.js and React, for example)
* Keeping things simple often means accepting historical artifacts that people can easily grasp, even if these are not pure. For example, the 80 column limit on code, carried over from punch cards.

## Chapter 3, "Evaluating Your Architecture"

* *legacy* is not the same as technical debt, and legacy status is not a sufficient reason to modernize (see my earlier [What is Legacy Code?](https://briandfoy.github.io/what-is-legacy-code/))
* *technical debt* is the result of compromises and shortcuts

## Chapter 4, "Why is it Hard?"

* *overgrowth* - the system relies on too many things
* historical context matters because problems were solved with the information available to the time
* Map out system dependencies two levels down
* Cloud platforms are leading to more vendor lock-in (using special platform features not available elsewhere).

## Chapter 5, "Building and Protecting Momentum"

* Given the chance to modernize, developers tend to use tactics and strategies that they know won't work, such as "waterfall" design
* You can apply Agile to modernization
* Look at the actual problems. Find small scopes and big impacts.
* Parts of the business have already aligned with the system architecture, so there will be politics
* The fix has to make actual, noticeable improvements, not just rearrange things
* "The hard problems around legacy modernization are not technical problems; they are people problems"
* minimize the number of big decisions

## Chapter 6, "Coming in Midstream"

* What happens when you join the effort in the middle instead of the beginning?
* breaking up monoliths creates personnel problems, span of control issues, and is not a tech solution
* Patterns
	* Fixing things that aren't broken
		* Compounding factor: diminishing trust
		* Fix: institute with formal methods
	* Forgotten / lost systems
		* Compounding factor: crippling risk avoidance
		* Fix: use chaos testing
	* Institutional failure
		* Compounding factor: no owners
		* Fix: [Code Yellow](https://markcarrigan.net/2016/01/10/googles-war-against-latency/)
	* Leadership has lost the room
		* Compounding factor: self sabotaging teams
		* Fix: murder boards to ensure that decision makers know the answers

## Chapter 7, "Design as Destiny"

* "Planning is problem solving, design is problem setting"
* reactive versus responsive
* Exercises:
	* Find critical factors
	* Play the saboteur
	* Shared uncertainties
		* simple ↔ complex
		* orderly ↔ chaotic
	* What are the 15% solutions?
* 1968 - Conway's Law
	* ["How Do Committees Invent?" ](https://web.archive.org/web/20190929004831/http://www.melconway.com/Home/Conways_Law.html)
* Individual incentives decide plans
	* career goals
	* fame, other external factors
* Most systems are not badly built, they are badly maintained.
	* responsibility gap
* Why are new things promoted? Do they actually add value or just assuage personal biases?

## Chapter 8, "Breaking Changes"

* "air cover" - management supports you
* behaviors that get noticed create incentives (and behaviors that aren't noticed are disincentives)
* Etsy's ["just culture"](https://codeascraft.com/2012/05/22/blameless-postmortems/) and the [three-armed sweater](https://www.infoq.com/articles/crafting-resilient-culture/)
* [Service recovery paradox](https://www.customerthermometer.com/customer-retention-ideas/the-service-recovery-paradox/) - customer confidence is greater when they know you have previously recovered from an outage

## Chapter 9, "How to Finish"

* the website is never done
* technology is never done (although a modernization project can complete)

## Chapter 10, "Future Proofing"

* design so you don't need a huge effort next time
* null values eventually become real values (like 9/9/99 is at some point a meaningful date)
* automation means we ignore whatever we automated (so, garbage collection means we stop caring about memory)

## Other reviews

* [Laura Nolan in ;login:](https://www.usenix.org/publications/loginonline/kill-it-fire)
* [iProgrammer](https://www.i-programmer.info/bookreviews/28-general-interest/14808-kill-it-with-fire.html)
