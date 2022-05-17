---
layout: post
title: Adjusting XCode command-line tools for Monterey
categories: mac
tags:
stopwords: Xcode dev
last_modified:
original_url:
---

I upgraded my laptop to macOS Monterey, then some command-line dev things broke with errors, including these:

{% highlight plain %}
clang: error: invalid version number in '-mmacosx-version-min=12.3'

cc: error: unable to read SDK settings for '/Library/Developer/CommandLineTools/SDKs/MacOSX10.12.sdk'
{% endhighlight %}

It was a simple matter of updating Xcode (why didn't Monterey do that?):

{% highlight plain %}
% sudo rm -rf /Library/Developer/CommandLineTools
% sudo xcode-select --install
% sudo xcode-select --switch /Library/Developer/CommandLineTools
{% endhighlight %}

I might not have needed to do all of that, but it was easy enough to start fresh. The last bit updated the default path for Monterey, which apparently is different than before.
