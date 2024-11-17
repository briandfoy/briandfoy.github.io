---
layout: post
title: When backups are the problem
categories:
tags:
stopwords:
last_modified:
original_url:
---

What happens when backing up the database is the reason the database goes down and you can't open additional SSH connections? What follows is not a tale of technical wizardry but a confession of stupidity and neglect.

<!--more-->

If you do this for real, there's nothing for you to learn here. I'm a rando from the internet with a $20 Linode virtual machine that I log into once a quarter. I run Wordpress and MariaDB, and sometimes I do some other things. All of this mostly keeps running despite my neglect.

When I initially set up this machine sometime in 2015, I automated data dumps from MariaDB. Each day, each database dumped their SQL to a directory, and because why not, I gitified that directory and shipped it to GitHub and Bitbucket. All of this is on the same $20 Linode.

Then one week that git directory grew large enough to fill up the modest disk. The repo has collected nine years of daily dumps, and even though most of those dumps are the same from day to day, and even though git is storing diffs, that's still a constantly accreting data dump. And it filled up the disk.

Of course, there are ways to get early warnings of these sorts of problems. Who has two thumbs and still isn't monitoring disk space? Yeah, this guy.

Now here's the precipitating event: Linode does emergency maintenance and the machine reboots. MariaDB does not come back up, which is annoying to WordPress, but I also have this behind Cloudflare so the websites continue to work for awhile after this happens. This stuff almost never changes so I have extremely long cache times; weeks instead of hours.

Then I do the stupid thing. I ssh to the machine then do what I normally do. I look around a bit then I update the system to the latest everything. This was the big mistake.

Since I mostly neglect this machine, it's been awhile since I upgraded anything. Usually upgrading everything is fine. I'm using ArchLinux because why not, and I'm following all of its rules. Well, not really as I'll soon learn.

If there's some problem where it knows it shouldn't update, `pacman` will tell me I need to do something. For example, if I'm running MariaDB and `pacman` sees a major upgrade, there are some things I need to do to safely shut down and prepare for the major upgrade. For example, the MariaDB replay files have changed formats around 10.7, so if I need to check for corruption, I need to use the current version first. You know, corruption that might happen when a database fills up.

But, I'm not *running* MariaDB because it didn't come back up after the emergency reboot. `pacman` upgraded MariaDB even though I have a corrupted database. Now MariaDB can't come back up because it sees the inconsistent state.

Oh, and for some reason I can't open additional SSH connections now. I've lived in the world of physical terminals and no windows, so this isn't so hard, but it is annoying. I could have also logged into the console server, but I didn't want to admit defeat at that level. And, I could always ssh into the console server anyway.

I tried to compile an earlier MariaDB versions to fix this. I tried various earlier versions (but I need 10.7) but the builds failed after 40 minutes or so—not exactly a job for the instant gratification crowd.

At the same time, I'm having problems with SSH. I can't open additional sessions and I don't know why. I see through `ssh -vvv` that the server is saying the cert types are `-1`, which means it's not accepting whatever I'm sending.

I got to the point where I was going to have to do what I didn't want to do: nuke the databases and restart from backups. This is more a moral aversion than a technical one, because it's really easy, and it's really easy for a particular reason in my case.

Since I was shipping the backups to other git hosters, I didn't need it locally. I could free up all that disk space. First, I thought `git gc` might grab me some space. But, I need some space to do that and the problem is that I have no space. That's not so good.

I checked the */var/log* and noticed I also had a couple months of web logs. I never look at those unless there's a problem, and I figure if there's a problem, it will still be a problem and I'll get new log messages, so I delete all those to get about 10% of disk space back. Now, I was actually doing the log rotation thing here, so this wasn't the problem, at least on its own.

But then I do the next stupid thing; I delete the entire git repo. Going back in time, I would checkout the last good commit and then delete *.git*. That's not what I did. I deleted the entire directory. I have the git repo locally, so no big deal right?

Except, remember that I can't open additional SSH connections. I can't `scp` or `rsync`. I could prababy throw these dumps in Dropbox and `curl` a link, but that feels icky. I have the backups but I can't easily get them onto the machine I want.

But I just upgraded everything, right? The SSH config changed with the new version and the bit to allow for public keys is now commented out, which the part to disallow passwords is still active. This is something I typically forget, but also, typically isn't a problem. I didn't expect it in SSH though, although I have notes to check it for apache.

I decided to fix that instead of focus on the database problem and that was quick.


## What would I do differently?

The big problem was the unbounded growth of the git repo for the database dumps. I don't need to have the git repo on that machine. Rather than that, I can rsync that directory to something locally, handle the git details off machine, and still ship to GitHub and Bitbucket.

Also, I could pay a lot more for a much bigger disk so I delayed the time when I'd have to reckon with the consequences of my neglect for decades. But I'm not going to do that either.

The big mistake was upgrading everything in the middle of an incident. Just no. I'm an idiot. You might also like to read [Never Update Again](https://blog.kronis.dev/articles/never-update-anything).
