---
layout: post
title: Registries are meant to exclude, not include, people
categories: open-source
tags: the-perl-foundation perl
stopwords: Dax Gladwell Hacktoberfest Idiocracy Jacobsen Katzer NOC Stackoverflow Stallman ZipRecruiter bootcamp employability hodge lifecycle onboarding podge pushback reputational résumé trainings
last_modified:
original_url: https://www.reddit.com/r/perl/comments/lgohqo/perl_and_raku_growing_as_a_profession_borrowing/gmwt0hp/
---

*Nigel Hamilton has some suggestions on what The Perl Foundation to improve the employment situation for Perl programmers. I respond with some historical perspective and pushback. There's some context to this: TPF doesn't know what they want to do and they are trying to figure it out. I responded to [their call for a survey, too](https://www.reddit.com/r/perl/comments/ko88ie/coding_in_perl_what_support_do_you_need/ghpw86y/). This [originally appeared in Reddit](https://www.reddit.com/r/perl/comments/lgohqo/perl_and_raku_growing_as_a_profession_borrowing/gmwt0hp/)*

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/FtZzYzqjuGM" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

People talk about The Perl Foundation like it's in charge of something or responsible for anything that happens. TPF is a small collection of volunteers who already have too much to do and who aren't going to take on anything more. That these sort of plans come out of TPF is even more surprising because they could do better things with their time.

If you want something, you have to do it yourself. TPF isn't there to give you permission, tell you what to do, or tell you how to do it. Just do it. And if it's good, you're still on your own. The NOC, for instance, is actually cutting back on what it can support because it's really just two people. And, it's two people who have been around forever. Adding more people just means that in a year it's going to be the same two people after the new people don't participate or get bored. I've been handling things at the edges of Perl forever, and I only move on when the things have enough hands. I've seen this pattern in many, many cycles. If you can't commit to it for the next five years, don't add to the pile of abandoned projects.

Rather than recommending that some other group do this, just do it yourself. And, if you are going to do it yourself, ask yourself what's the best way to get what you want and the least amount of work it takes to get there. That probably means using existing services. And, we should be using existing services. You don't want to start another job board when people are already overloaded with ZipRecruiter ads (and they use Perl). The people who want to hire are already drawn to places that like to spending a lot of money on advertising. Just send people there.

Creating some new website that nobody knows about, nobody has a reason to trust, and that the creator will abandon in a year probably isn't the way to do that. Consider jobs.perl.org, for instance, which is basically what it was when it was created and hardly anyone uses. People should find Perl people where they are already looking. That we want to segregate that means we are trying to fail.

Besides Nigel's suggestions, the one tip for can take from barristers is "don't work for free". The tip we do not need to take from barristers, however, is that we need to avoid systems and processes and bureaucracies to manage any of this. They have unintended, discriminatory outcomes.

## No Justice

Nigel states that barristers are trying to "achieve Justice", but we all know that's not true. Now, he was barrister himself, and I never was nor will be. He correctly notes that barristers swear an oath to the court and have a duty of care. But, on my side of the business, that also means it's maddening to get them to "just tell me the answer". The lawyers (and accountants) I've dealt with in a variety or circumstances don't have answers. Instead, they know what's defensible and what is allowed.

As an aside, the UK legal system is different that the US, but a barrister is someone who stand at the "bar" to represent you in court. These aren't administrative law types preparing documents and what not. Creating a trust or contract is a known process, unlike knowing the outcome of a dispute. That's only a slight wrinkle because administrative law people have a good idea of the outcome and their fee, whereas a legal tactic in court is the bleed the other side dry so they give up or settle.

Barristers are trying to win (or lose less) for the side that is paying them. They represent one sides interests, within their duty to the court. They do not cooperate with the other side to come up with the One True Right Outcome because they don't agree on what that is (consider Dax Shepard in *Idiocracy* though). That's why there's a court at all: there's a dispute on what's Right. They can cooperate to settle a matter, but they are then merely trying to achieve the best outcome for their side. A settlement may not be "Justice" (making the injured party whole), but the most one side is willing to give up to avoid giving up even more, or the least one side is willing to take to avoid getting less.

Not only that, you have to pay the barristers to do it, and even then they don't have to work for you. Many people who are in the "right" never get Justice because no barrister wants to work for them. At the same time, the entire profession sets up a system to make you think that you have to go through them to achieve something (and sometimes you do, as in court). As you'll read in a moment, these people have a list of the people they'll work with.

## First fundamental flaw

Don't be a Perl programmer. Be a programmer who can use Perl. That is, just be a programmer. At the start of your career, you have to start with one language, but you aren't there to use the language; you're there to solve programs. The language is one tool in the toolbox. Learn several languages. Your goal should be to solve the problems with the best tools available.

The single-language programmer is a problem. That's fine for your first job, but not your second. But, the languages aren't as important as you think they are. Indeed, part of Perl's early reputational problem is that "Perl programmers" were really bad programmers. Not only couldn't they program, but they had no experience with the software lifecycle (or business, or anything really). Consider [Matt Wright's Script Archive](https://www.scriptarchive.com), which is still available (and so bad and insecure that Dave Cross redid them all as [Not Matt's Script Archive (nms)](http://www.scriptarchive.com/nms.html)).

I had a friend tell me that she had been promised a job starting out at $90k if she'd learn Python. She wasn't a programmer and had no STEM background. So, I asked, why don't they pay you $75k and teach you Python? She was never going to get that job and it had nothing to do with her. They were never going to train anyone and didn't really need anyone in the sense that they'd make their own programmers if they couldn't get them from the market. It's just all bullshit. Several boot camps in NYC have had to walk back claims about employability ([Flatiron School, for example](https://www.nydailynews.com/new-york/manhattan/flatiron-coding-school-pay-375g-making-false-claims-article-1.3561462).

Honestly, I think most programmers who have jobs are just dragging their projects down. Smaller teams, less communication, and an actual design could make most programmers redundant (so, available to hire!)

But knowing Python, Perl, or whatever hardly helps. My degree is in Physics, but I don't know anything about fixing combustion engines (okay, I know a little, but Physics didn't help). I can't build bridges with my degree, and in grad school I refused to design a two-ton contraption that because I know nothing about materials or engineering (and it would have been illegal to try to do so, building codes and all). I've seen plenty of things that physicists have designed, and many of them are life-and-limb dangerous (barristers paying attention all of a sudden).

Why would knowing a particular programming language make someone suitable for solving your business problems? Not only that, knowing some (high-level) language doesn't really teach you anything about what's happening. And, you're mostly valuable because you understand what's happening. Sure, pandas and R can make all the fancy graphs you like, but those plots are also most likely complete fictions.

## A registry

Consider this quote from the *Harvard Business Review*'s [Your Approach to Hiring Is All Wrong](https://hbr.org/2019/05/your-approach-to-hiring-is-all-wrong):

> Census data shows, for example, that the majority of people who took a new job last year weren’t searching for one: Somebody came and got them.

I'm not looking for a job, yet I turn down two or three good offers a year. Some of those are places I wouldn't mind working. I've never been offered a job because I was on some list. I've been offered jobs because people know who I am, even before I started writing books. I was a daily presence on usenet (look it up in Wikipedia), but also Perlmonks, Stackoverflow, and so on.

I've even been told by a few places that if an applicant doesn't know who I am, that's a pretty good sign that they haven't been around Perl long enough to be useful (certainly not a perfect measure). It's not really me that's the point. Would you hire someone who has never heard of Github? They don't have to use it, but if they don't know it even exists?

But, the point remains: if you want someone to hire you, they have to know who you are. Otherwise, you're just a number in their hiring system. You might not even make it to the people who know that you'd be the person to hire. You need to be out there. People need to be able to see your work. There's nothing TPF can do to help you there, and there's nothing you need to do that TPF can help you with. Show up online. Upload modules to CPAN. Learn how to use source control. Respond to issues. Make good bug reports in other people's projects. Do the work-a-day things that you'll need to do on the job. Very little of any job is the programming language itself.

What would happen if I were on a registry? I'm on LinkedIn, which I hardly ever use, and yet I'm inundated with third-party headhunters saying I'm a great fit for the Clojure job (never used it), I'd be a great addition to the Java team (gave it up before most people even knew what it was: fine language bad ecosystem), and so on. A registry is simply a way to provide these recruiter miscreants a way to spam.

But we had the registry idea ages ago. The simplest idea was to create LinkedIn badges (you know, the résumé site)  or groups that employers could search. We tried that for awhile but would be spammed by all sort of people we didn't know and couldn't evaluate. The Advanced Perl Users Group was supposed to be by recommendation, but no one took the time to recommend or evaluate the requests to join. I didn't start that group but I managed it for years and then gave up because it was useless. It turned into spam and ticket-punchers.

The barrister registry works because they limit who can be on it and there's a process to get on it: you have to pass a rigorous test after years of formal schooling. That's part of the reason it works for barristers.

Not anyone can call themselves a lawyer, and the State will often stop you if you try even calling yourself one without the proper licenses, permits, education, or so on. Consider the case of [Mats Järlström](https://ij.org/press-release/oregon-engineer-wins-traffic-light-timing-lawsuit/), although he was an engineer (and ultimately prevailed).

It's the same with doctors, and many other jobs in which the standards and duties of care are set by the people doing the work. Those are professions, in the classic definition as a self-regulating group of practitioners. Milton Friedman delights in noting that these groups are the strongest trade unions and that they are specifically there to keep people out. That's why guilds exist—they control who gets to work (and sometimes that's due to racism). Let too many people work and you'll get paid less than you want.

But, anyone can call themselves a programmer and nobody can stop them. We don't even know, as a group, how to program. I can say it's this thing and Nigel can tell me I'm wrong and say it's this other thing. There's no way to tell who's right because it's subjective. Maybe in 400 years we'll have Programmers' Common Law.


But, programming isn't a profession—it's an occupation. There's no agreed upon standard of care, education, licensing, or so on. Anyone can do it, and anyone does. Someone can read a book on programming, practice at home, and then get a job never having encountered any formal education, licensing, or permitting. And, since they can do that, we have more programmers than we would otherwise (even if they aren't all that good).

A registry is not a way to include people, it's a way to exclude them. As much as it would be nice to say "Don't hire that person", wait until you're the one removed or excluded from the registry. Somewhere, someone is going to decide what they think the standards should be. Who do you want deciding that? Are you willing to let that group of people tell everyone in the world not to hire you if that group happens to not like your take on some philosophical issue? You didn't use `strict` in a ten line program, so you aren't a good programmer? If you don't agree with Damian Conway on every point on *Perl Best Practices* (a 15-year old book that had some dodgy, untested advice even then), should you be kicked off the registry? Otherwise good and thoughtful Perl programmers have been passed over because of these things.

## Professional courses

Nigel's second idea was that TPF sponsor courses at conferences. He takes about an intensive "practice course", which is not the same thing as learning the language. It's more like a bootcamp for onboarding new employees. There's what you learn at school and there's what you learn doing the actual work. He's talking mostly about the latter I think.

In a practice course, you learn the actual trade and how actual work gets down. My lawyer friends tell me about learning how this particular clerk at this particular courthouse likes to do things, and so on. This isn't the theoretical stuff. This is nuts-and-bolts real-world application. This is where theory meets psychology and human desire.

You aren't going to get that at a conference because virtually no one there is doing your job in your situation with your constraints. To learn how to work as a programmer, you need to be working. To learn what you need to do, you need someone in the same situation and context. The language isn't that important there. The tools you use are common to any language: the editor, source control, issue tracking, and so on. That's the practical course for programming. Learn those things inside and out; they are transferable skills.


I introduced the idea of teaching courses at Perl conferences back in 2006. We called them "Master Classes" and the goal was to figure out how to pay the popular people to come to conferences. Damian, for instance, would need to travel from Australia to wherever, and that's not cheap. TPF hasn't historically wanted to pay market rates for good teachers to come to conferences (and I'd rather they not). There are plenty of cheap ways to learn Perl, and if you're looking to get a job doing it (or anything), you could help by paying for the work you're getting from Perl programmers. It doesn't really help us to make people work for close to nothing. And, we have to acknowledge that a lot of the work we did get for "free" was actually subsidized by people's day jobs. The dirty secret of open source is that it is only possible in the large by protected, private interests. Very few people want to homeless like Richard Stallman.

The closest thing I had to what Nigel suggests is my "Zero to CPAN" workshop. In a morning, people went from no CPAN authorship to creating a module, putting it on Github, releasing it to CPAN, making and receiving pull requests for other participants, and re-releasing. At some point I want to make that a book that people can use to run their own workshops. Once you hold someone's hand through the process, they see how incredibly easy it is and how everything fits together. I love teaching that class.

But, I don't do conferences anymore because they are just too expensive, too time consuming, and frankly, below my level. I'm happy to teach Perl anywhere that wants it, but I'm not paying my own money to do it (the real tip we should take from barristers). There's not much I get out of conferences that I can't read for free after. For me to go to a conference, I ask the organizers to pay all my expenses *and* replace the income I forego. In most cases, the conferences don't have the budget for that. But, this is why you don't have more classes. There's no incentive for the qualified people to teach them.

I'm not the only one who does that, and you should think about that. Why don't you see your favorite people at conferences? The conferences burned out our good will as they got more demanding of our time and generosity.

And, it's really cheap to learn Perl. You don't need anything fancy. Even an older edition of [Learning Perl](http://www.learningperl.com) will get you there. I understand that book isn't everywhere in the world, but neither are conferences. But, it's easy to get help almost instantaneously without leaving home.

Lastly, consider this. Programming is a text-heavy occupation. You need to learn how to learn from reading on your own. Videos and in-person instruction can help, but if you are going to work as a programmer, most of your time will be spent doing something someone hasn't written about or filmed themselves explaining. There is no help in any form. You have to be in the books and synthesize new information. A lot of the stuff that you will read will be badly written, out of date, or incomplete (hello Google and AWS APIs!). All the tasks that someone has already done somewhere are already done in your the project because that was the easy stuff, and now you are working on all the other stuff.

The economist Steven Levitt talks about being confused on his first job because he didn't know how to do the task. When he asked for help, they told him they didn't know either and were paying him to figure it out.

Your job is to figure it out, not give up if someone hasn't tailored an explanation just for you. Malcolm Gladwell in [Outliers](https://www.littlebrown.com/titles/malcolm-gladwell/outliers/9780316040341/) likes to note that the difference in math ability among groups is largely one of work ethic. People who knuckle down and do the work do better. It's all just work, so embrace that.

## Mentoring program

Mentoring is hard, and how are you going to pay for that? It takes years of daily, side-by-side work to effectively mentor someone. The trade-off gets the mentor an effective worker and colleague. But what is some Perl mentor going to get out of the relationship Nigel proposes? And who's going to do that? How many people can a single mentor handle?

So, we have things like Hacktoberfest and the CPAN Pull Request challenge. The costs on the mentor are extreme. Often we have to completely redo the work, and since these are drive-by contributions, I don't think the people take much out of it. Maybe Mohammad has numbers on how many people remain active, but my feeling is that it's close to zero.

Some companies use interns as cheap labor, but they can get in trouble when it usually violates labor laws. Interns are designed to be negatively productive and short-termed. The company spends more time on you than you contribute back. But, that's their entry into work.

A common person doesn't have their own law library and it used to be that you had to submit your programs to a computer operator for your allotted computing time. That's not the case here. Most people can do quite a bit of the full stack programming for very little if no money. [A guy in New York just made a vaccine tracker for $50](https://www.nytimes.com/2021/02/09/nyregion/vaccine-website-appointment-nyc.html). This isn't [Desk Set](https://www.imdb.com/title/tt0050307/), where you have to go through Spencer Tracy to get access to the computer.

Not only that, you can get a lot of the same effect just by paying attention. Read the answers of well-known good answers on StackOverflow, for instance.

Almost none of this has to do with Perl or programming, though. If you want to be a good programmer, you need to work at it everyday. Read lots of books. Improve your work habits slowly and constantly, such as automating your processes or becoming better with a particular tool. Learn new things.

But let's talk about the real issue. Employers are betting that someone else will train their employees for them. They don't commit to a person's career. They want ready-made programmers who they will let go when they don't need them anymore. How are they made ready? Some other company trains them, mistreats them, and they leave, voluntarily or otherwise.

As such, companies skip building skills pipelines. They don't create or reinforce the skills they want, but are then surprised that the market doesn't provide them.

Consider this: I cut my teeth in Perl doing trainings. Stonehenge Consulting had six Perl trainers working practically full time in the 90s. Sure, Perl was hot, but companies were training people, too. Some do that now, but those companies have so much money they do it in-house on the tools that those people can't use at a different employer.

And the problem isn't just that you can't find a person who wants to work in your technology. A new person, no matter how good they are, has no institutional knowledge of your problem. Your company invested a couple of years in some person they didn't retain; that investment in institutional knowledge walked away. Now you have to start over. And, that's the hardest problem.

When I'm working, I'm often introduced to a code base with no documentation, scant tests, and a hodge podge of architecture. But, I'm the only one who doesn't know how it all works. Everyone else knows how it works because they've run into all the problems. You have to deploy it exactly this way, or you can only test it this way, and so on.

## An Artistic Manifesto

We specifically do not strive to make software fit for purpose. In fact, most licensed open source code is going to specify that it has no warranty. The Artistic License 2.0 (the only one that I know of that has ever survived a legal challenge - Jacobsen v. Katzer, No. 2008-1001 (Fed. Cir. Aug. 13, 2008)) says:

> (14) Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.

You might also like to read [The MIT License, line-by-line](https://writing.kemitchell.com/2016/09/21/MIT-License-Line-by-Line.html).

Most people also aren't looking to build communities as their primary goal. They are trying to solve problems and get back to their life. In fact, the great invention of open source is that there doesn't have to be a community and that we can cooperate despite all of our  different aims. Most people don't want to spend a lot of time interacting with vendors—they have other things to do.

It's good if it's easy to get help and it's easy to report problems, but we already have that to the extent people are willing to provide it. No formalism is going to make that better. Nobody owes us anything. In fact, the idea that providing open source software comes with some sort of implied support (despite licenses and disclaimers) drives the providers out of the game.
