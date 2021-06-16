---
layout: post
title: US National Park Passport Stickers, by Year and Region
categories:
tags: perl mojolicious national-parks
stopwords: csv
last_modified:
original_url:
---

The US National Park Services has a [passport book](https://shop.americasnationalparks.org/store/category/30/278/Passport-Books/) that allows you to collect stamps at various sites it manages. Each year, it issues a sticker for each region, which can also go in the book. I want to know if a particular site has a sticker I can put in my book and which year it is from.

Their old app would tell you this once you looked at a particular location, but I want to see the whole list at once. This is easy enough to scrape from Wikipedia, even if I have to adjust a few oddities.

[The code is in a gist](https://gist.github.com/briandfoy/3cb38067e4fe8a983abe66e26fb376d2). Here's the output for 2021 ([JSON](/downloads/nps_passport_stamps.json)) ([CSV](/downloads/nps_passport_stamps.csv)).

I don't bother to search any of this. I just use "find" in my editor.

<script src="https://gist.github.com/briandfoy/3cb38067e4fe8a983abe66e26fb376d2.js"></script>
