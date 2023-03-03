---
layout: post
title: Simple mail processing
categories: system-administration
tags: leanpub mail
stopwords: IMAPing procmail IMAP linux sunsetted mbox
last_modified:
original_url:
---

Why can't things be simple anymore? Why can't I easily send a Gmail message to some sort of action and save the result? There is a way to do this, but it's a deep pit of despair that delves into a long questionnaire by Google about how I want to use their API, how I'm going to protect user data, and many other things. Even if I made it through all of that—and I didn't—the API docs are just crap.

<!--more-->

I want to process my Leanpub royalty data. I can make a request for that data at a particular endpoint, after which LeanPub will email me a link to a file on S3. I understand there's a bit of capacity planning here because LeanPub may not be able to make the file right away, but so far I always get the email right away. And that email has to go to my account email, which is my Gmail address.

![](/images/leanpub/wait_for_mail.png)

Here's the process so far:

* Visit a Leanpub page that automatically creates the job
* Wait for the email
* Follow the link in the email

That's a pain in the ass, but I go through it to figure out [my sales report](/leanpub-monthly-sales/). It really doesn't take that much time, and I certainly spent more time today thinking about this than I would all year just doing it manually. But, it bugs me that I don't have this down to something that just does it for me.

Part of this might be yak shaving, and some of it is just putting my house in order. Sure, the steps themselves aren't that hard, but I have to remember to do them and it's then a thing in my Reminders app, and the cognitive load of knowing I have to do things is an extra hassle. So much of automation is not about labor saving so much as predictable schedules and reliable execution. Oh, that thing you were supposed to do today? It's done and here are the results.

How would I like this happen? I'd really like to follow that email link in some sort of Google action, process the CSV data it gives me, and populate a shared Google Sheet. I'm thinking something similar to an AWS Lambda would work nicely. I don't even mind that I might have to write JavaScript for that. Python would be fine. Anything would be fine.

I don't expect that to be a feature the almost any Gmail user would use, but I'd certainly expect some mechanism for experts. I don't want to write an app that follows the rules for global distribution when I want to use it personally, even if it would be interesting to other Leanpub authors. This gets back to how much power and autonomy we've lost in technology, and even a coming dark age where no one can do anything unless AWS provides a service for it.

I thought about IMAPing all the messages, but that was so much code just to get to the messages I wanted. Gmail can apply labels to them, but then I had to do a lot of low-level stuff to filter through that because it's not basic IMAP stuff. Most of the libraries I found were old and unsupported. No thanks.

Then I went old school. I have fond memories of *procmail*, which filters mail and does almost anything I can imagine. I can match on just about anything and then pipe the result to a program. It's basic Unix ideas: small things doing their job well. And, once I succumbed to the old ways, the job got much easier (and much easier to understand). It doesn't even need any of the mail infrastructure! It happily works on mbox files.

* Gmail forwards those messages to a special address I designate
* The address merely saves the raw mail in its own file
* I sync the files locally
* I process the files
* Done

I tried that for awhile, doing most of the processing on the machine that received the mail. This is similar to what I did in grad school to run a bunch of code on VMS from a Unix machine ([Running all the simulations](/running-all-the-simulations/)).

That fine, but I don't really use the machine that gets the mail; I gave up maintaining my mail infrastructure decades ago. Indeed, as I was playing with this problem there, I was also cleaning out lots of Perl v5.6 programs I had written and were still running in cron to make output files I never read.

But then, I shifted away from that being too complicated too. I'd just forget about it again because I almost never log in there. All I really need is the mail file. I can copy that to where I like and process it there. And this is a beautiful idea: I can process it anywhere if I have easy access to the data. I don't need to waste time with a baroque cloud platform.

It's as simple as this *Makefile*, which I can run from anywhere (*i.e.* not the machine receiving the mail). The only tricky part is a delay between requesting the report from Leanpub and starting the rest of the job. I have a target that merely sleeps.

{% highlight text %}
all: request sleep120 report

.PHONY: sleep120
sleep120:
	@ echo "Sleeping for two minutes"
	@ sleep 120

.PHONY: request
request:    ## request the report from Leanpub
	@ echo "Requesting royalty report"
	@ open -a Safari 'https://leanpub.com/u/briandfoy/generate_all_royalties_csv'

.PHONY: report
report.txt: latest_royalties.csv   ## make the report
	perl leanpub_sales latest_royalties.csv > $@

latest_royalties.csv: my_inbox  ## extract the CSV from the mail file
	perl leanpub_royalties my_inbox > $@

my_inbox: ## fetch the remote mail file
	@ echo "Fetching mail file"
	@ rm -f $@
	scp -q mail_machine:mail/$@ $@

######################################################################
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help ## Show all the Makefile targets with descriptions
help: ## show a list of targets
	@ grep -E '^[a-zA-Z][/a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
{% endhighlight %}

Also interesting is that I use Safari to request the file. There's a bunch of JavaScript that sets various things to log in, so I can't write a simple Mojo program to do that. Since Safari (as well as other browsers) handle that JavaScript and keep me logged in via a cookie, I'm fine. I also thought about extracting that cookie from Safari and using it with another user agent, but that's still too much work even if it would be fun (and I am the author of various CPAN modules that could handle every part of that).

I can run a target manually, but I also have it set up in my *crontab*:

{% highlight text %}
13 1 * * * cd /Volumes/Scratch/Leanpub && make
{% endhighlight %}

Most of that can work on the machine receiving the mail. I have a tremendous amount of flexibility here, all of which we give up by using vendor services like Google and AWS. My solution is provider-agnostic, it's simpler, it's easier to change and re-engineer, and it's working. Not only is it working, but it's actually a pretty slim solution without extra stuff I tolerate because someone else decided I needed to go through extra steps.

The big weakness is the interactive browser losing its credentials or the cookie expiring. I could extend this a bit to script a browser to fill in the login form, etc, but Leanpub site has never kicked me out in the year or two I've been using it so I think I good with that for awhile.

Finally, I like to note that I very little that didn't already exist on the base system (well, aside from installing Command Line Tools for macOS, I guess). I'd have to install a few perl modules, but I tend to be minimal there too. If I wanted to move this to linux, and maybe even Windows, the steps are the same with minor variations for how they actually do it. Had I done this on Google, that's the only place I'd be able to do it, and when they sunsetted that system, I'd have to start over.
