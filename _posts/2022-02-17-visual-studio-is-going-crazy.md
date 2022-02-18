---
layout: post
title: Visual Studio is going crazy
categories: programming
tags: visual-studio mac
stopwords: Gb
last_modified:
original_url:
---

Yesterday I installed Visual Studio Code so I could [play with GitHub Copilot](/ide-driven-development/). For the rest of day my laptop was sluggish, but I didn't connect the two.

Some process calling itself "Code Helper (Renderer)" was eating about 200% of the CPU and 44Gb of memory. The sluggishness was likely from paging so often because I only wish I had that much RAM on this thing.

What's "Code Helper (Renderer)"? Google quickly led to a [Visual Studio bug report](https://github.com/microsoft/vscode/issues/101555) that Microsoft closed in 2020 despite lots of reports still having the problem. There's a [second issue](https://github.com/microsoft/vscode-python/issues/15586) they marked as resolved despite people saying it wasn't, based on a [third issue](https://github.com/microsoft/vscode-python/issues/12037). There are so many reports:

* [Vscode always opens the code helper process on the Mac, which is very hot](https://developpaper.com/question/vscode-always-opens-the-code-helper-process-on-the-mac-which-is-very-hot/)
* [VS Code High Memory Usage and The Fix](https://www.paulhyunchong.com/posts/vscode-high-memory-usage)
* [Runaway Jedi Language task in VSCode](https://stackoverflow.com/questions/66518708/runaway-jedi-language-task-in-vscode)
* [VS Code Installation Creates Runaway Background Processes](https://www.reddit.com/r/macbookpro/comments/i94rn6/vs_code_installation_creates_runaway_background/)
* [Visual Studio Code Consumpt high CPU while typing](https://forum.freecodecamp.org/t/visual-studio-code-consumpt-high-cpu-while-typing/474289)
* [https://developercommunity.visualstudio.com/t/vs-for-mac-is-frozen-cannot-force-quit-not-visible-1/716319](https://developercommunity.visualstudio.com/t/vs-for-mac-is-frozen-cannot-force-quit-not-visible-1/716319)
* [High CPU load by Visual Studio for mac](https://developercommunity.visualstudio.com/t/high-cpu-load-by-visual-studio-for-mac/442804)
* [workspaceContains starts a search over full workspace, including .git/, node_modules/](https://github.com/microsoft/vscode/issues/34711)
* [Code Helper Renderer #98168](https://github.com/microsoft/vscode/issues/98168)
* *I gave up because there are some many more*

What's really curious is that Microsoft likes to ask for more info, but also likes to close the issues after the lowly user can't bring to bear all the resources of a Fortune 100 company to explain something that multiple people experience. But then, if there are only 1,000 reports, that's not a significant part of the user base, so who cares. Just buy more hardware.

This has been going on since at least 2019, and it doesn't seem much different from the old Microsoft reputation of having to reboot multiple times a day just to get work done.

<hr/>

Postscript: I've been told more than a few stories from FAANG friends about the internal developers not being able to reproduce things because they have too many resources, and their resources are too good. It's almost impossible to reproduce problems when you have all the RAM in the world, the latest processors, and fast connections that mere mortals will never experience.
