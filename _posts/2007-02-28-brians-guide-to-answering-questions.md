---
layout: post
title: brian's guide to answering questions
categories: programming
tags: rescued-content guide
stopwords: dba oscon answerer asker brian's clueful reclarifying cluelack
last_modified:
---

*I originally posted this on Perlmonks as [
brian's Guide to Answering Questions](https://www.perlmonks.org/?node_id=602571)*

Answering questions well is a skill, although not necessarily one in explaining things cogently. Picking the right questions to answer and avoiding the time wasters helps quite a bit too.

## What do you get out of it?

Someone has asked a question, whether directly or in a public forum, so you have to figure out if you should answer it. As a Perl trainer, I have to answer the questions from students. It's my job. As a PerlMonks reader, I don't have to answer questions.

Maybe it's not your job to answer questions, but you're the clueful programmer in the team so everyone asks you. Do you stop what you are doing to help? It probably depends on who is asking and what you think of them. An occasional question from another good programmer gets an answer but you try to avoid the new hire who pretended to know Perl and now asks you how to use `split` because he can't remember that command to look up things and the bookshelf with [Programming Perl](https://www.programmingperl.org) is way on the other side of the office.

If you want a lot of XP, you answer any PerlMonks question you can, so you get the numerical (and perhaps actual) reputation for being the person with the answer. If you're like me when I was very active in usenet, you use the questions as challenges to learn more about Perl. You might be a rabid Perl promoter, so you answer questions so people think Perl is great because Perl people are nice and friendly. You might also just be a jerk that likes to show people that you know more.

Whatever your situation, you give up something (time, low blood pressure) to answer the question. Is what you give up worth what you get out of it? Being an open source or free software person doesn't mean you have to give stuff away; it's actually built around the principle that you're exchanging stuff with other people by sharing. You share a little here and someone else shares a little there. The questioner might not be sharing at all, although your answer might help other people who helped you, even if you don't ever find out about it.

## What you need to know about questions

People ask questions for many reasons, and not all of them mean the questioner wants just pure technical information. Sometimes he wants to confirm that he's thinking the right thing, figure out if he's on the right track, or ensure that all is well with the world.

Questions also socialize newcomers into a community. A Perl newbie may want to participate, but he can't come up with original information simply because he is new to the subject. The answers to simple questions give people a frame of reference they can use to judge the new group and where they stand in it. If newbies never participate they'll remain outside the community as lurkers.

Other people ask questions because they are greedy leeches who think the world revolves around them and that you are compelled, simply by your knowledge, to spend your time answering their questions. These people typically think that if they can't learn something in 15 minutes, they have to find someone to blame. Their time is valuable and they don't like it when you waste it by not stopping your life to spoon feed them, do their homework, or save their job. These people not only think "free beer", but "why don't you pay for dinner too?"

A handful of people ask questions just to annoy you or watch the ensuing chaos. Trolls keep doing it because it keeps working too. People forget to think about what it costs them to answer and what they get out of it.

Finally, most people simply can't ask a good question. No matter how many HOWTOs, guides, or other resources we create about asking good questions, these people aren't going to ask good questions. If they read the HOWTOs, guides, and other resources, they probably wouldn't be asking questions.

## What do they get out of it?

Part of my question-answering process is thinking about why the person is asking the question. Part of that means finding the context for the question (that's next), but also to figure out the social implications of the answer.

For instance, someone might ask "Could I delete the root directory?", and I could, without thinking too much about it, say "Yes".  But what did I really just answer? Here are some possibilities:

*He was simply wondering if it was technically possible
*He's wondering if what he's doing has security implications
*He wanted me to tell him how to do it (indirect question)
*He knows how to do it but wants to see if I know how to do it
*He was asking permission to actually do it ("Well, brian said I could!")
*He's telling me to delete the root directory (an implied "for me?" on the end)
*He's avoiding work, but if it looks like he's talking to me, the boss won't be mad
*He wanted to see if I was actually listening
*He's new to me and he's using it to introduce himself and establish his street cred
*He's trolling for a reaction
*He's distracting me while his buddy steals my laptop (happened at an OSCON, actually, but not to me)

It's a bit of a contrived question, but the literal text is not everything that's going on. Sometimes the answer doesn't have anything to do with the literal question.

## Find the real question

Sometimes people ask the question they think they have, but they don't realize it's not the right one. That's understandable if they are new to the subject area or the technology. It actually takes a pretty good grasp of the subject to ask the right question. When someone asks a direct question, hiding all of the context of it, they still might be asking the wrong question. See [XYZ Questions](https://www.perlmonks.org/index.pl?node_id=6672).

The right answer will almost always depend on the context, and that context might not even be apparent to the questioner. Sometimes, just by asking the question, the questioner figures out what he really wants.

## Ask clarifying questions

People are much better at answering questions and directing questioners to the appropriate resources because we can do all of that fuzzy logic stuff that we haven't been able to cram into computers yet.

A good clarifying question is "What are you trying to do?", although it's even better as "What do you want to happen at the end?". Usually, it doesn't really matter how they are trying to do it as long as they get it done. If they were asking a good question they'd have already told you that, but they didn't.

## You're better than your computer

People want to ask other people questions. Asking Google or other search engines isn't always that effective since the questioner often can't judge the reliability or quality of the information, even if it comes from a person everyone else knows is a pretty good source. You might think Randal Schwartz is a good source of information because he writes Perl books, but remember that many other people write Perl books too. Simply being a Perl author doesn't mean you're useful, and the newbie can't tell the good authors from the bad ones.

Search engines can't really ask clarifying questions. Google and some others can detect misspellings, but that's about it. They lack the ability (so far), to recognize ambiguity or a lack of context. People can do that, given the right mindset, and ask more questions. Indeed, one of my questions for questioners is often "What are you trying to get out of this?". Forget the actual question and focus on the goal.

In the brick-and-mortar libraries, it's not the books that are the best sources, but the librarians. Librarians typically answer questions about how to find information. Now you're the librarian.

## You don't know all of the context

The technical context is just a part of the situation, and you should remember that when you answer the technical question. Often, the asker is trapped by other decisions, such as platform, version of Perl, and other things that might have much better options. Most people think that their situation can be better, but that's not up to them.

I've often been in situations where I'm stuck with what's already installed on the box. I haven't met any programmer that likes that (or, I guess, a sysadmin who doesn't), so don't get too worked up over things the questioner can't control. You don't have to live in his world, so you're naturally a lot more cavalier about what you think someone in his situation should do. I could install any Perl modules I like in my home directory, but what if I don't have a home directory? The target machine might not be one I get to use. I can bundle modules in various ways, but again, maybe the target machine or local policy just can't handle that.

The technical and social constraints don't always align themselves in the best way. It's usually not the questioner's fault, either.

## Don't sweat the small stuff

Along with the question probably comes a lot of small details that are a bit off or not exactly right. Some parts may be completely wrong, but have nothing to do with the real problem. Just ignore those parts. An answer that tries to correct every detail dilutes the meat of the answer.

## Do you actually know the answer?

Knowing the answer involves the technical chops to handle the question but also the experience to judge its suitability for the context. Unfortunately, lacking experience for the context usually means that you don't realize that you shouldn't answer the question. It's in these situations where I make my biggest mistakes. :(

Another common problem in this area is simply parroting what you've heard other people say, even though you have no real experience with it yourself (which is probably more common to kiddie communities). You can read all the Oracle mailing lists you like, but that doesn't give you the chops of an Oracle DBA. Just because other people say something doesn't mean it's right, so you shouldn't pass it along unless you know it to be true. Alternately, you can simply point people to the place where you read the answer and leave it up to the questioner to decide its value.

Just because you don't know the answer doesn't mean you shouldn't answer the question, but you should be more careful in that case. This is often a problem when you can say something about the literal question, but don't have any experience with the context. You might be able to set up an email server on your home Linux box just fine, but that doesn't mean you know how to set up one for regulatory compliance, so your answer might be crap.

Still, answering questions is sometimes really just a way to ask questions. You put some information out there and see if anyone complains. Despite the risk of looking stupid and leading someone in the wrong direction, this can be an effective learning tool for the answerer. You won't get better at answering questions if you never try.

In terms of PerlMonks, writing your own sample program and checking the docs to verify what you are going to answer can help.

## Do you have to answer the question?

What happens if you don't answer the question? Does the world end?

What happens if you do answer the question? Maybe you get some XP and people think you're cool.

I used to feel compelled to answer any question I could. If I knew the answer, I felt a little bit of responsibility for passing on my knowledge, especially if it wasn't something in the documentation. Now I choose the questioners I answer, asking myself "Is this something I really want to spend time on?"

You might have different questions to ask yourself, but consider what you have to give up or endure. If you don't like newbie questions, stealth homework problems, or looking at code that doesn't `use strict`, then don't bother with those questions. Why let the cluelack of others take up your time? Control your life by not letting other people control your time.

Maybe the question hasn't been answered by anyone else, so you think you want to jump in there so the questioner doesn't feel lonely.

## Good answers have three components

Good answers have three components, and I try to get all of them in there (although I may not always succeed). The trick is to educate the questioner about the particular topic, given the context it was in, but make it so he doesn't have to ask the question again. Give him the first fish, but also the fishing pole.

*A re-iteration of the question that establishes the limitations of the answer, perhaps reclarifying the question in light of other input (for instance, information in replies). This is something I do in speaking engagements, although usually to ensure everyone heard the question.
*The answer to the question.
*How the questioner could have answered this on his own (docs, website info, FAQs, etc). This part might take a little bit of research to see what Google says and what the questioner might have found. Even if the answer seems really obvious and it's the top hit in Google, other people might appreciate the link as well as how you found it (i.e. keywords).

## Further Reading

Here's some other good resources and threads:

*[XY Problem](https://www.perlmonks.org/?node_id=542341)
*[How to answer questions](https://www.perlmonks.org/index.pl?node_id=602469)
*[On Answering Questions](https://www.perlmonks.org/index.pl?node_id=233565)
*[A reply by Randal to Alan Flavell about the XY problem](http://groups.google.com/group/comp.lang.perl.misc/msg/9ed7fd04080e144c)

