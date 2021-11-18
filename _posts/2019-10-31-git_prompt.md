---
layout: post
title: My bash prompt is now two lines
categories: programming command-line
tags: git bash prompt
stopwords: png
---

Every ten years or so I change up my shell prompt. This year I added a newline so that the ever increasing information I display doesn't crowd out the actual command I'm using (especially since I added [git_prompt.sh](https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh)):

{% highlight text %}
# PS1="\h_\u[\!]\$ "

# http://code-worrier.com/blog/git-branch-in-bash-prompt/

Blue='\[\e[01;34m\]'
White='\[\e[01;37m\]'
Red='\[\e[01;31m\]'
Green='\[\e[01;32m\]'
Reset='\[\e[00m\]'
FancyX='\342\234\227'
Checkmark='\342\234\223'


export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
# only do this for interactive sessions
case "$-" in *i*)
    source ~/.git_prompt.sh
    PS1="$Red\u$Blue@$Red\h$Green \W$Reset \$(__git_ps1 ' (%s)')$Blue[\!]\n\$ $Reset"
esac
{% endhighlight %}

And here's what it looks like in [iTerm2](https://iterm2.com):

![Prompt on its own line](/images/git_prompt.png)

This has another benefit I hadn't anticipated. I often cut-and-paste text for my terminal. Until now, I had to then cut out the prompts because it's irrelevant to the reader and takes up space. Now, all that irrelevant stuff is on a line by itself.
