---
layout: post
title: A CPAN distroprefs example
categories: perl programming
tags: cpan
stopwords: Distroprefs circumfix dereferences
last_modified:
original_url: https://stackoverflow.com/a/72807390/2766176
---

The `Data::Match` module has some syntax that Perl v5.22 tightened up. That's why it fails. Note that force installing a module with an egregious problem like that means it will just fail when you run your program.

<!--more-->

If you can, don't use this module. I have no idea what it does, so I don't have any suggestions for a replacement.

Let's suppose you need this module for whatever reason, even though it's 20 years old. Perhaps you're supporting a legacy app that you just need to get working.

There's this line ([L968](https://metacpan.org/dist/Data-Match/source/Match.pm#L968)) which dereferences an array element that is itself an array reference:

	$str .= $sep . '{' . join(',', @$ind->[0]) . '}';

That should be the circumfix notation to delimit the reference part:

	$str .= $sep . '{' . join(',', @{$ind->[0]}) . '}';

If you make that change to *Match.pm* before you run `perl Makefile.PL`, the tests pass (but with a warning) and you can install the module.

If that's all you need, you can stop here.

## Distroprefs

CPAN.pm has a way to handle these situations so you don't have to make the change every time you want to install the module. Before CPAN.pm does its work, it can patch the problem distribution, suggest a replacement distro, or many other things. You do this with "distroprefs". There are many examples in the [CPAN.pm repo](https://github.com/andk/cpanpm/tree/master/distroprefs).

There are a few things to set up. First, choose your distroprefs directory (`o conf init prefs_dir`). Second, configure a directory to hold your patches (`o conf patches_dir`). I choose *patches* under my *.cpan* directory, but it can be anything. Save your changes before you exit.

```
% cpan
% cpan[1]> o conf init prefs_dir
Directory where to store default options/environment/dialogs for
building modules that need some customization? [/Users/brian/.cpan/prefs]
% cpan[2]> o conf patches_dir /Users/brian/.cpan/patches
% cpan[3]> o conf commit
```

distroprefs has two parts. The first specifies what you want to happen. This can be a YAML, Storable, or Data::Dumper file. If YAML (which most people seem to use), then you need to install the `YAML` module first.

Here's a simple distroprefs file. It tells CPAN.pm how to match a distribution as you'd see it on CPAN (AUTHOR/FILE). In this example, its action is `patches`, which is an array of patch files. Since you set up `patches_dir`, that's where it will look. The file name for the patch isn't special, and it can be compressed. I chose the distro name, my name as the person who patched it, then *.patch*.

```yaml
---
match:
  module: "Data::Match"
  distribution: "^KSTEPHENS/Data-Match-0.06.tar.gz"
patches:
    - Data-Match-0.06-BDFOY-01.patch
```

Here's your patch. Back up the original file, change the target file, then get the unified diff (or whatever your `patch` understands):

```diff
$ diff -u Match.pm.orig Match.pm
--- Match.pm.orig	2022-06-29 15:04:06.000000000 -0400
+++ Match.pm	2022-06-29 14:55:45.000000000 -0400
@@ -965,7 +965,7 @@
     elsif ( $ref eq 'HASH' ) {
       if ( ref($ind) eq 'ARRAY' ) {
 	# Not supported by DRef.
-	$str .= $sep . '{' . join(',', @$ind->[0]) . '}';
+	$str .= $sep . '{' . join(',', @{$ind->[0]}) . '}';
       } else {
 	$str .= $sep . $ind;
       }
```

But you want this in your patches dir with the name that you specified, so redirect the output there:

```
$ diff -u Match.pm.orig Match.pm > /Users/brian/.cpan/patches/Data-Match-0.06-BDFOY-01.patch
```

If you want to get really fancy, you could put that patches directory in an environment variable in your profile so you don't have to remember it:

```
$ diff -u Match.pm.orig Match.pm > $CPAN_PATCHES_DIR/Data-Match-0.06-BDFOY-01.patch
```

Now when you try to install `Data::Match` with `cpan`, it knows that it's installing `Data-Match-0.06`, it matches that distro from a distroprefs file, and that distroprefs file tell CPAN.pm to perform an action. In this case, it needs to find the patch file and apply it. After the patch is applied, the tests pass and the installation succeeds:

```
% cpan Data::Match
Reading '/Users/brian/.cpan/Metadata'
  Database was generated on Wed, 29 Jun 2022 05:56:00 GMT
Running install for module 'Data::Match'

______________________ D i s t r o P r e f s ______________________
                  Data-Match-0.06-BDFOY-01.yml[0]
Checksum for /Users/brian/.cpan/sources/authors/id/K/KS/KSTEPHENS/Data-Match-0.06.tar.gz ok
Applying 1 patch:
  /Users/brian/.cpan/patches/Data-Match-0.06-BDFOY-01.patch
  /usr/bin/patch -N --fuzz=3 -p0
patching file Match.pm
Configuring K/KS/KSTEPHENS/Data-Match-0.06.tar.gz with Makefile.PL
Checking if your kit is complete...
Looks good
Generating a Unix-style Makefile
Writing Makefile for Data::Match
Writing MYMETA.yml and MYMETA.json
  KSTEPHENS/Data-Match-0.06.tar.gz
  /usr/local/perls/perl-5.36.0/bin/perl Makefile.PL -- OK
Running make for K/KS/KSTEPHENS/Data-Match-0.06.tar.gz
cp Match.pm blib/lib/Data/Match.pm
cp lib/Sort/Topological.pm blib/lib/Sort/Topological.pm
Manifying 2 pod documents
  KSTEPHENS/Data-Match-0.06.tar.gz
  /usr/bin/make -- OK
Running make test for KSTEPHENS/Data-Match-0.06.tar.gz
PERL_DL_NONLAZY=1 "/usr/local/perls/perl-5.36.0/bin/perl" "-Iblib/lib" "-Iblib/arch" test.pl
1..1
# Running under perl version 5.036000 for darwin
# Current time local: Wed Jun 29 15:54:13 2022
# Current time GMT:   Wed Jun 29 19:54:13 2022
# Using Test.pm version 1.31
ok 1
PERL_DL_NONLAZY=1 "/usr/local/perls/perl-5.36.0/bin/perl" "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness(0, 'blib/lib', 'blib/arch')" t/*.t
t/t1.t .. ok
t/t2.t .. ok
t/t3.t .. 1/15 splice() offset past end of array at /Users/brian/.cpan/build/Data-Match-0.06-15/blib/lib/Data/Match.pm line 1941.
t/t3.t .. ok
t/t4.t .. ok
All tests successful.
Files=4, Tests=182,  0 wallclock secs ( 0.03 usr  0.01 sys +  0.18 cusr  0.04 csys =  0.26 CPU)
Result: PASS
```
