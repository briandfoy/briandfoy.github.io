---
layout: post
title: How I learned perl
categories: personal-history
tags: perl perl-mongers
stopwords:
last_modified:
original_url: https://www.perlmonks.org/?node_id=385334
---

*I originally posted this at Perlmonks as [How I Learned Perl](https://www.perlmonks.org/?node_id=385334)*

I was going through some papers in my office, mostly because I've been having a lot of fun with my new shredder. I ran across my receipts for [Learning Perl](https://www.learning-perl.com) and [Programming perl](https://www.programmingperl.org). Yep, the first edition of the Camel book has a lowercase "perl".

So I started to piece together what has happened since then. My memory isn't complete, and I think I have the order mixed up a bit, but here's how I learned Perl. Most of this doesn't show up in any Perl history I've ever seen, so now it does.

---

Sometime during the summer of 1995 I decided to learn Perl, which puts me a year into graduate school where I was studying nuclear physics. I bought [Programming perl](https://www.programmingperl.org) on June 24, 1995 in Auburn, Mass., and [Learning Perl](https://www.learning-perl.com) on June 28 on Lon Gisland (so I must have been at Brookhaven that week).

<a data-flickr-embed="true" href="https://www.flickr.com/photos/47329375@N00/1098450746/in/dateposted-public/" title="learning-perl-receipt"><img class="center" src="https://live.staticflickr.com/1232/1098450746_91dbc7254d_n.jpg" width="216" height="320" alt="learning-perl-receipt"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

<a data-flickr-embed="true" href="https://www.flickr.com/photos/47329375@N00/1098455208/in/dateposted-public/" title="programming_perl_receipt"><img class="center" src="https://live.staticflickr.com/1396/1098455208_df5f4f18e1_n.jpg" width="239" height="304" alt="programming_perl_receipt"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>


I had a PowerBook 190 at the time, and when I commuted from Clark University to Brookhaven National Lab, I would work on the Llama stuff during the ferry ride, about an hour and a half each way. I used Perl for a few projects, but mostly I did FORTRAN because everything was VAX/VMS and we were doing physics, after all. I did manage to get an account on the unix machines, but none of the other scientists had accounts, so it wasn't very useful to our work. I made a bunch of tiny scripts to munge output files from FORTRAN programs (using Expect to transfer them from a VMS to an OSF/1 machine which had perl).

I did that for a while, and this thing called the Web was getting interesting, and Perl was a big part of it. I figured I should get paid to learn Perl, so I started Computer Dog, Inc. in Massachusetts (later incorporated in Connecticut) and got an account with MegaPath Networks. They selected my account name automatically: comdog. I still have that name today at PANIX only because everyone born in 1970 seems to be a Brian and work at an ISP. It has nothing to do with the military's "commo dogs".

There is nothing significant about "Computer Dog": I'm not imaginative when it comes to names, so I take the name of something I see. I happened to see a computer and a dog, which sounded better than "crack dealer" or "urban decay" which was the usual scene from my graduate school office.

So I learned Perl and wrote CGI stuff for a local printing company. That was a really cool gig: the up-and-coming son of the family company knew where all of this web stuff was leading, even back in 1996. We were working on real time typesetting right there at the start of the big boom.

During that time, I had to choose a "publication name" which I would use for the rest of my days as a scientist. That is, I chose one form of my name and used it consistently so the librarians would have an easier time finding my work, cross-referencing it, and forward-referencing it. I chose "B.D. Foy" because that's the way everyone else's name looked. I am far from the only B.D. Foy though, and I'm not the only [Brian D. Foy](https://www.wamc.org/post/dr-brian-foy-colorado-state-university-anti-mosquito-pill), but I am the only brian d foy.

I also started hanging out on usenet, and Google Groups says my earliest post was February 15, 1996, when I asked a completely wet-behind-the-ears newbie question on *comp.unix.aux*. I was already using an all lowercase version of my name by then, although I can't remember exactly when that started. Notice the full stop after the "d". Later that year, the full stop disappeared.

I was still using Perl 4, too. I started learning Perl right around the time that Perl 5 came out, but the books where still Perl 4, and I didn't really care that much about the difference. I was a newbie and the advanced features weren't really within my grasp.  That is, until someone from the ISP said they were going to stop supporting Perl 4 and I'd better convert everything to Perl 5. That wasn't really anything hard, really.

I wrote my first perl module, [Chemistry::Elements](https://www.metacpan.org/pod/Chemistry::Elements), so I could easily look up and convert between different representations of a element because various output formats I had to munge did them differently. I'm not sure that [BackPAN](http://history.perl.org/backpan/modules/by-authors/id/B/BD/BDFOY/) has accurate dates, but they are good enough.

Eventually I moved down to New Haven because I was continuing my studies at Yale (although I was not matriculated, just working in a nuclear lab down there). Whereas Clark University was DEC hardware, thus VMS, Yale was Sun hardware, so I got to learn Slowaris and emacs, both of which I finally managed to untangle myself from. I started doing a lot of Perl, along with some Tcl and Tk stuff to control hardware. In the great academic traditions, I was teaching myself a lot of different things, but I kept on with the Perl too. I used whatever got the job done, although DCL seemed pretty handy under that philosophy.

I also started doing a lot more outside work. As a lowly graduate student, and the newest one at the lab, I got the evening shifts. Oh no, not the briar patch! I was the night operator (on the experiments, not the sysadmin stuff) sometimes, so I just answered Perl questions on usenet until my shift was over. That was one of the best ways to learn Perl: solve somebody else's problems. **We don't learn by success, we learn by failure. The more failure you run into, the more you learn.**

I found the academic world of nuclear structure a bit silly and claustrophobic, so I decided to leave. This must have been 1996, I think. I got a job as a contract programmer with Smith Renaud, Inc. (SRI, but not [*that* SRI](http://www.sri.com/)) in New York City where I would do Perl all day long, mostly literally. I had a cot in my office and a membership at the Bally's around the corner where I could take a shower. I was still living in New Haven, so I would kill myself for three days, then take the train back to New Haven and take a couple days off, which meant working from home really.

Eventually I got tired of commuting and moved to New York. Actually, I know exactly when I decided to move: on the plane back from the first Perl Conference, which was August 1997. This was way back when the conference was just Perl, although it evolved into OSCON. I had just met Adam Turoff, Clay Irving, Dave Adler, M. Simon Cavalletto, Jeremy Bishop, and piglet. Together we created the [/New York Perl M((o|u)ngers|aniacs)*/](http://ny.pm.org/), and I decided that I wanted to live in the City.

New York is a center of publishing, and SRI had a lot of publishing clients. I had to put their data into msql and mysql, including the ISBNs for their books, but I discovered that about 10% of their data was just wrong. I created my second module, [Business::ISBN](https://www.metacpan.org/pod/Business::ISBN), to find the bad data. It found just about all of them, and this made the clients very happy.

So I worked really hard for a while, and kept plugging at being a usenet answer man and hanging out with NY.pm so I could learn all the cool restaurants and dives. We invited Randal Schwartz to hang out with us. He was a big name from the two books on Perl (THE two, because I think that's all there was then) and had a lot of work on Wall Street with [Stonehenge Consulting](http://www.stonehenge.com). He visited often because he was in New York a lot.

Sometime before the second Perl Conference, Adam and I got the idea that we should make a bunch of Perl user groups. I remember proposing the whole thing to Jon Orwant and Randal Schwartz over drinks at The Peculiar Pub. The Perl Institute was still around, and I didn't want to step on their toes. They said it was a good idea, so off we went with it. I think we had five or six by the time we got to the second Perl Conference. I think they were London, Philly, Toronto? and, um, I don't recall. I'll look them up later.

A momentary digression. Just about anything I've done in the Perl community I've done with Adam. He the first guy I talked to at The Perl Conference, and as I look back on  Perl mongers and other big things, Adam has been a part of it. Wierd.

Adam recently found the 200 odd sign-up sheets we put out at the conference. We basically squatted at a banquet table in the hall way. Then two tables. Then three. We made friends with the hotel staff. People signed up to receive information about a user group in their area. A new area got a new page. It was on the brink of chaos, but all of a sudden we had created this global monster that linked all sorts of Perl people. **Want to learn something? Know a bunch of people who already know it.**

The next big step is kinda fuzzy. I was still working at Smith Renaud and having a really good time doing it. I had met up with Randal at some midtown hotel bar, and there was light talk about something when I said something like "Why don't you let me teach for you?" and he said "Well, that's one of the reasons I'm in town." I think it took me a couple of minutes to spit out "No shit?". I don't think I seriously thought about teaching for him, but one of the reasons I had left grad school was the lack of teaching opportunities and I'd missed teaching.

That got the ball rolling. I had to sit through a Stonehenge class taught by Randal (I think Tom Phoenix and Joseph Hall were teaching then: two other frequent usenet posters, by the way), and I had to do it on my own dime. As I recall, the class was "Learning Perl" and it was at a huge internet infrastructure company in San Jose. At night I had to teach the course back to him, usually with him half in the bag. One night I had to go through a section right there in the noisy bar with him giving me the really bad student act. He really put the screws to me, but I guessed I passed.

I started teaching for Stonehenge one week a month, and it was a lot of money compared to what I was scraping out from SRI. The dot.com bust was on the horizon, and I knew it was coming because life just can't be that good. I hedged my bet by teaching with Stonehenge. **If you want to learn something, teach it.** Students asked me all sorts of things that I would have never thought about, even though I was still answering a lot of questions on usenet. I had to know a lot more just so I wouldn't look like an idiot in front of the classroom. Even better than that, I got to travel all over the place talking to a lot of different people. It seems to me that a lot of people get stuck in one or two jobs, and that's their experience. I was getting paid to see how different companies did their thing and talk to a lot of people in a lot of different situations. **I learned a lot of stuff, Perl and otherwise, just by listening to a lot of different people explain what they did**.

Around that time I got heavily into mod_perl. At the third Perl Conference, I hired Kurt Starsinic, and then [Design Patterns](https://amzn.to/2UlJeiE) was the big thing. Kurt introduced me to a couple of cool patterns that made the work we were doing a lot simpler. So many problems just disappeared forever. **If you want to learn things, hire people who are smarter than you.**

I suffered through SRI, Inc and that went on for a while, until around December 21, 2000. I can see a week long gap in my usenet postings, and when I came back I was using my *comdog@panix.com* address. It was a pretty bitter separation that involved lawyers and me taking the entire development team to another company. SRI died months later, and the sleazy money guy who forced me out was left to explain what happened to a lot of annoyed venture capitalists. You can see in the sig file that I've changed to "mod_perl hacker for hire". I posted to one of the NY.pm lists and had serious five job offers in two hours. I think I posted something like "I'm available. Who wants to hire me?" with no résumé. Remember that  Perl mongers thing I started? Well, there's the pay off.

I was quickly hired, and I took care of everyone who worked for me at SRI, although the next place turned out to be a real loser. I won't get into it: I still have friends there. This company didn't like that I was a CPAN contributor and that I gave talks at conferences. They saw that as a threat. The whole experience was a defining moment because I discovered I either had to sell myself to a single company or be on my own. This turned out to be the theme of the year. Luckily I was able to get work with Stonehenge, which I had cut back for a while.

During that, I was dating my future wife, and she moved to Chicago so I moved with her, although we kept an apartment in New York too, thinking that we would be back soon. Well, I'm still in Chicago. I ran into my soul-selling problem again when I went to interview for jobs in Chicago. They wanted to own me, which meant the end of most of my public Perl things. I remember sitting in the Starbucks at 100 N. Wacker just about ready to weep, and I haven't looked for a full time gig since then.

If I wasn't going to have a full time job, I needed to figure out something else. That's when I created *The Perl Review* (notice Adam is involved, again).

Well, that's enough for now. The rest isn't all that interesting because I haven't forgotten enough to make stuff up yet.


