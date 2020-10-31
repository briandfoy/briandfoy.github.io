---
layout: post
title: Git cheatsheet
categories: programming
tags: git cheatsheet
stopwords:
last_modified:
original_url:
---

Various things I need to remember for Git, but that I don't remember. I know I can read the help to get this, but I still have to wade through a bunch of verbiage.

Delete remote branches ([Stackoverflow](https://stackoverflow.com/q/2003505/2766176)):

	git push all --delete <branch-name>

	git remote prune origin

Show filenames in log messages ([Stackoverflow](https://stackoverflow.com/a/1230094/2766176))

	git log --name-only

Show all merged branches

	git branch --merged master

See which _.gitignore_ rules exclude a file ([Stackoverflow](https://stackoverflow.com/a/467053/2766176))

	git check-ignore **/*

Find the commit that deleted a file ([Stackoverflow](https://stackoverflow.com/a/1113140/2766176))

	git rev-list -n 1 HEAD -- <file_path>
