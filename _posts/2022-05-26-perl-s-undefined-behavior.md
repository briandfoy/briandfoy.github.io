---
layout: post
title: Perl's undefined behaviors
categories: programming perl
tags:
stopwords:
last_modified:
original_url:
---

A list of documented undefined behaviors in Perl. There's one that
matters to you, and others that are rare cases.

<!--more-->

The `each` function iterates through a hash (or an array). If you mess
with the underlying hash, including adding or deleting a hash key,
Perl may rearrange the data structure. When that rearrangement
happens, `each` may be in the same "place", but the rearranged hash
may allow it to return the same key and value again as well as
skipping keys and values it hasn't seen. There's one exception: if you
delete the most recently returned key, it all works out.

If you give `truncate` a length that is larger than the file size, who
knows what will happen? Maybe it truncates some other nearby file or
starts a Tetris easter egg.

`sort` in scalar context doesn't know what to do, but why would you
want to do that anyway? One idea is to make it a no-op so it
does nothing, which seems reasonable. But people have other ideas too.
[GitHub ](https://github.com/perl/perl5/issues/12803), [Perl5 Porters](https://www.nntp.perl.org/group/perl.perl5.porters/2022/04/msg263458.html)

# Old undefined behaviors

Prior to v5.30, you could have a postfix conditional on the lexical definition
of a variable: `my $foo = 0 if 0`. This had the unintended effect of making
a persistent lexical variable, which Perl did not have prior to v5.10 with `state`.
[Perl v5.30 removed this misfeature.](https://www.effectiveperlprogramming.com/2019/07/no-more-false-postfix-lexical-declarations-in-v5-30/)


# Further reading

* [Undefined behavior in Perl and other languages](https://blog.plover.com/prog/perl/undefined.html)
