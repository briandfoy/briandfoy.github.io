---
layout: post
title: The New Sadism
categories: programming
tags: perl
stopwords: Slavoj Žižek's fanfic
last_modified:
original_url:
---

In [/r/perl](https://www.reddit.com/r/perl), I responded to [The Pervert's Guide to Computer Programming Language](https://www.reddit.com/r/perl/comments/g44zin/perl_as_a_sadistic_language_in_lacanian/). There were many things I excised from my response before I posted it, so I capture those here. I might want these ideas later.

In brief, Watson's talk connects the rantings of Slavoj Žižek and his Critical Theory reinterpretation to the classification of programming languages. Ignoring the fact that programming languages have as much animus or consciousness as a garden rake, the classification is facile and broad. That's not odd for sophomoric Žižek fanfic—I suspect Žižek's actually Tony Clifton.

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/6jgJhAEcq6Q?start=19&end=38" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

---

I was comparing Perl's and Python's different design fundamentals, and strayed into comparing HTTP libraries. If you've never used anything else, Python's `requests` library seems really cool. If you have used other things, you're annoyed at its dumb limitations:

> Compare your favorite HTTP library among languages, then look at the design of Mojolicious. You probably wouldn't guess that a web framework would have one-liners for anything other than toys, but Mojo does. I have some as shell aliases even. I spent a lot of time trying any HTTP library I could find as I was writing [Mojo Web Clients](https://leanpub.com/mojo_web_clients/), so I've felt this pain—trying [logging requests in Python's `requests`](https://stackoverflow.com/q/10588644/2766176).

The presentation classified languages superficially without much consideration for their context (although the New Jersey-MIT dichomoty was there):

> The small-tools value is difficult to enjoy when your entire world is services exchanging JSON instead of unix files and pipelines—especially when you aren't the one creating any of the services. These aren't magical beans in distant lands. Someone did a lot of work for you. Some of those people even invented new languages to do that work.

Along with that, using current thoughts to evaluate long past decisions is a bit dishonest. There's a tendency to emphasize the good of the current situation, but to emphasize the bad in past decisions. This is an odd state because most the current stuff will never make it into history while the derided past is exactly the stuff that survived:

> Most of us know that "serverless deployments" aren't really serverless. We mostly understand the fictive elements of the marketing and that some [site reliability engineer has to actually go to an actual data center to actually fix the actual rack that tipped over in an actual gravity field](https://cloud.google.com/blog/products/management-tools/sre-keeps-digging-to-prevent-problems). At some point, it's not turtles all the way down and there is some iron.

Our relationship to technology is a consequence to how we decide to interact with it. I didn't quite develop this, but biases and priors have more to do with the classifications than innate characteristics of the language:

> In a Makefile, I can do just about anything I want with whatever small tools I can scavenge. Rake purposely drops a lot of `make`-like functionality when they made the decision to pressure you to only use Ruby, even if it's to shell out. I've spent a fair amount of time in Rake (with GitHub Pages, might as well), and for everything they've said about "make can't do this", I usually have "no, that's really easy in make". But then, I've been using `make` forever and started by reading the manual (well, the nutshell book [Managing Projects with GNU Make](https://amzn.to/2KtMenb)) rather than learning as I go (but I also read cover-to-cover the Rake books too, so there's that). That's a difference in approach itself that dictates behavior and decisions. If you're a read the manual type, you do things in a particular way. If you are the "dive right in" type, you have other tactics to model your world. This is part of the psychology in the talk.



