---
layout: post
title: One-liners for Farhenheit to Celcius
categories:
tags:
stopwords:
last_modified:
original_url:
---

I wanted to make some shell aliases for temperature conversions and I got carried away.

<!--more-->

## Perl

    % perl -e 'printf qq|%.1f\n|, 32 + ((9/5)*shift)' 100
    % perl -e 'printf qq|%.1f\n|, (5/9)*(shift() - 32)' 212

## dc

	% dc -e '10 k 9 5 / ? * 32 + f' <<< 100
	% dc -e '10 k 5 9 / ? 32 - * f' <<< 211.95

I wanted to try bc too, but I couldn't figure out how to make it fill in a parameter.

## ssl (Stupid Stack Language)

Perhaps using my implementation of [Stupid Stack Language](https://github.com/briandfoy/perl-ssl):

	% ssl avavimiilblbavavvdplblbhmlblbgx <<< 100
	% ssl avvdavplblbavqimiilblbhclblbmx <<< 212
