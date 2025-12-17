---
layout: post
title: Compiling Perl v5.8 on Debian Slim
categories: perl
tags: debian slim
stopwords:
last_modified:
original_url:
---

I need a container for Perl v5.8, and I want it to be as small as I can make it. Starting with [debian:bookworm-slim](https://hub.docker.com/layers/library/debian/bookworm-slim/images/sha256-993f5593466f84c9200e3e877ab5902dfc0e4a792f291c25c365dbe89833411f), I'd download the v5.8 source, modify it with [patchperl](https://metacpan.org/pod/Devel::PatchPerl), then compile it. But, there were problems.

<!--more-->

First, some modules don't compile. Notably, [HTML::TagSet](https://metacpan.org/pod/HTML::TagSet) changed its minimal version to v5.10, although [LWP](), which aims for v5.8.1, depends on it. Then [Test::Fatal](https://metacpan.org/pod/Test::Fatal) updated its minimum version to v5.12, although [URI](https://metacpan.org/pod/URI), which [LWP](https://metacpan.org/pod/LWP) also needs. Neither of these changes were necessary.

Fixing the modules was easy enough by installing old versions before I start anything else:

{{highlight plain}}
cpanm PETDANCE/HTML-TagSet-3.20.tar.gz RJBS/Test-Fatal-0.017.tar.gz
{{endhighlight}}

The [parent](https://metacpan.org/pod/parent) module had some trouble which I didn't bother to figure out. v5.8 didn't like something in the tests, so I installed it without running the tests:

{{highlight plain}}
cpanm --notest parent
{{endhighlight}}

Then I got weird errors trying to install [IO::Socket::SSL](https://metacpan/pod/IO::Socket::SSL). This one was really weird. The docker build died with a suspicious error:

{{highlight plain}}
#9 42.94 DIED. FAILED tests 1-15
#9 42.94    Failed 15/15 tests, 0.00% okay
#9 42.94 t/alpn............................FAILED tests 1-5
#9 43.00    Failed 5/5 tests, 0.00% okay
#9 43.00 t/auto_verify_hostname............$!=No such file or directory, $@=IO::Socket::SSL: Bad protocol 'tcp', S$SSL_ERROR=IO::Socket::INET configuration failed at t/auto_verify_hostname.t line 34.
{{endhighlight}}

This one was a bit tricky, and the change between v5.8 and v5.10 does not show up in the *perldelta*. After trying lots of different things, I search for `Bad protocol 'tcp'`. That's a result of the slim version of a base image that does not distribute */etc/protocols*. That file defines the numeric constants for the internet protocols including TCP and UDP. If that file is not there, `getprotobynam` can't resolve the names to their constants.

This wasn't a problem in v5.10 because [Socket](https://metacpan.org/pod/Socket) defined those constants itself and didn't need `getprotobynam`. I solved this by creating the file myself:

{{highlight plain}}
printf "tcp 6 TCP\nudp 17 UDP\n" >> /etc/protocols
{{endhighlight}}

I could also get these by installing the data package that has the files:

{{highlight plain}}
apt-get install netbase
{{endhighlight}}
