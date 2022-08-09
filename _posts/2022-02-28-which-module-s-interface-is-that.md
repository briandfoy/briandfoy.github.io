---
layout: post
title: Which module's interface is that?
categories:
tags:
stopwords: AnyDBM distro https pre prereq lifecycle
last_modified:
original_url:
---

*[I wrote this](https://www.reddit.com/r/perl/comments/t3ias4/i_dont_want_no_wantarray/) in response to [I don't want no 'wantarray'](https://www.snellman.net/blog/archive/2017-07-18-wantarray/), where the author conflates a Perl oddity with a missing part of his software lifecycle*

<!--more-->

*bug filed: https://github.com/makamaka/JSON/issues/54 with no response*

Although he might not like `wantarray`, that's not really why he had a problem, and not using `wantarray` doesn't solve this. The tool had an implicit dependency on `JSON::XS` and apparently didn't test any other scenario.

There are two things I see wrong:

First, if you are using a function like `read_file` that respects context, it's your job to ensure that it gets the one you want. Calling a function in an argument list is one area where the experienced Perl programmer knows that things can go wrong. It's easy to get sloppy though. That's most of his post.

The bigger problem is using a module that might choose between two or more implementations. If you want to distribute software, you need to test all the possibilities. I have plenty of scars from that, and it's one of the most unpalatable parts of open source. These small edge cases that I don't care about myself take a long time to figure out.

And that's a pain in the butt. I've recently had to work on a project using `AnyDBM`. It's easy to test that on your system with your setup, but move to another system and it all changes. And, you can't necessarily re-use files generated on a different system! Some implementations make one file per database while others make two. There are other differences. That's a whole other post and part of pre-Perl 5 history.

I think this is complicated by the issue that `JSON` used to install `JSON::XS`. You could be sloppy and simply declare `JSON` as a prereq and get what you want, until you couldn't anymore. These sorts of things tend to happen without effective notice and at the whim of the developer. Since CPAN tends to install the latest versions of everything, these unexpected upgrades tend to bite you.

There was a painful period where I moved my modules from specifying the main module in a distro as a prerequisite to explicitly noting the actual module I had used. At the same time, I was adding the names of core modules I used. Perl has shed some modules from core, such as CGI, so I couldn't depend on them being there. Other modules broke out modules, so `LWP` wasn't enough when it split off `LWP::Protocol::https`. But, the pain is worth it.

This situation is a bit different. The tool implicitly depended on `JSON::XS` by virtue of never trying it without `JSON::XS`. That's the true bug here. They wanted to be as accommodating as possible by allowing `JSON` to select a pure Perl version, but apparently they never verified that worked. Had they done that, they'd probably have to go through the same train of thought in the original post and maybe had the same complaint. But, the solution isn't to remove a Perl wart: it's to test what you actually say on the tin.

Testing these things used to be a pain in the ass because you had your system set up the way you liked and changing it to be some other setup, like a missing module, was a lot of work. For a long time, though, we've had continuous development. We can set up fresh systems each time and configure it any way we like. It's still a lot of work, but its reproducible. Since these systems aren't your personal machine, they tend to quickly expose your assumptions.


## Links

* [I don't want no 'wantarray'](https://www.snellman.net/blog/archive/2017-07-18-wantarray/)
* [Reddit: I don't want no 'wantarray](https://www.reddit.com/r/perl/comments/t3ias4/i_dont_want_no_wantarray/)
* [JSON/Changes for makamaka/JSON](https://github.com/makamaka/JSON/blob/master/Changes)
* [JSON::XS and JSON::PP pass along different contexts](https://github.com/makamaka/JSON/issues/54)


