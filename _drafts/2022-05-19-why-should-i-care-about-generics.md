---
layout: post
title: Why should I care about generics?
categories:
tags: programming
stopwords:
last_modified:
original_url:
---

I don't use generics because I rarely program in an environment that needs them. That is, I'm often in the run-time dynamic language world, so the idea of compile-time type safety is some alien world to me.

<!--more-->

However, I'm curious about the issue and what generics allow. I get the basic idea, but every example I find seems to have much better, non-generic solutions. As background, I really learned object-oriented programming from Smalltalk, so part of me looks down my nose at these other languages. But, mostly, I was taught that the right design often doesn't need advance features.

Consider [Why Generics?](https://go.dev/blog/why-generics) by Ian Lance Taylor for GopherCon 2019. He gives several examples, but it's his first

He wants to reverse an integer and also reverse a string. He has one method for the integer and one for the string. They look almost identical.


