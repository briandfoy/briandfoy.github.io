---
layout: post
title: Third-party libraries undermine your control
categories: perl programming opinion
tags: cpan
stopwords: cpanfile
last_modified:
original_url:
---

Some people say that Perl's greatest strength is the Comprehensive Archive Network (CPAN)—the loosely organized collection of rsync mirrors of a directory structure of tens of thousands of Perl module distributions. However, it's also one of it's greatest pain points. This isn't uniquely a Perl problem, but that's where I have the most experience with the issue.

<!--more-->

One of the most frequently asked Perl questions in StackOverflow is something like "Can't find some module in @INC". Someone wants to run some Perl script they have but they don't know about code, modules, libraries, and all that stuff. They just want to do their job.

Part of that would be solved if people distributed [program as modules](https://www.drdobbs.com/scripts-as-modules/184416165) so we could use all of the module infrastructure to resolve dependencies. There's still the primer problem of people knowing what to do with the first step.

But, even with that, we have the problem of long lists of dependencies. There are the dependencies that we use explicitly in our own code, but then each of those dependencies have their own dependencies, all the way down. Some of these modules don't even matter for the code you want to run.

Perl is especially prone to this problem because it ships with a lean Standard Library. Sometimes people say Perl has just enough modules to install more modules ("Batteries not included"). Python, by contrast, is ["batteries included"](https://www.python.org/dev/peps/pep-0206/), which means it's more likely that you already have what you need. But, that also has the problem of ["dead batteries"](http://radar.oreilly.com/2013/10/dead-batteries-included.html). Once you distribute something, you have to keep distributing it because you allowed people to depend on it. And, the Standard Libraries are [Where modules go to die](http://www.leancrew.com/all-this/2012/04/where-modules-go-to-die/). It takes years to kick modules out of the Perl Standard Library just for that reason.

Perl has a strong testing culture, so there are plenty of modules to test all sorts of things. But, some of those testing modules want to use other modules. Since testing modules tend to want to peek at things they shouldn't (the outer lexical scope, for instance), they depend on really weird modules. And, you don't need any of those modules for the code you want to run. So, you have this long list of modules which have to work, and you don't control any of that.

Every module you depend on has some chance of failing its tests, and the CPAN clients don't tolerate failures. Something fails, and it stops. The CPAN clients can skip the tests altogether, but that shouldn't be the situation! And, in the rare case, code just completely disappears from CPAN. This isn't a Perl problem either. All software with tests has this problem.

This situation can be of no fault from the original author. They wrote it a year ago but there's a new *perl* that changed something. Or, some other module changed. CPAN always installs the latest versions, but there's also the third-party _.cpanfile_, which requires more modules.

There are hundreds of people each providing their own piece to the puzzle, but almost all of whom don't care about the other pieces or the picture the complete puzzle reveals. And, each of those people have different opinions on how you should do things. Those people are likely the underpinnings for all of your revenue. Recall the [Heartbleed bug in OpenSSL](https://heartbleed.com), a bit of software that almost everything uses but nobody pays for. And, it is (was?) a staff of four volunteers.

I had various projects to capture dependencies into a local repository that you could control (see my talk [Making my own CPAN](https://www.slideshare.net/brian_d_foy/mycpan-lapm-september-2007)), but the idea turned out to be too much for most customers and they didn't want to pay for it. Instead, they paid for it in the increased hassle of either not upgrading ever or dealing with the breakage. That's not special to CPAN or Perl though. Most enterprises tend to chose the breakage and firefighting. They understand that and know how to deal with it.

