---
layout: post
title: Use several Git Services at Once
categories: system-administration
tags: github bitbucket gitlab
stopwords: misflag pushurl url
last_modified:
original_url:
---

There's a practice known as the 3-2-1 Backup Rule: three copies using two copies on different media with at least one off-site. Plan on completely losing one site or one set of hardware.

<!--more-->

I use GitHub everyday, but I've arranged my `git` usage to not rely on them. It's not that I distrust GitHub, but they may go down for reasons they can't control, automatically misflag my account, or some other scenario I can't envision. People were very concerned about this when Microsoft bought GitHub.

My strategy keeps up-to-date copies of all of my repos both locally and on other services. I have a two local servers that keep a copy, and I push to BitBucket and GitLab as well.

* Should I lose the internet for a bit, I'm covered locally and can push to the remotes later.

* If I get locked out of one remote service, I have the exact same tree somewhere else.

* If an asteroid hits the earth, well, clones don't really matter, but I'd use off-planet back-ups if I could.

For Git, I have a remote named "all" that has one URL to pull from but several to push to. Here, for instance, is my *.git/config* for this GitHub Pages blog (minus my local info):

	[core]
		repositoryformatversion = 0
		filemode = true
		bare = false
		logallrefupdates = true
		ignorecase = true
		precomposeunicode = true
	[remote "origin"]
		fetch = +refs/heads/*:refs/remotes/origin/*
		url = git@github.com:briandfoy/briandfoy.github.io.git
	[branch "master"]
		remote = all
		merge = refs/heads/master
	[remote "bitbucket"]
		url = git@bitbucket.org:briandfoy/briandfoy.github.io.git
		fetch = +refs/heads/*:refs/remotes/bitbucket/*
	[remote "gitlab"]
		url = git@gitlab.com:briandfoy/briandfoy.github.io.git
		fetch = +refs/heads/*:refs/remotes/bitbucket/*
	[remote "all"]
		url = git@github.com:briandfoy/briandfoy.github.io.git
		fetch = +refs/heads/*:refs/remotes/all/*
		pushurl = git@github.com:briandfoy/briandfoy.github.io.git
		pushurl = git@bitbucket.org:briandfoy/briandfoy.github.io.git
		pushurl = git@gitlab.com:briandfoy/briandfoy.github.io.git

I have a kludgy Perl program that constructs this config once I make the GitHub repo (and one day, I hope Terraform will be able to handle all of that). But, I usually end up in the command line. The `set-url` line adds that `pushurl`, which I'll need here because I'm going to add more so I multiplex the push:

{% highlight plain %}
$ git init
$ git add .; ... make the git repo stuff
$ git remote add github ...github address...
$ git remote add all ...github address...
$ git remote set-url --push origin ...github address...
$ git push -u all master
{% endhighlight %}

After that, I setup BitBucket and GitLab manually, then add their remotes:

{% highlight plain %}
$ git remote add bitbucket ...bitbucket address...
$ git remote add gitlab ...gitlab address...
$ git remote set-url --push all ...bitbucket address...
$ git remote set-url --push all ...gitlab address...
$ git push
{% endhighlight %}

When I run `git pull`, it fetches from GitHub because the remote for master is `all`. When I push, though, it goes to every push URL. As long as I don't mess with the BitBucket and GitLab clones, that works. I still need to arrange to archive and backup other parts of a GitHub project, such as Issues and Wiki, but there are services for that.

---

**Postscript** I once had a small battle with a company that insisted on a data center within Manhattan. They were starstruck by the glamour of New York City (um, like, okay) and especially the island city-state of Manhattan.

There certainly are data center services in Manhattan (along with many vanity address virtual office services), but my main complaint was that if anything disastrous happened on the island, the bridges and tunnels would be blocked or heavily managed to the point it would be difficult for a data center to get enough diesel fuel to keep their generators running. And, if they had to ration power, our piddly budget wouldn't get their attention.

It would be much easier to host everything it New Jersey, which is not that much of an inconvenience especially considering that we hardly ever went to the data center. Something really rare would have to happen, like a power supply burning out so we couldn't access a machine through a console server.

Across the river would have also been cheaper. They didn't like that, and since it was their company, they won. They really wanted that NYC data center, like potential customers are going to traceroute to be wowed that some router has *.nyc.* in it.

But the next year, 9/11 happened. This isn't the sort of disaster I was thinking about (Hurricane Sandy in 2012 was more likely), but it still shut down the island. Although this company' business wasn't a critical part of anyone's life, both because it was a stupid product and there were almost no customers, the data center stopped working. Not only that, this application relied on cellular links to communicate with the cell phone market—the cell towers were overloaded for at least several days, and Manhattan has historically been a "marginal service" area because of the canyon effect and the sheer number of devices active during business hours.

The only "backups" they had were on the laptops of the NYC developers, who were understandably busy with other things. The business loss was hardly tragic, but it was avoidable.
