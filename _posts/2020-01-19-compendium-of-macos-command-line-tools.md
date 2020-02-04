---
layout: post
title: Compendium of macOS Command-Line Tools
tags: macOS command-line
stopwords:  plist webloc
last_modified:
original_url:
---

There are a variety of macOS commands I can never remember. Sometimes
I forget that they exist and other times I forget how I constructed
their command line. The docs aren't always helpful.

## Property Lists

Turn a plist into JSON. I often do this with *.webloc* files. The
part I forget is to specify standard output (why isn't that the default?):

	$ plutil -convert json -o - foo.webloc

Along with the, I use *jq* to extract the URL:

	$ plutil -convert json -o - foo.webloc | jq -r .URL

## Software Update

Run Software Update from the command line:

	$ softwareupdate -ia --include-config-data
