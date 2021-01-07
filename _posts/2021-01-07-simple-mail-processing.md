---
layout: post
title: Simple mail processing
categories: sysadmin
tags:
stopwords: IMAPing procmail
last_modified:
original_url:
---

Why can't things be simple anymore? Why can't I easily send a Gmail message to some sort of action and save the result? There is a way to do this, but it's a deep pit of despair that delves into a long questionnaire by Google about how I want to use their API, how I'm going to protect user data, and many other things. Even if I made it through all of that—and I didn't—the API docs are just crap.

I want to process my Leanpub royalty data. I can make a request for that data at a particular endpoint, after which LeanPub will email me a link to a file on S3. I understand there's a bit of capacity planning here because LeanPub may not be able to make the file right away, but so far I always get the email right away. And that email has to go to my account email, which is my Gmail address.

![](/images/leanpub/wait_for_mail.png)

Here's the process so far:

* Visit a Leanpub page that automatically creates the job
* Wait for the email
* Follow the link in the email

That's a pain in the ass, but I go through it to figure out [my sales report](/leanpub-monthly-sales/). It really doesn't take that much time, and I certainly spent more time today thinking about this than I would all year just doing it manually. But, it bugs me that I don't have this down to something that just does it for me.

Part of this might be yak shaving, and some of it is just putting my house in order. Sure, the steps themselves aren't that hard, but I have to remember to do it and it's then a think in my Reminders app that I ignore. I've missed doing this for two months. The cognitive load of knowing I have to do things is an extra hassle.

How should this happen? I'd really like to follow that link in some sort of Google action, process the CSV data it gives me, and populate a shared Google Sheet. I'm thinking something similar to an AWS Lambda would work nicely. I don't even mind that I might have to write JavaScript for that.

I don't expect that to be a feature for every Gmail user, but I'd certainly expect some mechanism for experts. I don't want to write an app that follows the rules for global distribution when I want to use it personally, even if it would be interesting to other Leanpub authors.

I thought about IMAPing all the message, but that was so much code just to get to the messages I wanted. Gmail can apply labels to them, but then I had to do a lot of low-level stuff to filter through that. No thanks.

Then I went old school, and I have fond memories of *procmail*, which filters mail and does almost anything I can imagine. I can match on just about anything and then pipe the result to a program. It's basic Unix ideas: small things doing their job well. And, once I succumbed to the old ways, the job got much easier (and much easier to understand).

* Gmail forwards those messages to a special address I designate
* The address merely saves the raw mail in its own file
* I sync the files locally
* I process the files
* Done

It's as simple as this *Makefile*, which I can run from anywhere (*i.e.* not the machine receiving the mail). The only tricky part is a delay between requesting the report from Leanpub and starting the rest of the job. I have a target that merely sleeps. Also interesting is that I use Safari to request the file. There's a bunch of JavaScript that sets various things to log in, so I can't write a simple Mojo program to do that:

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

I can run a target manually, but I also have it set up in my *crontab*:

{% highlight text %}
13 1 * * * cd /Volumes/Scratch/Leanpub && make
{% endhighlight %}

Most of that can work on the machine receiving the mail. I have a tremendous amount of flexibility here, all of which we give up by using vendor services like Google and AWS. My solution is provider-agnostic, it's simpler, it's easier to change and re-engineer, and it's working. Not only is it working, but it's actually a pretty slim solution without extra stuff I tolerate because someone else decided I needed to go through extra steps.
