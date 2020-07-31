---
layout: post
title: Gitifying BBEdit Backups
categories:  sysadmin
tags: bbedit gist git gitx
stopwords: Gitifying gitx
---

[BBEdit](https://www.barebones.com/products/bbedit/) has a feature to make historical backups of a file, so I
have a *BBEdit Backups* directory in [Dropbox](https://db.tt/TOfJe58D).

![BBEdit Backups](/images/bbedit_backups.png)

Sometimes I mess up in a way where a file disappears or I miss out on a
change that I didn't capture in source control. I can trawl these files
to find what I might have missed.

At last, I've turned this into a Git repo, although it's just a snapshot
so far. It doesn't continuously add files to it. I don't really want
to keep these files around and when I delete the folders or files in
the backup, I don't want them in Git. I'm not trying to keep a history.

Instead, I want to browse a file to easily see diffs along a time
sequence (seen here in [GitX-dev](https://rowanj.github.io/gitx/)):

![BBEdit Backups](/images/bbedit-backups-git.png)

Here's the code, but you can [go to the Gist directly](https://gist.github.com/briandfoy/65cd1648bcdca36436e9b77f7f64603d).

<script src="https://gist.github.com/briandfoy/65cd1648bcdca36436e9b77f7f64603d.js"></script>
