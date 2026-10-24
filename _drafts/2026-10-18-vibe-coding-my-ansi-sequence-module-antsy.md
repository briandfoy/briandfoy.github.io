---
layout: post
title: Vibe coding my ANSI sequence module, Antsy
categories: programming
tags: claude perl terminal ansi
stopwords:
last_modified:
original_url:
status: _drafts
---

I have my own version of a Perl module to handle ANSI terminal sequences, named <a href="https://metacpan.org/pod/Antsy">Antsy</a>. It does things a bit differently than <a href="https://metacpan.org/pod/Term::ANSIColor">Term::ANSIColor</a>, and does a lot more than just color.

I've wanted to do some fancy things with cursor manipulation. I decided to see what Claude (Opus 5.5) would make of it, and it did a pretty good job of it. This isn't really vibe coding since this is just monkey work for the most part, rather than a vague idea of something I have no idea how to implement on my own. It's all stuff I can do, which makes it a good playground.

<!--more-->

Now, I've used Claude for about a year, doing significant work, but mostly where I have already designed the idea or was working in an existing architecture.

I started with a new directory, set up Claude to use that workspace, initialized the <a href="https://github.com/briandfoy/terminal-test">git repository</a>, then told it to make a <span class="filename">CLAUDE.md</span> file, knowing that we were going to work on a Perl program to play with the terminal.

After a lot of housekeeping, which was mostly my fault since I had initialized the wrong directory and Claude was obeying my very conservative global <span class="filename">CLAUDE.md</span> that keeps it from running wild.

I described the task. All typos and poor grammar are just what's in the transcript.

<blockquote>
Now we work on the target program. We will refine the specification on the program as we go. First, this program will have subtasks. Each subtask will output a "header" line. that will stay on the screen. The task can output more lines, but only the last N lines, where N is some number the subtask decides, stay on the screen and appear to scroll off as new lines are added. At the end of the subtask, the header line can update, for example, to say "Done" or change color based on its status. The next subtask will output its header line and it will appear right under the previous subtask header line.
</blockquote>
