---
layout: post
title: Use several Git Services at Once
categories: git sysadmin
tags: github bitbucket gitlab
stopwords: misflag
last_modified:
original_url:
---

There's a practice known as the 3-2-1 Backup Rule: three copies using two copies on different media with at least one off-site. Plan on completely losing one site or one set of hardware.

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

I have a kludgy Perl program that constructs this config once I make the GitHub repo (and one day. I hope Terraform will be able to handle all of that).

When I run `git pull`, it fetches from GitHub because the remote for master is "all". When I push, though, it goes to every push URL. As long as I don't mess with the BitBucket and GitLab clones, that works. I still need to arrange to archive and backup other parts of a GitHub project, such as Issues and Wiki, but there are services for that.

---

**Postscript** I once had a small battle with a company that insisted on a data center within Manhattan. There certainly are services for that, but my main complaint was that if anything disastrous happened on the island, the bridges and tunnels would be blocked or heavily managed to the point it would be difficult for a data center to get enough diesel fuel to keep their generators running. It would be much easier to do that it New Jersey, which is not that much of an inconvenience especially considering that we hardly ever went to the data center. Across the river would have also been cheaper. They didn't like that, and since it was their company, they won. But the next year, 9/11 happened. Although their business wasn't a critical part of anyone's life, their data center stopped working. Not only that, their application relied on cellular links to communicate with the cell phone market—the cell towers were overloaded. The only "backups" they had were on the laptops of the NYC developers, who were understandably busy with other things. Their loss was hardly tragic, but it was avoidable.
