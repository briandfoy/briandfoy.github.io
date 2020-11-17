---
layout: post
title: Check all you want, but the data are useless
categories:
tags: graduate_school
stopwords: pre
last_modified:
original_url:
---

While I was in graduate school in the late 90s, there was a particular scientist who wanted all of the graduate students to be working. It didn't matter if he was supervising them or not, but he was cracking the whip in the salt mines. He didn't even care if you were doing something useful or productive. You just had to be working.

His supervision was mostly logging onto the Unix system and running `who -u` to get the list of users logged in and their idle time. This is despite most people working in the same building and along the same hallway He could see output like this:

{% highlight plain %}
$ who
brian    ttys000  Jul 14 05:31 01:58 	 38798
joe      ttys001  Jul 11 08:47 05:57 	 90040
roger    ttys002  Jul 14 13:09   .   	 43772
{% endhighlight %}

If you were logged in, that was good. But, if you had been idle for too long, that was bad. He didn't want people to leave themselves logged in to get around his checks. Again, the particular activity didn't matter as long as you were busy.

I didn't particularly like this, and I didn't particularly like him. He didn't understand how I was able to produce results that ended up in papers, so he incentivized all the wrong things and discentivized the right things. I, in turn, discentivized his incentives.

At the time I was neck deep in TCL because I was doing a lot of Tk work to create interfaces to custom hardware and so on. This is pre-web stuff and Tk was advanced magic technology. A few lines of code turned into a graphical interface with clicky pointy buttons.

TCL had this amazingly library called [Expect](http://tcl.tk/man/expect5.31/expect.1.html). It allows you to programmatically interact with systems that think a person is on the other side. Here's a short program that logs in to some system and gets its output. It matches what it sees and sends input based on that. In this case, if it sees `$ ` (my prompt) in the output, it sends back some input. This little program waits five seconds, runs `who`, and then does it again. Forever. As long as I let this run, that login is never idle:

{% highlight tcl %}
#!/usr/bin/expect

spawn ssh some_system

expect {
	"$ " { sleep 5; send "who\r"; exp_continue }
	}
{% endhighlight %}


My actual program, which I've long since lost, was much more fancy with variable sleep times, random commands, and other red herrings.

But Expect pretending to be me wasn't the point. I went to this scientist and told him all about it. I was going to run ten or more of these all the time, and I was giving the program to all of the other graduate students. I told him he could keep checking as much as he liked, but he would never know what was real and what was fake.

If people are going use data against me, I'm going to make those data useless.

_2020 UPDATE_ Companies want to track our activity. Use the same trick. Automate your web browser to surf the web randomly. There's a plugin, [Track This](https://trackthis.link) that opens a hundred tabs of various things that you don't care about. Not only that, lots of business are trading money in referral clicks. The clicks are largely fake, but how do you know? It's basically click fraud all the way down, and everyone knows it. Yet, the money keeps changing hands.

