---
layout: post
title: gh cheatsheet
categories:
tags:
stopwords:
last_modified:
original_url:
---

GitHub's [gh](https://cli.github.com) tool.

Get the repo name:

{% highlight plain %}
gh repo view --json owner,name --jq '(.owner.login + "/" + .name)'
{% end highlight %}

<!--more-->

## Files

The config file is in *~/.config/gh/config.yml*, including the aliases.

## Aliases

([docs](https://cli.github.com/manual/gh_alias))

Make an alias for a *gh* command. Note that an internal `'` is written as `'\''` with single quotes around the escaped single quote:

{% highlight plain %}
gh alias set owner/repo 'repo view --json owner,name --jq '\''(.owner.login + "/" + .name)'\'''
{% end highlight %}

Make an alias with a shell command:

{% highlight plain %}
gh alias set hello --shell 'echo Hello'
{% end highlight %}

See all the aliases:

{% highlight plain %}
gh alias list
{% end highlight %}

Save the aliases to share:

{% highlight plain %}
gh alias list > my_aliases.yml
gh alias import  my_aliases.yml
{% end highlight %}

## See what *gh* sees

Look at the complete JSON to see what's available

{% highlight plain %}
gh COMMAND --json
{% end highlight %}

## Get the repo name:

This is the command, but I aliased this to `owner/repo`:

{% highlight plain %}
gh repo view --json owner,name --jq '(.owner.login + "/" + .name)'
gh owner/repo
{% end highlight %}

## Labels

The `label list --search` seems to be broken, so I made my own label
grepper. I want just plaintext:

{% highlight plain %}
gh alias set label-grep --shell 'gh label list --json name --jq .[].name | grep $1'
gh label-grep bug
{% end highlight %}

See all the labels for an issue:

{% highlight plain %}
gh alias set issue-labels 'issue view $1 --json labels --jq .labels.[].name'
gh issue-labels ISSUE_NUMBER
{% end highlight %}
