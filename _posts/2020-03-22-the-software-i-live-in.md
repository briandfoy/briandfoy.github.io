---
layout: post
title: The software I live in
categories:
tags:
stopwords: APIs BBEdit's Metrowerks SDKs chipset iTerm zsh
last_modified:
original_url:
---

My rule in managing programmers is that I don't care what you use as long as it doesn't affect what other people use. Your operating system, editor, or whatever don't matter to me *a priori*. Sometimes it's good to force people to use a particular setup that matches their audience, but otherwise, be productive however you are productive, even if you use the "wrong" software.

I also tell people to try different things so they know different things. I'm a *vi* guy because that's the best editor, but I also forced myself to use *emacs* for two years to really get into it. I didn't like it (but my business partner around that time, Randal Schwartz, lives in it).

## macOS

I'm a Mac guy, although I also have a [Ubuntu laptop](/ubuntu-on-macbook-air/) that sits on my desk too. I used to do a lot more FreeBSD, but after a couple of decades I got rid of it, and even switched to Linode to use ArchLinux.

But, the Control key as command key gets me. I have to contort my thumb too much, and even though I was almost able to redefine my keyboard, but for only part of the system.

## iTerm

Without [iTerm](https://www.iterm2.com), I might stop programming.
Seriously. It handles Unicode very well, which I really, really need. It integrates nicely with macOS. I donate a couple hundred dollars to this project each year.

I can get things done on the Linux and Windows command lines, but I feel like I'm back on a dumb VT-100. Other people may like other things, and that's fine. I'm still looking for something on Gnome I don't hate.

Although macOS has moved to *zsh*, I'm still a *bash* person. I might look into that when my To Do list goes to zero.

### Some of my favorite features

* beautiful appearance
* command-clicking on filenames and URLs
* [Shell Integration](https://www.iterm2.com/documentation-shell-integration.html)

### Interesting reading

* [iTerm2 + zsh + oh-my-zsh The Most Power Full Terminal on macOS](https://medium.com/ayuth/iterm2-zsh-oh-my-zsh-the-most-power-full-of-terminal-on-macos-bdb2823fb04c)
* [10 Must know terminal commands and tips for productivity (Mac edition)](https://codeburst.io/8-must-know-terminal-commands-and-tips-for-productivity-mac-edition-95935dba3ebc)

## BBEdit

BBEdit's motto had been "It sucks less". That's true. All editors suck. Lately they've upgraded to "It doesn't suck".

I've been using BBEdit forever—before version 1 even I think, and I was using Metrowerks on Mac Classic before then. The Motorola chipset was really good for what I was doing back then. I've paid for this editor for a couple of decades and I'm happy those people have jobs. I even got the [25th Anniversary t-shirt](https://merch.barebones.com/products/bbedit-vintage-white-t-shirt), which looks very close the original t-shirt I wore out 20 years ago.

One of the curious arguments for open source is that all bugs are shallow and the crowd can do better. It's Eric Raymond's odd "Cathedral versus the Bazaar" idea. When I've reported bugs to BBEdit, someone usually sends me a new build to test within 12 hours. In the Open Source world, these are the sorts of bugs that would probably result in long threads about "why are you doing that?" and "you are doing it wrong" before nobody steps up to fix it then some issue manager closes the thread without reading it. First, I think Bare Bones is just an awesome company, and second, they care about my report because they get money from me every release. I doubt I'm in any VIP level for customer service, but I don't know if this is everyone's experience.

Sure, I'm a pointy-clicky guy, but as I've observed people who live in *vi*, I notice a lot of flailing. It goes by quickly and most people wouldn't even notice it, but inadvertent commands are common. That's not necessary bad and some people put up with it, but I don't think it's an easier interface.

On Linux, I suffer through with [Sublime Text](https://www.sublimetext.com), which I configure heavily to look and work like BBEdit. But, just like with Atom, I don't want to write code for this stuff. I don't want to download a bunch of different plugins, then debug which plugins are interfering with other plugins.

* [My sublime settings](https://gist.github.com/briandfoy/e7c1c2d21983969d28a7833448bde16a)
* [My sublime colors](https://gist.github.com/briandfoy/8c0d3949b92f257c820f23b17d5be68a)

## Quicksilver

This is a task manager / switcher for macOS. It's ancient but it still works. I hit Control-Space to bring it up, type a couple of characters, and I'm in another application.

And, as I type this, I realize how valuable it is. I did something stupid to make it quit and haven't restarted it (I think it's probably left behind something that's preventing it restarting).

## make

I live in *make*. It's how I organize projects and remember how to do everything.

## perl

Duh. I write the books.

I have several versions of Perl installed—at least minor version of each major version back to v5.10.

I don't use Perl for everything, but it's often the easiest thing for me to use if I have to create something. I have little Python and Ruby things too—especially when working with officially supported APIs like the Amazon Web Services SDKs.

