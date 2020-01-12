---
layout: post
title: Converting YAML to JSON
tags: json yaml jq yq aliases cpan
---

I had this old program I called
[ypath](https://metacpan.org/module/App::ypath) where I thought I'd do
XPath sorts of things with YAML. This is an idea from 10 years ago,
long before [jq](https://stedolan.github.io/jq/) showed up. Last week
I had a need for something like that again and started to update my
*ypath*. But, I don't really want to build or support another tool.
It's been a long time, so I looked around:

## yq (Go)

[yq](https://github.com/mikefarah/yq), a Go thing, is really a program
called *yaml2json*. It's binary release for darwin-386 doesn't work on
my MacBook Pro, I don't use *homebrew*, and the other methods seem
quite onerous. It's not as lightweight as it claims.

## shyaml (Python)

There's [shyaml](https://github.com/0k/shyaml), but you can only
redirect input into it:

{% highlight text %}
$ pip --user install shyaml
$ shyaml get-value path.to.value < file.yaml
{% endhighlight %}

That's fine for a pipeline I guess, but it should require it for all
cases. Otherwise it seems to work.

## yq (Python)

PyPl has its own [yq](https://pypi.org/project/yq/) that's easy to
install and use. It works mostly like *jq*:

{% highlight text %}
$ pip install yq
$ yq .path.to.value file.yml
{% endhighlight %}

So far this hasn't given me problems.

## My own alias

I already use [jq](https://stedolan.github.io/jq/) all over the place,
so if I had JSON I'd be all set. I can convert it easily with a one
liner, and I even have an alias:

{% highlight text %}
alias yaml2json='perl -MYAML -MMojo::JSON=encode_json -E "binmode STDOUT, q(:raw); say encode_json( YAML::LoadFile(shift) )"'
{% endhighlight %}

Now I use a pipeline:

{% highlight text %}
$ yaml2json file.yml | jq .some.path
{% endhighlight %}

## Giving up

The world has improved since I started App::ypath, so I've abandoned
it. I keep a GitHub project called
[CPAN-Adoptable-Modules](https://github.com/CPAN-Adoptable-Modules)
where I stash old repositories that I no longer want to manage
(especially since I have tools that go through all my repos to do
various things). I push it over there, make it read only, and delete
everything else related to it.
