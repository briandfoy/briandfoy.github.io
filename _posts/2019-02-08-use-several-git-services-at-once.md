---
layout: post
title: Use several git services at once
categories: system-administration
tags: github bitbucket gitlab
stopwords: misflag pushurl url Akamai Atlassian Rackspace Sealandia tornados
last_modified:
original_url:
---

There's a practice known as the 3-2-1 Backup Rule: three copies using two copies on different media with at least one off-site. Plan on completely losing one site or one set of hardware.

<!--more-->

I use GitHub everyday, but I've arranged my `git` usage to not rely on them. It's not that I distrust GitHub, but they may go down for reasons they can't control, automatically misflag my account, or some other scenario I can't envision. People were very concerned about this when Microsoft bought GitHub. Okay, I don't trust GitHub, but I don't trust an external service. Or internal service.

My strategy keeps up-to-date copies of all of my repos both locally and on several other services. I have two local servers that keep a copy, a Linode server that gets a copy, and I push to BitBucket and GitLab as well.

* Should I lose the internet for a bit, I'm covered locally and can push to the remotes later.

* If I get locked out of one remote service, I have the exact same tree somewhere else.

* If an asteroid hits the earth, well, clones don't really matter, but I'd use off-planet back-ups if I could.

I'm not trying to save everything, such as my local-only branches, my stash, and other things. I want `master` to be everywhere, and if I lose a day's work, it's not that big of a deal. This requires some discipline beyond the tech: short feature branches pushed at least every day, merging frequently (within a week), and so on.

Now the trick is to make all of this work so I don't have to think about it.

## Is this really doing what I think?

Even though I'm using different front-line services, am I actually using different data centers and locations? What if everything I push to is actually just AWS us-east-1?

* GitHub is Azure, and maybe [their own data centers in Virginia or Seattle](https://github.blog/2017-10-12-evolution-of-our-data-centers/), and maybe Rackspace? So, at least not entirely AWS.
* [GitLab is mostly Google Cloud Platform us -east](https://about.gitlab.com/handbook/engineering/infrastructure/production/architecture/)
* [Bitbucket is AWS us-east](https://www.atlassian.com/trust/reliability/cloud-architecture-and-operational-practices#data-backups) even though other parts of their marketing say "Atlassian servers".

So there is some service diversity there, but almost all of that is in Virginia and Virginia-adjacent. Knock out the US East Coast with a hurricane and it doesn't matter which service you are using.

I have a server on Linode (Akamai), and that's somewhere in the greater Philadelphia / southern New Jersey area. That's still US East Coast.

I also use Pair Networks, in Pittsburgh, and the server I use is in the US Midwest somewhere. So, tornados.

All of these are still in the same regulatory environment though. If I have trouble in the US, I can lose all of that.

I recently opened an account on [Codeberg](https://codeberg.org), a git service hosted in Germany, but I haven't played around with that too much. The EU is an attractive regulatory regime since the privacy controls are more favorable. I might have to look in hosting on Sealandia.

## Only one matters

In general, I only really care about the repo on GitHub. I don't do much work to make them all agree. Sometimes things happen in the repo such that I can't push (without force) to the others. Not a big deal. I delete the other repo, re-create it, and push to it again. This is rare, but I make these sorts of big messes about once a year.

## Making it work

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

I have a kludgy Perl program that constructs this config once I make the GitHub repo (and one day, I hope Terraform will be able to handle all of that). From a starting GitHub repo, it makes new BitBucket and GitLab repos, sets up the `pushurl` bits, and pushes the repos to them. When I push to `all`, every one of the repos gets the updates. And, as I said before, if one of them gets out of sync for some reason (usually a wacky merge situation), I start over with non-GitHub repo.

## Step by step

The `set-url` line adds that `pushurl`, which I'll need here because I'm going to add more so I multiplex the push:

{% highlight plain %}
$ git init
$ git add .; ... make the git repo stuff
$ git remote add github ...github address...
$ git remote add all ...github address...
$ git remote set-url --add --push all ...github address...
$ git push -u all master
{% endhighlight %}

After that, I setup BitBucket and GitLab manually, then add their remotes:

{% highlight plain %}
$ git remote add bitbucket ...bitbucket address...
$ git remote add gitlab ...gitlab address...
$ git remote set-url --add --push all ...bitbucket address...
$ git remote set-url --add --push all ...gitlab address...
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
