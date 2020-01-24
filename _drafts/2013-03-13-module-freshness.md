---
layout: post
title: module freshness
tags:
stopwords:
---

People don't start out looking to use abandoned modules, but there's this perception that they end up using abandoned modules. David Golden and I, in our capacity as PAUSE admins, have been exchanging messages on the PAUSE mailing list about this and a possible way to annotate modules as abandoned.

David's idea, which he isn't really pushing or planning to do, re-purposes the PAUSE admins process for assigning abandoned modules to new maintainers. Someone would suggest a candidate abandoned module and someone else would transfer it to ADOPTME or otherwise mark it was abandoned.

<div style="float: left; border: 1px; margin-right: 5px">
<img src="http://a.yfrog.com/img877/8475/bf4h.png">
</div>

I disagree with the method, which is why there's a thread, but that's beside the point. I think there is probably a better way to do this than something that involves human judgement. Neither David nor I need this for our own itches, and I think we're trying to scratch the itches of strangers. Try doing that in real life sometime. You'll probably get thrown off the train. :)

I think there's plenty of signal already there. People can see the last release date of a module, the development activity, the number of bugs in RT, and a few other things. I can look at an author to see the release dates of all of this latest contributions. From that, I personally don't have a problem knowing if an author has disappeared. That presumes, however, that people actually look at something like MetaCPAN rather than seeing a package name and installing it with a client. This is, by the way, the failing of many things, such as <a href="http://cpanratings.perl.org">CPAN Ratings</a>. TANGTUI (tang-to-we: they are never going to use it), which is slightly different from YAGNI. This is why my idea is also going to be virtually worthless, but require a lot less work.

I think that we can assign a freshness rating to any module. We don't need any infrastructure to change to figure out this number. We can publish it how we like and other things can use the feed. The trick, then, is to figure out how to make that number.

On a first order approximation, I'd look at the last release date of a particular module. The overall freshness would decline the older the module was. Because I get to make this up, I'll rate on a scale of 100 to -∞. A module with 100 is as fresh as it can get, and it can go as low as it wants. If you're Miyagawa, there will probably be some situation where freshness is above 100. I'll call this factor R:

<pre>
Freshness(Module) = 100 - R;
</pre>

I don't want to get into how many points to take off based on time passing. That I can adjust later. Maybe it's a step function, maybe it's continuous. I don't care right now. This fails for modules that are "done", which is different from "end of life". Maybe the module was released a year ago, but it's a core module (which means it has explicit support). But, this is a first pass.

The next thing I would look at is issue activity. I can't subtract points based on the number of issues because that's not related to the freshness. A popular module might have 37 issues, but they might be 37 new issues because the previous 37 were patched. Maybe there was a new release, maybe not. These data are mostly in RT or Github. A module that's closing and patching tickets should be rewarded in freshness, and a module with ignored tickets should be penalized. Somewhere in the middle is the author who acknowledges tickets but doesn't have fixes. For instance, I tend to not solve Windows issues with my modules, but I accept patches for them. I'll call this factor T:

<pre>
Freshness(Module) = 100 - R + T;
</pre>

There are several other things I could examine. I could have an author factor, A, that looked at the activity in other modules from the same source. That might subtract or add a little:

<pre>
Freshness(Module) = 100 - R + T + A;
</pre>

With that, I think we could be get pretty close. People different tolerances for those factors, so maybe there are some coefficients. We might have to add a fudge factor for modules which are stable and good and haven't had a recent release.

There are other things I could consider. CPAN Ratings are marginally useful, but only if they are recent. Several good reviews five years ago aren't that helpful today.

But then, I have to consider if there's any benefit from actually researching this formula and discovering that the adjustments should be. For people who can't already look at the summary of the the module meta-data, will such a number even help? I doubt it will. Instead, people will use a number they don't understand to talk crap about a module, annoying its author and blaming me for coming up with the number.
