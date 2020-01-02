---
layout: post
title: Get this blog
tags: github-pages jekyll
---

It's a new decade tomorrow for you 0-based types, so I figured I'd try a new blog setup. I've used all sorts of things, but the GitHub Jekyl stuff seems easy to setup. This is whatever I did to get what you see here.

## Fork jekyll-now

Fork [jekyll-now](https://github.com/barryclark/jekyll-now) and follow its very simple instructions. You'll have everything going in 5 minutes (if you know a little *git*).

I had to edit the *_config.yml* file to make GitHub recognize everything, but that was easy.

## Add tags capability

I hacked in tags support by following these instructions:

* https://longqian.me/2017/02/09/github-jekyll-tag/

## Syntax highlighting

GitHub Pages and Jekyll only use Rouge for syntax highlighing now,
so I didn't use the fenceposting markup (triple backtick, or ```` ``` ````).

* http://sangsoonam.github.io/2019/01/20/syntax-highlighting-in-jekyll.html

* [list of supported languages](https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers
)

## Finding errors

GitHub will note that there's a problem building your site. Look in *Settings > Options* and scrol down to the GitHub Pages part.

## Forcing a rebuild

https://stackoverflow.com/questions/24098792/how-to-force-github-pages-build
