---
layout: post
title: Git cheatsheet
categories: cheatsheet
tags: git
stopwords: gitignore
last_modified:
original_url:
---

Various things I need to remember for Git, but that I don't remember. I know I can read the help to get this, but I still have to wade through a bunch of verbiage.

<!--more-->

Undo the last commit (`--soft` keeps changes):

	git reset --soft HEAD~1
	git reset --hard HEAD~1

Delete remote branches ([Stackoverflow](https://stackoverflow.com/q/2003505/2766176)):

	git push REMOTENAME --delete <branch-name>

	git remote prune origin

Show filenames in log messages ([Stackoverflow](https://stackoverflow.com/a/1230094/2766176))

	git log --name-only

Show all merged branches

	git branch --merged master

See which _.gitignore_ rules exclude a file ([Stackoverflow](https://stackoverflow.com/a/467053/2766176))

	git check-ignore -v **/*

Find the commit that deleted a file ([git docs](https://git-scm.com/docs/git-check-ignore)) ([Stackoverflow](https://stackoverflow.com/a/1113140/2766176))

	git rev-list -n 1 HEAD -- <file_path>


## Interesting links

* [Why Git blame sucks for understanding WTF code (and what to use instead)](https://tekin.co.uk/2020/11/patterns-for-searching-git-revision-histories)
* [Git stash doesn’t have to be scary - Jemma Issroff](https://jemma.dev/blog/git-stash)

