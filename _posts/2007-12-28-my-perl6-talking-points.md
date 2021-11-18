---
layout: post
title: My Perl 6 Talking Points
categories: programming opinion
tags: perl6 raku rescued-content
stopwords: raku
---

*I originally posted this on use.perl.org, a site long since gone. However,
it has static content at [use-perl.github.io](https://use-perl.github.io/user/brian_d_foy/journal/35230/). Since
then, the language that was Perl 6 has changed its name to Raku.*.

We're in the middle of another Perl 6 storm. This is my executive summary that satisfies almost everyone who asks me about Perl 6. The question "When will Perl 6 be here?" is what they ask, but what most people want to know is "What do I have to be doing now to be ready for Perl 6?"

* No one is going to take Perl 5 away. People depend on it too much. It has more development effort than Perl 6, and I don't see that changing for several years. Perl 5 still gets my job done quite well, and Perl 5 is still getting better.
* Consider Perl 6 a completely new language. When it gets here, consider if you want to use it for production things. You don't need a migration plan for your old stuff because no one is taking away Perl 5. You can even have Perl 6 right next to Perl 5.
* Most people don't really need Perl 6 because they barely use the features of Perl 5. I get to see a lot of Perl in a lot of situations, and most of it is in _Learning Perl_ and the first third of _Intermediate Perl_.
* Perl 6 isn't really taking that long if you take out the 4 years of chaos where the various people working on the project spun their wheels trying to figure out how to manage themselves and what to do. The real work began in 2005 when Audrey Tang started Pugs and gave people a way to write code and tests. Since then things have been going very well with a small development team.
* Perl 6 had the ambitious add-on of Parrot, a generalized virtual machine for any language that want to target it, and allowing the languages to work together. It's one of those projects where you don't get to see much working until the very end, and then all of a sudden everything is done. We might have had Perl 6 faster without it, but that's not what happened.
* There is no deadline or release date. The Perl 6 developers want to get it out as soon as possible and as much as you do, but there is a limited pool of people working on it. Perl 6 actually got more people interested in working on Perl 5, and now you see lots of Perl 6 things showing up in Perl 5.10.
