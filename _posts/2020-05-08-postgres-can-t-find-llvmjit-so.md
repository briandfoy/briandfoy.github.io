---
layout: post
title: Postgres can't find llvmjit.so
categories: system-administration databases
tags: postgres
stopwords: conf libffi libs llvm cp ffi
last_modified:
original_url:
---

I've been struggling with this issue for a couple of days and didn't find much online to help me suss out the fix.

<!--more-->

I have a Perl program that connects to a remote Postgres server and I get this error:

> DBD::Pg::st execute failed: ERROR:  could not load library "/usr/lib/postgresql/llvmjit.so" libffi.so.6: cannot open shared object file: No such file or directory at /usr/local/perls/perl-5.30.2/lib/site_perl/5.30.2/Minion/Backend/Pg.pm line 311.

My local machine, macOS Catalina, connects to a remote ArchLinux machine running Postgres 12.

I was fortunate to get this error because other things I tried were dumping core before giving me an error message. At least now I had something to investigate.

At first, I figured the problem was on the local side with the way I built DBD::Pg. I tracked it down to the line in Perl where it dumps core, then did very verbose DBI tracing (`DBI_TRACE=9`) to find the spot in the _.c_ file where it blows up. Knowing that was different than being about to fix it.

I flailed around trying to track down libraries on the local side, but then it occurred to me that the error message was from the remote side. That seems so obvious now, but that's split milk under the bridge. I was biased in that direction because I'd already identified [an issue with library paths in the _.bundle_ that DBD::Pg produces](https://github.com/bucardo/dbdpg/issues/69).

But yeah, I turned on Postgres logging on the remote server and there was the error message:

> 2020-05-08 15:17:01.236 EDT [923606] ERROR:  could not load library "/usr/lib/postgresql/llvmjit.so": libffi.so.6: cannot open shared object file: No such file or directory

Looking at the ArchLinux box, I saw that _/usr/lib/postgresql/llvmjit.so_ was there. There are those times that you hope something is missing because it makes the fix so easy. I tried reinstalling `llvm-libs` and `libffi`, but they are both up to date (and I don't customize my ArchLinux box):

{% highlight text %}
$ sudo pacman -S llvm-libs libffi
{% endhighlight %}

Same error. So, _llvmjit.so_ exists, what about _libffi.so.6_? Well, it's not there. It's _libffi.so.7_:

{% highlight text %}
$ ldconfig -p | grep libffi
	libffi.so.7 (libc6,x86-64) => /usr/lib/libffi.so.7
	libffi.so (libc6,x86-64) => /usr/lib/libffi.so
$ ls -l /usr/lib | grep ffi
lrwxrwxrwx  1 root root       15 Apr  9 00:09 libffi.so -> libffi.so.7.1.0
lrwxrwxrwx  1 root root       15 Apr  9 00:09 libffi.so.7 -> libffi.so.7.1.0
-rwxr-xr-x  1 root root    42976 Apr  9 00:09 libffi.so.7.1.0
{% endhighlight %}

Reinstalling the _postgresql_ package didn't help either. This is the sort of nonsense that made me leave FreeBSD to try ArchLinux. It's all just supposed to work. [That's why I'm using it, after all](/switching-from-freebsd-to-linux/). I'm trying my best to let ArchLinux manage itself even though I'm comfortable compiling everything myself.

The Unix StackExchange question [Arch: broken lib-llvm dependency using postgresql on Manjaro](https://unix.stackexchange.com/q/583225/12567) appears to have the same problem, but there is no answer. The Reddit thread [Warning - latest update of ffi stuff broke mostly everything](https://www.reddit.com/r/archlinux/comments/fyutoz/warning_latest_udpate_of_ffi_stuff_broke_mostly/) notes something broke in _libffi_ in April.

The expedient fix it to simply cp _libffi.so.7_ to _libffi.so.6_ (or link or whatever), but future updates might clean it out. I'm reluctant to use that sort of fix on this box.

## Turn off JIT

I still don't know what's up with that, but there was another thing I noticed; I can turn off JIT, either in _postgresql.conf_ or as a setting in the database:

{% highlight text %}
postgres=# alter system set jit=on;
ALTER SYSTEM
{% endhighlight %}

To do that you need to be a superuser, so I added that to my Terraform and reapplied. This is much nicer than doing it through Postgres:

{% highlight text %}
resource "postgresql_role" "su_brian" {
        name     = "su_brian"
        login    = true
        password = var.brian_pass
        create_database = true
	superuser = true
}
{% endhighlight %}


