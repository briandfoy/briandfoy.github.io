---
layout: post
title: Rule of Three Cases
categories:
tags:
stopwords:
last_modified:
original_url:
---

I have this rule I like to apply to program architecture. Setup whatever you are doing so that it can handle three different cases. I first heard about this idea with internationalization. Start with three languages instead of two, and make the default one Pig Latin so you can always tell where you've left out a translation.

Choosing between three cases requires more thought than choosing from two, where there's a default and alternate case. You start to realize that you can't do it with an `if-else` and have to come up with something more robust, and, honestly, something more simple.

Consider a program that wants to output the same information if different formats. There's the normal output we might expect to see on the terminal and read with our eyes, but then an alternate format that we might want to pipe to other programs.

Git is an example. It has the default, human-readable output, then various formats designed to pass to programs:

{% highlight text %}
$ git status
On branch master
Your branch is up to date with 'all/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   _drafts/2020-03-16-bash-programming.md

no changes added to commit (use "git add" and/or "git commit -a")

$ git status --short
 M _drafts/2020-03-16-bash-programming.md

$ git status --porcelain=1
 M _drafts/2020-03-16-bash-programming.md

$ git status --porcelain=2
1 .M N... 100644 100644 100644 cfc51ca51d014613a6c84790713f684e55756d83 cfc51ca51d014613a6c84790713f684e55756d83 _drafts/2020-03-16-bash-programming.md
{% endhighlight %}

Suppose that I want to have a program to output plain text of JSON. That's easy. If I don't choose the alternate format, I do the default.

{% highlight perl %}

{% endhighlight %}


