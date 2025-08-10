---
layout: post
title: BBEdit 8.0—A Developer's Viewpoint
categories: rescued-content
tags:
stopwords: bbdiff bbedit breakpoint Nandor pulldown SCP WebKit XHTML
last_modified:
original_url: http://www.oreillynet.com/pub/a/mac/2004/12/21/bbedit.html
---

*[This originally appeared in my O'Reilly blog at http://www.oreillynet.com/pub/a/mac/2004/12/21/bbedit.html, which is no longer. It originally had images, but those have been lost to time.]*

A couple of months ago, Bare Bones software released the eighth version of BBEdit, their popular text editor for the Mac. I've used BBEdit since 1994, and I was excited to get my hands on a new version, since Bare Bones always has something new and cool.

This version does not disappoint, even though I am not excited about all of the new features. I've banged on this latest release for a couple of months, talked to other people using it, and can now affirmatively say that if you aren't using version 8, you are missing out. If you aren't using BBEdit at all, well, you just haven't seen how easy things can be.

A lot of other places have already talked about how great BBEdit is, and you can read the BBEdit web site for the full details. I'm going to pick out the things that I like best and least about the new version.

## Document Drawers

I use BBEdit mostly for Perl coding, web development, and just about anything else that uses text. I tend to have a lot of windows open at the same time, which makes quite a mess. Mac OS X's Expose helped with this a lot, but BBEdit took it in a different direction.

Instead of a bunch of separate text windows, I can organize my open documents in a single window and switch back and forth between documents as I need to. No more multiple windows floating around. I can still have them as distinct windows if I like, but I don't need to. I can set how this works in the Documents pane in Preferences.

Honestly, I wasn't convinced at first, and even now I only think it is annoying, but that's just a bit of weird psychology. Familiarity breeds contempt. However, when I try to do it without the single window, I miss it right away. If you are dubious, give it a little while before you decide. I'm hooked now.

Once in a single window, I can switch from one document to another using a pull-down menu under the toolbar, left or right arrow buttons next to that pulldown, the document drawer on the side, or by the command key shortcuts Option-Apple-Left/Right Bracket.

The latest update, BBEdit 8.0.3, clears up the only thing I didn't like about the file drawer: it would accept keyboard focus, although I'm not sure why it would need to. Now I can turn that off in the Preferences. The update also has other interface improvements for this feature, so if you didn't like it before, they probably fixed it.

The drawer had some issues with WindowShade, but updating to the latest versions of WindowShade and BBEdit fixes that.

## Look and Feel

For the most part, BBEdit still looks like BBEdit, with one big change: it now highlights the current line. This takes a little getting used to. It's not a selection highlight, so there is a little learning to undo to get used to it, but now that I have seen it, I wonder how I ever lived without it. A note to potential users: don't set the current line highlight color to the same color as the current selection. It gets a little confusing. Trust me, I know.

The document windows have another interesting feature, although I sometimes have to strain my eyes to see it. In the "Text Status Display" preference, I can set "Show Tab Stops," which puts faint grey lines down the width of the window for each tab stop instead of short ticks at the top of the document. When I'm not thinking about them, I don't see them, but when I need to line up text on far away lines, they come into my focus. If I don't like the light color, I can set the contrast in the "Text Colors" preference pane.

Along with that, the "Show Page Guide" option in the "Text Status Display" turns the background a light grey past that last column.

Most of everything else looks the same. The release notes claim there are a lot of small fixes, but I haven't really noticed them. I think that's more of a comment on how good BBEdit looked before and how much Bare Bones cares about these things. BBEdit has always been the epitome of a Mac application, and that hasn't changed.

## An Even Cooler Command Line

I do quite a bit of work from the Terminal (well, iTerm, really) command line, and the new BBEdit Unix tool is useful in all the ways I wish the previous versions were. Before, I had to give `bbedit` the `-c` switch to create a new document. Now, it figures that out on its own. If I have the preferences set to open new documents in the front window, when the BBEdit tool opens multiple documents, they open in the same window.

The latest update makes it even better. I can now pipe output from a command line process into BBEdit without creating an unsaved document. That way, I don't have to go through the annoying "Do you want to save changes" dialog. Once I've seen it and want to get rid of it, I just close the document.

{% highlight text %}
% netstat -rn | bbedit --clean
{% endhighlight %}

I wish I had this feature for the "Unix Script Output" window I get when I choose "Run" from the "#!" menu (which I've set to Shift-Apple-R with the "Set Menu Keys..." item from the BBEdit menu.

It gets even better, though. If I want to look at piped output, I want to read it from the top. Previously, BBEdit placed the cursor at the end of the output, but I can now start off at the top of the output.

{% highlight text %}
% netstat -rn | bbedit --clean -view-top
{% endhighlight %}

To get this updated version of the command line tool, you have to go to the Preferences. In the Tools pane, click on the button that says "Install Command Line Tools," which installs the latest versions of BBEdit and bbdiff.

## Text Factories

One of the big new features of BBEdit 8 is Text Factories, but I haven't been able to get excited about it. However, since this is only the first version to include them, they may still become useful.

A text factory isn't really so much a factory as a set of transformations. It doesn't create text, but it can process it. The idea is to take the multiple-step operations that I might apply to a set of files and store them as a factory. When I need to do all those steps, I apply the factory and I'm done.

The interface to create a factory is very Mac-like. It's easy to create the factory from BBEdit commands like "Straighten Quotes" and "Sort Lines." I'd really like options to use the [HTML Tidy](http://tidy.sourceforge.net/) and some of the other tools, but the closest I get to that is "Run unix filter," which is much more convenient from the Terminal for me. I then save the factory.

That's where it ends being useful. Once I save the factory, I have to do a bit of work to actually use it. From the Text menu, I have to go halfway down the long list of items to get to the "Apply Text Factory..." menu item, which then leads me to a standard file dialog that starts in my Documents folder. If I remember where I put my text factory, I still have to navigate to get there.

I would have much preferred a Text Factories pull-down menu somewhere. Give me a special folder to drop these things in, just like I have for Unix Filters. It would be even nicer if that pull-down could be in a contextual menu.

The Text Factory file itself is just a property list file, so it's rather dumb. My first thought was that I should be able to drag files onto the Text Factory and have it operate on all the files. That doesn't work, though.

So, for this version, Text Factories is not only misnamed but also a pain to use. For the simple things that Text Factories actually does, I'll just stick to Perl scripts and the command line.

## New HTML Tools

BBEdit now supports HTML Tidy directly, so I can clean up and reformat my HTML with a simple menu item under the Markup menu. I can convert to XHTML or XML too. These would be good candidates for inclusion in the future command lists for Text Factories.

## HTML Preview

BBEdit now can preview HTML and other web files directly in BBEdit using Apple's WebKit. The preview window updates dynamically as I type, so I can see the changes almost in real time, although there seems to be a little bit of lag between my typing and the preview updates. I can't watch myself type, but once I stop typing for a couple of seconds, the window updates.

I can preview just about anything that Safari can preview. Just for giggles, I loaded a JPEG image into BBEdit. Although it looks funny and I can't really edit it (but I imagine someone out there could), the image previews as an image, even though I see it as text. Very cool.

I also tried this with the output of Perl scripts I ran from BBEdit and whose output shows up in the "Unix Script Output" window. Once I got some output, I previewed the document and left the preview window open. I cleared the output so "Unix Script Output" was empty and ran the script again. The preview window automatically updated when new output showed up in the "Unix Script Output" document.

If I don't like previewing my documents in BBEdit, I can still preview them in my favorite browser, or even all running browsers.

## Affrus Integration

[Affrus](http://www.latenightsw.com/affrus/index.html) is a cool, new Perl debugger from Late Night Software that I occasionally find handy. In the "Unix Scripting" pane, check the box for ["Use Affrus for Perl Debugging".](https://web.archive.org/web/20070807161755/http://www.macdeveloperjournal.com/issue2/index.html)

When I have something in the top window that BBEdit thinks is a Perl script, the "Run in Debugger" item in the "#!" menu (that's the Unix scripting menu) launches Affrus. I've assigned the key command Shift-Apple-A to it so I remember A for Affrus.

Affrus starts up and waits at the first statement. The debugger is running the script when it opens the new window, but I get the first virtual breakpoint for free, so I can set up what I want to do before I continue. I need to keep editing in the BBEdit window, since any changes in the Affrus window don't fold back into the code.

The integration goes the other way too. Affrus has an "Edit in BBEdit" option. I'm not a big fan of the Affrus editor mostly because I'm a big fan of BBEdit. These two could be more tightly integrated, but these are not bad first steps, especially since they come from two different companies.

## Things That Are Still Missing

With every version of BBEdit, I still hope that some features from my wish list will show up. But alas, these features might be useful only to a small group of us.

BBEdit can open files over FTP or SFTP, but it still doesn't have support for SCP. I'd like to open files from my various shell accounts, none of which offer SFTP. I've wanted an "Open from URL..." option too. Somewhere in my muddled memory, I think that this used to exist. Maybe it was a different editor, but bringing the text of a web page directly into BBEdit would help me a lot. Chris Nandor provided a script to do this (and isn't that all I really need: a script to do it?).

{% highlight text %}
-- by Chris Nandor
set theURL to display dialog "Enter URL:" default answer "http://"
set quotedURL to quoted form of (text returned of theURL)
set theCmd to "curl --stderr /dev/null  " & quotedURL & "
     | bbedit --clean --view-top" -- do proper escaping someday
do shell script theCmd
{% endhighlight %}

BBEdit already supports a couple of source control systems. This version adds support for Perforce, a popular commercial system, and BBEdit already has support for CVS. I'd like to see Subversion support in a future release. I know I can't have everything, and that Subversion is fairly new compared to Perforce and CVS, so I can be patient.

## Miscellaneous Oddities

The BBEdit application installs by moving the application for the distribution disk image to wherever I want to put it. It's a single "file," and the support files show up in "~/Library/Application Support/BBEdit", so I can't run two versions of BBEdit without them stepping on each other. That should be of little consequence to anyone other than a reviewer who wants to switch back and forth to look at the differences. You may want to save a copy of that directory just in case.

The BBEdit spell checker is gone. It still has spell checking, but it uses the Mac OS X built-in spell checker. I gave myself a while to get used to this, but I still think it's a couple of steps backward. The BBEdit spell checker was a lot nicer, in my opinion, and I miss it. Maybe they'll bring it back if the Mac OS X one doesn't improve.

## Final Thoughts

There is really much more to the new BBEdit than I was able to cover in this article, and even though I pointed out some small problems, I still really like the new version. The new multi-document window and the better BBEdit Unix tool are worth the price of the package.

If you are using an earlier version of BBEdit, upgrade now. If you haven't started using BBEdit, now's your chance. If you are still unconvinced, you can try BBEdit free for thirty days with their fully functional demo version.

