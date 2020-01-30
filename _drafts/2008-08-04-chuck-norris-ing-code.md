---
layout: post
title: Chuck Norris-ing code
categories:
tags: rescued-content
stopwords:
last_modified:
---

https://www.perlmonks.org/?node_id=702200

<p>
Sometimes when [merlyn] or I consult on Perl projects, it turns out that the client expects a magic wand. Somehow, because we have our names on books or speak at conferences, when we load code into an editor, that alone should magically fix things while at the same time not changing any code or any part of the process. Randal has started calling  this "chuck norris"-ing the code. I don't know if he invented the phrase, but it's likely. &mdash;<b>Update</b> Randal says he hasn't heard anyone use it, so I say he's the inventor.
</p>
<p>
Chuck Norris is a real, yet mythic and legendary figure for Americans. He's a kick ass martial arts guy who fought Bruce Lee in <a href="http://www.imdb.com/title/tt0068935/">Meng long guo jiang</a>. In his various movies and TV series he saves the world through force of will and by just showing up. Chuck Norris is the man who can do anything, and the universe is afraid of him. Not just the people in the universe, the actual universe itself.
Chuck Norris's abilities are collected in <a href="http://www.chucknorrisfacts.com/">Chuck Norris Facts</a>, which include:
</p>
<ul>
<li>Chuck Norris doesn't read books. He stares them down until he gets the information he wants.
<li>Chuck Norris’ hand is the only hand that can beat a Royal Flush.
<li>Chuck Norris can lead a horse to water AND make it drink.
<li>Chuck Norris doesn’t wear a watch, HE decides what time it is.
</ul>
<p>
When Stonehenge  consults, we normally accept clients we think we can help. We're not firefighters or contractors; we want to help people use Perl effectively. We want to leave your work environment a better place through actual consulting (where we discover and advise) and training. Typically, these situations are one of three situations:
</p>
<ul>
<li>Things are slow, and we don't know why or how to fix it
<li>Things take up too much memory, and we don't know how to fix it
<li>Things can be better, but we don't know where to start
</ul>
<p>
For most of our clients, this works out just fine. We spend a concentrated amount of time looking at everything and can point the way. It's not always that the client doesn't know, but that they need someone else to say it for them. The tech people convince the managers by having us confirm what they have been saying. In other cases, they just need a little push in the right direction.
</p>
<p>
For the occasional client, often a very big company, hires us and makes all the right noises about their commitment to improving their work process, yada yada, and we schedule a week to do the initial assessment. These clients often don't have test machines or even a test suite. No big deal. Those are things that we can fix.
</p>
<p>
However, there is this weird sub-group of companies who pay consultants for answers they never intend to use, even setting aside the situations that are just kick-backs, money laundering, and so on. We ask about getting an account on the test machine, but they tell us that's the same as the production machine. Okay, so no test machines, mark that down for the report. Next we want to run the test suite to benchmark the code. We can't report where to ended if we didn't figure out where we started. Some companies don't have test suites. That's not a big deal. Again, we're here to help. However, there's a small group that also doesn't want a test suite. "We don't have time to write tests", yada yada. They know what they need to do but have some social roadblocks to solve.
</p>
<p>
This brings us to another, even smaller group&mdash;the one that motivates this post. This smaller group doesn't want to change the code! We can make all the recommendations we like, such as "use DBI instead of system calls to talk to the database" or "expat is a lot faster than regular expressions on 100Mb files!", but that doesn't matter. Change is bad, and editing files is change, so editing files is bad. We know how to commit to revision control, but not branch or revert, so don't change anything! Oh, and we all share the same working copy and we're used to that so we're going to keep doing that. They want us to make everything better without changing anything (anything at all), as if we could "chuck norris" the situation:
</p>

<ul>
<li>The system works because Chuck Norris tells it to work
<li>Chuck Norris doesn't need a test suite. The test suite needs Chuck Norris.
<li>CPUs run faster to get away from Chuck Norris
<li>Chuck Norris normalizes all schema just by inserting random data
<li>Chuck Norris can compile syntax errors
<li>Packets travel faster than the speed of light for Chuck Norris, but he can still catch them
<li>Chuck Norris has Internet 3
<li>Check Norris can parse invalid XML
<li>Chuck Norris can break Moore's Law
<li>Chuck Norris's brain is his revision control, and it works better than git
</ul>

<p>
Most of all, though, "chuck norris" is now our code name for jobs where we were hired to do something specific which we are then not allowed to actually do:
</p>

<ul>
<li>Chuck Norris can fix everything without changing anything.
</ul>

<p>
I like this phrase, and it might even be a way to bring up the subject with managers and other roadblocks without being so serious. I hope that we don't have more clients like that though. :)
</p>

<!-- Node text goes above. Div tags should contain sig only -->
<div class="pmsig"><div class="pmsig-366986">
-- <br />
brian d foy <brian@stonehenge.com><br />
Subscribe to <a href="http://www.theperlreview.com">The Perl Review</a>
</div></div>
