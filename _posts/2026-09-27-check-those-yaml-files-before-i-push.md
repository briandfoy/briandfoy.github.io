---
layout: post
status: _posts
title: Check those YAML files before I push
categories: programming
tags: yaml
stopwords:
last_modified:
original_url:
---

In working on [cpan-security-advisory]() I often have a problem being behind master because I have GitHub Actions that update files on a schedule so I can release every Sunday. That's annoying.

My next big problem is hand-editing a YAML file that turns out to be invalid, screwing up everything.  I have tests for those, of course, but do I always run them? Of course I don't.

So, I broke down and created a `pre-push` hook, but I also needed some extra features. That is, I iterated with Claude, which is much better than I at bash syntax.

First, I only run this hook when I try to push to GitHub. I also push to at least [three other services for redundancy](https://briandfoy.github.io/use-several-git-services-at-once/), and I don't need to run the tests every item. And, even if I do want to do that, I have a bit to store a semaphore under *.git* that uses the current rev.

Then I run the tests I want, in this case a bunch of Perl files managed by `prove`. If the tests pass, meaning all the file formats check out, exit with 0, and if they have problems, exit with something that is not zero.

<!--more-->

{% highlight text %}
#!/bin/sh
# .git/hooks/pre-push

remote_url="$2"

# only test when pushing to GitHub
case "$remote_url" in
    *github.com[:/]*) ;;
    *) exit 0 ;;
esac

stamp="$(git rev-parse --git-dir)/pre-push-tested"
head=$(git rev-parse HEAD)

# only trust the cache when the working tree is clean and matches HEAD
clean() { [ -z "$(git status --porcelain)" ]; }

if clean && [ -f "$stamp" ] && [ "$(cat "$stamp")" = "$head" ]; then
    echo "Tests already passed for $head; skipping."
    exit 0
fi

echo "Checking author tests before push..."
if prove -lr xt; then
    clean && echo "$head" > "$stamp"
    exit 0
else
    echo "Tests failed; push aborted. (can push with --no-verify)"
    exit 1
fi
{% endhighlight %}
