---
layout: post
title: macOS's System Integrity Protection sanitizes your environment
categories: mac
tags:
stopwords: El Capitan LIRARY DLYD culting
last_modified:
original_url:
---

macOS added [System Integrity Protection](https://support.apple.com/en-us/HT204899) in El Capitan. It's supposed to limit what root users can do and prevent changes to system files. Noble goals, especially for non-developers.

But its more than. Some programs sanitize the environment before they start child processes so I can't substitute my own, potentially malicious libraries. I'm being generous when I say that this is lightly documented. Specifically, environment variables starting with `DYLD_` and `LD_` are unset for child process started by system programs. This works in the Apple ecosystem, but some third-party tools still rely on it.

That macOS would do this makes sense for most people. These environment variables were supposed to be about debugging so you could compile a library and try it with a program. As with many things, how people used it was different. As a developer, I'm doing things virtually no one else in the world is doing. I don't want to use these variables, but other things I want to use wants to use these variables.

## Debugging hell

Imagine trying to debug something like this in a bizarro world in which I swear I've set the variable, I've stared at it for minutes to ensure I've spelled it correctly instead of `DLYD_LIRARY_PATH`, and I can see it in small test programs. I swear it's set up, but when I go back to the big situation, it's gone.

I discovered this because I was testing some Postgres stuff and setting different values on the command line:

    $ env PGSSLMODE=require ...

My Perl program then couldn't find */Library/PostgreSQL/12/lib/libssl.1.1.dylib* and I'd get an error that says it can't find the library:

	Library not loaded: libssl.1.1.dylib

Googling did not help that much. Most answers were just cargo-culting advice about Homebrew that is essentially "have you tried reinstalling it?"

<iframe width="560" height="315" src="https://www.youtube.com/embed/t2F1rFmyQmY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

As an aside, I don't mind that people use convenience tools such as `brew`. However, you should understand what it does and how it does it if you want to be a developer. You can see the trail of destruction and wasted time from people who've neglected to learn their tools—they can't even diagnose the problem.

## DYLD_LIBRARY_PATH

I can set the `DYLD_LIBRARY_PATH` environment variable to tell processes where it can find dynamic libraries, and I can see that I've set it:

	$ export DYLD_LIBRARY_PATH=/Library/PostgreSQL/12/lib
	$ echo $DYLD_LIBRARY_PATH
	/Library/PostgreSQL/12/lib

With a `perl` that I've compiled and installed myself (not the macOS system Perl), I can see the value from a Perl program, but from the system `perl` I can't:

	$ which perl
	/Users/brian/bin/perl
	$ perl -le 'print $ENV{DYLD_LIBRARY_PATH}'
	/Library/PostgreSQL/12/lib
	$ /usr/bin/perl -le 'print $ENV{DYLD_LIBRARY_PATH}'

	$

But, if I run the same Perl one-liner under `env`, I can't see it:

	$ env which perl
	/Users/brian/bin/perl
	$ env perl -le 'print $ENV{DYLD_LIBRARY_PATH}'

	$

This isn't a Perl thing. Here's the same thing in Ruby, which I installed myself:

	$ which ruby
	/usr/local/bin/ruby
	$ ruby -e 'puts ENV["DYLD_LIBRARY_PATH"]'
	/Library/PostgreSQL/12/lib
	$ env ruby -e 'puts ENV["DYLD_LIBRARY_PATH"]'

	$

Even worse, just running `env` means I won't see all of the environment variables. The variable is set and I can see it with `echo`, but `env` doesn't even know it exists:

	$ env | grep DYLD
	$

And here's a small *Makefile* to show the value of `DYLD_LIBRARY_PATH`:

	all:
		@ echo "DYLD_LIBRARY_PATH=" $(DYLD_LIBRARY_PATH)

It also sanitizes the environment when I use the XTools `make` (and I'd rather not muddy the waters with a different set of tools):

	$ which make
	/usr/bin/make
	$ echo $DYLD_LIBRARY_PATH
	/Library/PostgreSQL/12/lib
	$ make
	DYLD_LIBRARY_PATH=

## What can I do?

As the nuclear option, I can turn off SIP. I have to boot into Recovery Mode and disable SIP from the terminal, then reboot into normal mode:

	$ csrutil disable

I don't really want to do that though. I'd rather leave my base system as close to pristine as I can. The more I diverge from the normal case, the less I develop for the normal case. Something works accidentally for me because I have a special. more omniscient system.

I can change my _Makefile_ to set a default (assign with `?=`) with a safe environment variable name and re-export it. Without the `export`, the `echo` sees the *Makefile* variable, but `perl` would not see an environment variable:

	export DYLD_LIBRARY_PATH ?= $(MY_DYLD_LIBRARY_PATH)

	all:
		echo "DYLD_LIBRARY_PATH=" $(DYLD_LIBRARY_PATH)
		perl -le 'print $$ENV{DYLD_LIBRARY_PATH}'

This requires me to set the extra environment variable, which is easy enough in a startup file. The hard part is adjusting foreign code to use this. This is where I think most developers would stop because it's achievable and we're used to working around obstacles when we can't get through them.

However, I didn't give up. There must be a better way. If I'm not supposed to use `DYLD_LIBRARY_PATH`, how does Apple expect me to do it?

After I compiled [DBD::Pg](https://metacpan.org/pod/DBD::Pg), I looked at the *.bundle* file it created. `otool` can show you which libraries it wants:

	$ otool -L ./blib/arch/auto/DBD/Pg/Pg.bundle
	./blib/arch/auto/DBD/Pg/Pg.bundle:
		libssl.1.1.dylib (compatibility version 1.1.0, current version 1.1.0)
		libcrypto.1.1.dylib (compatibility version 1.1.0, current version 1.1.0)
		libpq.5.dylib (compatibility version 5.0.0, current version 5.12.0)
		/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1281.100.1)

Three of those paths are relative, which is why it needs something like `DYLD_LIBRARY_PATH` to find them. The other one is an absolute paths. Huh. If I update those to absolute paths, I don't need to search through directories for them. The `install_name_change` tool (virtually completely undocumented) does this.

There are two ways to go here based on where this library is. If I can't tell the root directory for the library, I can use the `RPATH` infrastructure. However, in this case, I know that the directory is going to be */Library/PostgreSQL/12/lib*, so I can use absolute paths for these libraries.

The `install_name_change` lets me update the library paths for either `RPATH` or absolute paths ([Fun with rpath, otool, and install_name_tool](https://medium.com/@donblas/fun-with-rpath-otool-and-install-name-tool-e3e41ae86172) is a nice read):

	$ install_name_tool -change libssl.1.1.dylib /Library/PostgreSQL/12/lib/libssl.1.1.dylib ./blib/arch/auto/DBD/Pg/Pg.bundle
	$ install_name_tool -change libcrypto.1.1.dylib /Library/PostgreSQL/12/lib/libcrypto.1.1.dylib ./blib/arch/auto/DBD/Pg/Pg.bundle
	$ install_name_tool -change libpq.5.dylib /Library/PostgreSQL/12/lib/libpq.5.dylib ./blib/arch/auto/DBD/Pg/Pg.bundle

I check with `otool` again to make sure it took:

	$ otool -L ./blib/arch/auto/DBD/Pg/Pg.bundle
	./blib/arch/auto/DBD/Pg/Pg.bundle:
		/Library/PostgreSQL/12/lib/libssl.1.1.dylib (compatibility version 1.1.0, current version 1.1.0)
		/Library/PostgreSQL/12/lib/libcrypto.1.1.dylib (compatibility version 1.1.0, current version 1.1.0)
		/Library/PostgreSQL/12/lib/libpq.5.dylib (compatibility version 5.0.0, current version 5.12.0)
		/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1281.100.1)

And that works. I've filed [an issue on DBD::Pg](https://github.com/bucardo/dbdpg/issues/69), but I haven't worked on fixing the module installer.

## A list of ignored variables:

SIP strips out any environment variables starting with `DYLD_` or `LD_`, but here are the ones for the search engines:

* `DYLD_LIBRARY_PATH`
* `DYLD_FALLBACK_LIBRARY_PATH`
* `LD_LIBRARY_PATH`
* `DYLD_INSERT_LIBRARIES`
