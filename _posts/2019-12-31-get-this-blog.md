---
layout: post
title: Get this blog
tags: github-pages jekyll
stopwords: github rws yml
---

It's a new decade tomorrow for you 0-based types, so I figured I'd try a new blog setup. I've used all sorts of things, but the GitHub Jekyll stuff seems easy to setup. This is whatever I did to get what you see here. Mostly, I have this to remind myself what I did if I do this again.

I suppose you could also fork my repository. Most of the interesting stuff is in the _Makefile_.

## Fork jekyll-now

Fork [jekyll-now](https://github.com/barryclark/jekyll-now) and follow its very simple instructions. You'll have everything going in 5 minutes (if you know a little *git*).

I had to edit the *_config.yml* file to make GitHub recognize everything, but that was easy.

## Add tags capability

I hacked in tags support by following these instructions:

* [Jekyll tags](https://longqian.me/2017/02/09/github-jekyll-tag/)

## Syntax highlighting

GitHub Pages and Jekyll only use Rouge for syntax highlighting now,
so I didn't use the fenceposting markup (triple backtick, or ```` ``` ````).

* [Syntax Highlighting in Jekyll](http://sangsoonam.github.io/2019/01/20/syntax-highlighting-in-jekyll.html)
* [list of supported languages](https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers
)

## Finding build errors

GitHub will note that there's a problem building your site. Look in *Settings > Options* and scroll down to the GitHub Pages part.

That's too much work though, so I added a target in my _Makefile_. It uses the GitHub API to get the latest build info and extract the error message. There's also a simpler status target to simply output the status.

## Forcing a rebuild

Pushing to GitHub builds the site, but there might be an error. The information on the GitHub Settings page isn't that useful, but you can get more information from the API, so there's a target for that.

## Spellchecking

I use *aspell*. There's a personal word list in _.aspell.rws_ (and apparently that _.rws_ extension is important). Before I pass off the text to *aspell*, I strip out the code blocks.
