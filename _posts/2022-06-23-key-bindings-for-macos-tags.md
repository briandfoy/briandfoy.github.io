---
layout: post
title: Key bindings for macOS tags
categories:
tags:
stopwords:
last_modified:
original_url:
---

<style>
span.label {
    border-radius: 10%;
    display: inline-block;
    text-align: center;
    color: white;
    font-weight: bold;
    padding-left: 5px;
    padding-right: 5px;
}

span.red    { background: red;    }
span.yellow { background: yellow; color: black; }
span.orange { background: orange; }
span.green  { background: green;  }
span.blue   { background: blue;   }
span.purple { background: purple; }
span.grey   { background: gray;   }
</style>

I use Finder labels, also know as "tags", to organize the files in directories. Suppose that I have a bunch of data files to inspect. I'll mark the really interesting ones as <span class="label red">Red</span>, the ones I've seen as <span class="label orange">Orange</span>, and the ones I can ignore as <span class="label yellow">Yellow</span>.

But, the interface for this is annoying. Select a file, right-click, select a color, and repeat. There has to be a better way.

<!--more-->

I had been looking for an excuse to try [Hammerspoon](https://www.hammerspoon.org), a Lua-based macOS interface controller. I can bind keys to actions and I can tag files. The thing it apparently can't do easily is access the list of files selected in a Finder window. If I've missed how to do that, let me know by pointing at some docs.

You may ask about Applescript at this point. That's possible, probably, activating it is just slow enough that it's painful. Hammerspoon did its work quickly with no perceptible lag.

Then I had the idea to use Automator, which I haven't really enjoyed using in the past. I created a Quick Action to label an item. That looks deceptively simple:

![](/images/macos-tags/automator-label-red.png)

I then bound that Quick Action to a key combo in *System Preferences > Keyboard > Shortcuts > App Shortcuts*. I chose Control-digit because it uses one modifier key:

![](/images/macos-tags/shortcuts-pane.png)

Now here's the problem: I don't have an action to add a new tag. I have an action to unset all existing tags and set a new one. And, Automator doesn't provide a sufficient interface to get the set of existing tags for an individual file, add one to that list, then set all of those.



I can label an item with exactly the label the service specifies, unsetting all the other labels. This is the problem I've run into Automator in general. Notice that Automater calls these "Labels"—that's old school. Mavericks turned labels into tags, making it possible to not only define your own tags but to add more than one tag to a file. It's quite annoying because these tags show up as little dots instead of highlighting the entire line.





But, you'll also notice that I've bound the keys to Path Finder.


While testing, I somehow ended up in a Finder window. I tried my new shortcuts in Finder, and it worked like I thought it would. Then I tried another shortcut to change the tag, and that worked. But, this time, it didn't unset the tag that I had just set.

Wait, what? I thought I had set these shortcuts in Path Finder. Why are they showing up in Finder? Well, they were already there. Not only that, but they toggle a single tag without affecting others.


I went through a lot of work to discover that Finder already does what I want. It's [hidden in an Apple Support doc](https://support.apple.com/guide/mac-help/tag-files-and-folders-mchlp15236/mac) and not shown in the contextual menu.

* <kbd class="kbc-button">Ctrl</kbd> <kbd class="kbc-button">1</kbd> - <span class="label red">Red</span>
* <kbd class="kbc-button">Ctrl</kbd> <kbd class="kbc-button">2</kbd> - <span class="label orange">Orange</span>
* <kbd class="kbc-button">Ctrl</kbd> <kbd class="kbc-button">3</kbd> - <span class="label yellow">Yellow</span>
* <kbd class="kbc-button">Ctrl</kbd> <kbd class="kbc-button">4</kbd> - <span class="label green">Green</span>
* <kbd class="kbc-button">Ctrl</kbd> <kbd class="kbc-button">5</kbd> - <span class="label blue">Blue</span>
* <kbd class="kbc-button">Ctrl</kbd> <kbd class="kbc-button">6</kbd> - <span class="label purple">Purple</span>
* <kbd class="kbc-button">Ctrl</kbd> <kbd class="kbc-button">7</kbd> - <span class="label grey">Grey</span>
* <kbd class="kbc-button">Ctrl</kbd> <kbd class="kbc-button">0</kbd> - Clear all

So damn, I get what I want, in the way I reinvented it
