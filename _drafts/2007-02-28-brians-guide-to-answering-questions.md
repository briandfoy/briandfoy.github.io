---
layout: post
title: brian's guide to answering questions
categories: programming
tags: rescued-content guide
stopwords:
last_modified:
---

https://www.perlmonks.org/?node_id=602571

[ <i>DrHyde just posted [id://602469], and I've had this guide sitting on my desktop for several months as I've slowly worked on it. I haven't added PerlMonks specific parts yet, but I figured I should just put it out there. I'll update the orginal post for new stuff to keep everything together, and try to put in update markers where it might confuse the discussion to see new or changed material.</i> ]


<p>Answering questions well is a skill, although not necessarily one in explaining things cogently. Picking the right questions to answer and avoiding the time wasters helps quite a bit too.

<h2>What do you get out of it?</h2>

<readmore>
<p>Someone has asked a question, whether directly or in a public forum, so you have to figure out if you should answer it. As a Perl trainer, I have to answer the questions from students. It's my job. As a PerlMonks reader, I don't have to answer questions.</p>

<p>Maybe it's not your job to answer questions, but you're the clueful programmer in the team so everyone asks you. Do you stop what you are doing to help? It probably depends on who is asking and what you think of them. An occasional question from another good programmer gets an answer but you try to avoid the new hire who pretended to know Perl and now asks you how to use <code>split</code> because he can't remember that command to look up things and the bookshelf with <i>Programming Perl</i> is way on the other side of the office.

<p>If you want a lot of XP, you answer any PerlMonks question you can, so you get the numerical (and perhaps actual) reputation for being the person with the answer. If you're like me when I was very active in usenet, you use the questions as challenges to learn more about Perl. You might be a rabid Perl promoter, so you answer questions so people think Perl is great because Perl people are nice and friendly. You might also just be a jerk that likes to show people that you know more.</p>

<p>Whatever your situation, you give up something (time, low blood pressure) to answer the question. Is what you give up worth what you get out of it? Being an open source or free software person doesn't mean you have to give stuff away; it's actually built around the principle that you're exchanging stuff with other people by sharing. You share a little here and someone else shares a little there. The questioner might not be sharing at all, although your answer might help other people who helped you, even if you don't ever find out about it.</p>

<h2>What you need to know about questions</h2>

<p>People ask questions for many reasons, and not all of them mean the questioner wants just pure technical information. Sometimes he wants to confirm that he's thinking the right thing, figure out if he's on the right track, or ensure that all is well with the world.</p>

<p>Questions also socialize newcomers into a community. A Perl newbie may want to participate, but he can't come up with original information simply because he is new to the subject. The answers to simple questions give people a frame of reference they can use to judge the new group and where they stand in it. If newbies never participate they'll remain outside the community as lurkers.</p>

<p>Other people ask questions because they are greedy leeches who think the world revolves around them and that you are compelled, simply by your knowledge, to spend your time answering their questions. These people typically think that if they can't learn something in 15 minutes, they have to find someone to blame. Their time is valuable and they don't like it when you waste it by not stopping your life to spoon feed them, do their homework, or save their job. These people not only think "free beer", but "why don't you pay for dinner too?" </p>

<p>A handful of people ask questions just to annoy you or watch the ensuing chaos. Trolls keep doing it because it keeps working too. People forget to think about what it costs them to answer and what they get out of it.</p>

<p>Finally, most people simply can't ask a good question. No matter how many HOWTOs, guides, or other resources we create about asking good questions, these people aren't going to ask good questions. If they read the HOWTOs, guides, and other resources, they probably wouldn't be asking questions.</p>

<h2>What do they get out of it?</h2>

<p>Part of my question-answering process is thinking about why the person is asking the question. Part of that means finding the context for the question (that's next), but also to figure out the social implications of the answer.</p>

<p>For instance, someone might ask "Could I delete the root directory?", and I could, without thinking too much about it, say "Yes".  But what did I really just answer? Here are some possibilities:</p>

<ul>
<li>He was simply wondering if it was technically possible
<li>He's wondering if what he's doing has security implications
<li>He wanted me to tell him how to do it (indirect question)
<li>He knows how to do it but wants to see if I know how to do it
<li>He was asking permission to actually do it ("Well, brian said I could!")
<li>He's telling me to delete the root directory (an implied "for me?" on the end)
<li>He's avoiding work, but if it looks like he's talking to me, the boss won't be mad
<li>He wanted to see if I was actually listening
<li>He's new to me and he's using it to introduce himself and establish his street cred
<li>He's trolling for a reaction
<li>He's distracting me while his buddy steals my laptop (happened at an OSCON, actually, but not to me)
</ul>

<p>
It's a bit of a contrived question, but the literal text is not everything that's going on. Sometimes the answer doesn't have anything to do with the literal question.
</p>


<h2>Find the real question</h2>

<p>Sometimes people ask the question they think they have, but they don't realize it's not the right one. That's understandable if they are new to the subject area or the technology. It actually takes a pretty good grasp of the subject to ask the right question. When someone asks a direct question, hiding all of the context of it, they still might be asking the wrong question. See [id://6672]</p>

<p>The right answer will almost always depend on the context, and that context might not even be apparent to the questioner. Sometimes, just by asking the question, the questioner figures out what he really wants.</p>

<h2>Ask clarifying questions</h2>

<p>People are much better at answering questions and directing questioners to the appropriate resources because we can do all of that fuzzy logic stuff that we haven't been able to cram into computers yet.</p>

<p>A good clarifying question is "What are you trying to do?", although it's even better as "What do you want to happen at the end?". Usually, it doesn't really matter how they are trying to do it as long as they get it done. If they were asking a good question they'd have already told you that, but they didn't.</p>


<h2>You're better than your computer</h2>

<p>People want to ask other people questions. Asking Google or other search engines isn't always that effective since the questioner often can't judge the reliability or quality of the information, even if it comes from a person everyone else knows is a pretty good source. You might think Randal Schwartz is a good source of information because he writes Perl books, but remember that many other people write Perl books too. Simply being a Perl author doesn't mean you're useful, and the newbie can't tell the good authors from the bad ones.</p>

<p>Search engines can't really ask clarifying questions. Google and some others can detect misspellings, but that's about it. They lack the ability (so far), to recognize ambiguity or a lack of context. People can do that, given the right mindset, and ask more questions. Indeed, one of my questions for questioners is often "What are you trying to get out of this?". Forget the actual question and focus on the goal.</p>

<p>In the brick-and-mortar libraries, it's not the books that are the best sources, but the librarians. Librarians typically answer questions about how to find information. Now you're the librarian. </p>

<h2>You don't know all of the context</h2>

<p>The technical context is just a part of the situation, and you should remember that when you answer the technical question. Often, the asker is trapped by other decisions, such as platform, version of Perl, and other things that might have much better options. Most people think that their situation can be better, but that's not up to them.</p>

<p>I've often been in situations where I'm stuck with what's already installed on the box. I haven't met any programmer that likes that (or, I guess, a sysadmin who doesn't), so don't get too worked up over things the questioner can't control. You don't have to live in his world, so you're naturally a lot more cavalier about what you think someone in his situation should do. I could install any Perl modules I like in my home directory, but what if I don't have a home directory? The target machine might not be one I get to use. I can bundle modules in various ways, but again, maybe the target machine or local policy just can't handle that. </p>

<p>The technical and social constraints don't always align themselves in the best way. It's usually not the questioner's fault, either.</p>

<h2>Don't sweat the small stuff</h2>

<p>Along with the question probably comes a lot of small details that are a bit off or not exactly right. Some parts may be completely wrong, but have nothing to do with the real problem. Just ignore those parts. An answer that tries to correct every detail dilutes the meat of the answer.</p>

<p><b>Update:</b>: For PerlMonks, niggling things such as spelling, bad links, and pointers to thinkos might be better in /msg-s. You can still point out the small stuff but you don't make it part of the conversation. It's like whispering to someone that their fly is open, but not announcing it to the whole group. :)
</p>

<h2>Do you actually know the answer?</h2>

<p>Knowing the answer involves the technical chops to handle the question but also the experience to judge its suitability for the context. Unfortunately, lacking experience for the context usually means that you don't realize that you shouldn't answer the question. It's in these situations where I make my biggest mistakes. :(</p>

<p>Another common problem in this area is simply parroting what you've heard other people say, even though you have no real experience with it yourself (which is probably more common to kiddie communities). You can read all the Oracle mailing lists you like, but that doesn't give you the chops of an Oracle DBA. Just because other people say something doesn't mean it's right, so you shouldn't pass it along unless you know it to be true. Alternately, you can simply point people to the place where you read the answer and leave it up to the questioner to decide its value.</p>

<p>Just because you don't know the answer doesn't mean you shouldn't answer the question, but you should be more careful in that case. This is often a problem when you can say something about the literal question, but don't have any experience with the context. You might be able to set up an email server on your home Linux box just fine, but that doesn't mean you know how to set up one for Sarbanes-Oxley compliance, so your answer might be crap.</p>

<p>Still, answering questions is sometimes really just a way to ask questions. You put some information out there and see if anyone complains. Despite the risk of looking stupid and leading someone in the wrong direction, this can be an effective learning tool for the answerer. You won't get better at answering questions if you never try.</p>

<p>In terms of PerlMonks, writing your own sample program and checking the docs to verify what you are going to answer can help.
</p>

<h2>Do you have to answer the question?</h2>

<p>What happens if you don't answer the question? Does the world end?</p>

<p>What happens if you do answer the question? Maybe you get some XP and people think you're cool. </p>

<p>I used to feel compelled to answer any question I could. If I knew the answer, I felt a little bit of responsibility for passing on my knowledge, especially if it wasn't something in the documentation. Now I choose the questioners I answer, asking myself "Is this something I really want to spend time on?"</p>

<p>You might have different questions to ask yourself, but consider what you have to give up or endure. If you don't like newbie questions, stealth homework problems, or looking at code that doesn't <code>use strict</code>, then don't bother with those questions. Why let the cluelack of others take up your time? Control your life by not letting other people control your time.</p>

<p>Maybe the question hasn't been answered by anyone else, so you think you want to jump in there so the questioner doesn't feel lonely. </p>

</readmore>

<h2>Good answers have three components</h2>

<p>Good answers have three componenets, and I try to get all of them in there (although I may not always succeed). The trick is to educate the questioner about the particular topic, given the context it was in, but make it so he doesn't have to ask the question again. Give him the first fish, but also the fishing pole.
</p>

<ul>
<li>A re-iteration of the question that establishes the limitations of the answer, perhaps reclarifying the question in light of other input (for instance, information in replies). This is something I do in speaking engagements, although usually to ensure everyone heard the question.
<li>The answer to the question.
<li>How the questioner could have answered this on his own (docs, website info, FAQs, etc). This part might take a little bit of research to see what Google says and what the questioner might have found. Even if the answer seems really obvious and it's the top hit in Google, other people might appreciate the link as well as how you found it (i.e. keywords).
</ul>

<b>Update</b>: Here's some other good Monastery resources and threads, and maybe even some external links:

<ul>
<li>[id://233565]
<li><a href="http://groups.google.com/group/comp.lang.perl.misc/msg/9ed7fd04080e144c">A reply by Randal to Alan Flavell about the XY problem</a>
</ul>

<!-- Node text goes above. Div tags should contain sig only -->
<div class="pmsig"><div class="pmsig-366986">
-- <br />
brian d foy <brian@stonehenge.com><br />
Subscribe to <a href="http://www.theperlreview.com">The Perl Review</a>
</div></div>

