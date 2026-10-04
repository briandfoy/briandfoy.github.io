---
layout: post
status: _posts
title: Don't finish too soon
categories: graduate-school programming
tags: perl tru64
stopwords:
last_modified:
original_url:
---

I must have written this story somewhere, but I can't find it. I think this was the first or second year I was casually using Perl. It must have been the first year because I think this was the summer before I officially started grad school, and I had been farmed out as an intern to a national lab.

<!--more-->

This is a long tale of intrigue and betrayal, hopes and dreams, and all that. In the end, a simple Perl script from a Perl newbie, me, saved months of work. It wasn't even a clever script, and I probably could have done it with awk or sed, but I had never used those.

The head scientist of the research team led me to a small room with government shelves, a government desk, and a government chair. If you've worked for the US government (and especially the Navy), you've probably been in offices with the same stuff. Look it up: the design around the Navy chair is actually interesting. The colors, the drab gray and green, in a small room with cinder block walls painted white, were not as interesting.

On these shelves were piles upon piles of print outs—the sort from the dot matrix printers of yore. Wide, accordian-folded perforated paper with large, horizontal green and white bands. Look that up too, or look out for the next time you travel. Airlines and rental car companies are still using dot matrix printers.

I was tasked with going through all of these printouts, finding two numbers deep inside each, and making a table. Fine.

Those printers weren't personal ones that sat in your office. They were kept in a secret room where the high priests of IT would care for and feed them. When you wanted to "print" something, you gave the right command from your terminal, which would then tell you it was queued and that your department had just been charged 17 cents. Yeah, there were budgets.

Then you'd have to wait some period of time before you visited the rectory to look through the printouts in the basket to find yours. Each printout had a summary page on the top that showed who initiated it, what file it printed, and so on. Oh, the cover page has the filename on the front. Isn't that interesting?

Now, I'd been in the military and carried the custom of bribing the supply officers into civilian life. It's amazing how well you can be treated when you introduce yourself with a basket of Belgium beers. The operators were happy to find those files for me and put them in a directory of the Tru64 account they created for me. Or maybe it was still Digital UNIX back then, but the point was that it wasn't a VMS machine.

Once I had the files, it was easy to read them, extract the lines I wanted since they were well-labeled, and make the table. I made a practical extraction and reporting tool with this practical extraction and reporting language. Any about halfway through the original *Learning Perl* could do such a thing. It probably was something clunky like this, keeping in mind that Perl 5 was just hatching into the world, and even then I barely knew Perl 4 (although I was extracting myself from FORTRAN by using C when I could):

	open FILE, $file;
	while(<FILE>){
		next if ! /SOME HEADING/;
		foreach (1..3) {
			scalar <FILE>;
			}
		$_ = <FILE>
		($col1, $col2) = /Marker:\s+(\S+).*\s+Thingy:\s+(\S+)/;
		printf OUT "%s %f %f\n", $file, $col1, $col2;
		last;
		}

I might have used Perl 4's formats, which I still think are really cool even if just for the pagination and page headers, even in the terminal. But it's not about how cool the tech is; it's about how much effort it saves you.

There's nothing amazing about this program or structure. I'm not going to win any awards, and I think it took me about three hours to throw together with all the other bits I needed to handle. I probably used Perl because I was trying to learn it at the time, not because I thought it was the best tool. At the time, I could have done this in C, which I would now think was annoying, but at the time `sscanf` was still pretty fun for me.

I took a break at lunch and stood on the stoop with a Romanian scientist who had to go outside to smoke, which was often. That stoop was right next to this room I'd been warehoused in, so when I was taking a break, that's where I was too.

He was a really good scientist, I'd come to find out, but he was a nice guy too, which I would later think was odd just because, culturally, I would not expect that. He was the sort who knew he knew his shit, so he didn't have to tell anyone and make anyone else feel bad about it, which I have to say, was very un-American in my grad school experience. He had worked under Ceaușescu, not just in that regime, but pretty close to the top of the heap, I was told, so that kinda puts things in proper perspective for him, I bet.

So he's asking me about my task and how it's going, if I have everything I need, if I know where the cafeteria was, and other sorts of things a new person would need to know. Quite gracious, I thought. It's then that the head scientist comes out; I think mostly because he doesn't understand why two people are talking to each other without him. He was the American and acted like I might expect at my young age that an Eastern-bloc scientist might, and the actual Eastern-bloc scientist is totally chill.

So I make my first big mistake in grad school. I tell him I had a rocky start, but I should be done by the end of the day or by the time he comes in the next day. By my own yardstick, I was behind the curve, which isn't a tragedy on your first day, but I still didn't like it.

Apparently, the head scientist had given me this task to keep me busy for a couple of months and got upset with the Romanian scientist for reasons, I guess. The reaction was uncalled for. I'm some dippy intern, so why are you yelling at him? Why are you yelling at anyone? Maybe he was upset that he'd have to give me a different task for that summer. And he did, sorta, and I got first-author credit on a "brief report" in *Phys. Rev. C* as I recall, which is kinda a big deal. Again, nothing clever, but just me moving around data and making random plots until something looked neat, with Perl and Lotus 1-2-3.

Anyway.

So I have this file on a Unix account, which was a new problem. "How'd you get that?" Um, I asked for one when I had to set up my other accounts? It's just insane, and I won't go through all the drama, but it involved pulling random printouts off the shelf and spot-checking. Yeah, already did that, literally with the paper versions, and my output was correct every time.

Then I made the next big mistake of my grad school career, and I hadn't even started classes yet. This should have been the big clue that I wasn't right for this world. The Romanian scientist mentioned my script to a scientist in a different group on the down-low, and that scientist came over to talk to me about doing the same thing for him. As I recall, it was the same dataset, but he wanted different parts of it. Sure, it's an easy thing. I had access to perl, it was easy for me to run the program when he wanted it, so what's wrong with that?

I don't recall how it went down, but I think I sent him the results and he was happy, but I didn't know that that whole thing should have gone through the head scientist, like there was this unspoken Politburo that we were navigating around. I'm just stepping on all the landmines, and here I thought we were all on the same side. But, fair enough, tell your boss what is up, but I wouldn't find out about things like stand-ups for a while yet, and in the military the officer would ask, "Do I want to know this?" and hope you said no. Whatever.

The related mistake was that I was supporting two versions of a one-off program, and this was long before I knew about source control, proper general programming habits, and all that. You know, regular scientific computing. I didn't really mind it, and if it was easy for me and it helped someone without interfering with my work, hell yeah.

Long story short, I was being too productive too quickly. That's not a boast, because I obviously won the battles and lost the war since I left grad school with no degree. This kept happening, and it was a problem; although Perl was often involved, the automation was the big win.
