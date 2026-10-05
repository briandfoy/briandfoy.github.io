---
layout: post
status: _posts
title: GitHub things
categories: programming cheatsheet
tags: github github-actions
stopwords:
last_modified:
original_url:
---

Various weird GitHub things

<!--more-->

* the repo named user/user (such as [briandfoy/briandfoy](https://github.com/briandfoy/briandfoy)) can contain a _README.md_ that GitHub will use on your profile (such as [https://github.com/briandfoy](https://github.com/briandfoy))


## GitHub Actions

* [My own basic GitHub Actions for perl modules](https://github.com/briandfoy/github_workflows)
* [Getting Started with GitHub Actions](https://itnext.io/getting-started-with-github-actions-fe94167dbc6d)
* [Doing Stupid things with GitHub Actions](https://devopsdirective.com/posts/2020/07/stupid-github-actions/)

## GitHub Info

### Get the email for a co-author

If I have one of their repos, I could look at one of their commits:

{% highlight console %}
$ git log -1 --author=brian --format='%an <%ae>'
brian d foy <briandfoy@pobox.com>
{% endhighlight %}

If the user has set a public email, grab it from the GitHub user data. That field shows up for the authenticated requests:

{% highlight console %}
$ curl -s -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/users/briandfoy | jq -r '.email'
{% endhighlight %}

I don't have my public email set, which is kinda pointless since it's already in my commits, so I'm not really keeping anything private. This next one looks weird because I capture the output of the command as a string and send that to the command, so the "pipe" is flowing to the left, but that puts the GitHub author name at the end:

{% highlight console %}
$  jq -r '.items[0].commit.author.email' \
	<<< $(curl -s "https://api.github.com/search/commits?sort=author-date&order=desc&per_page=1&q=author:briandfoy")
briandfoy@pobox.com
{% endhighlight %}

If there is no `email`, construct their special GitHub no-reply email from their `id` and `login`:

{% highlight console %}
$ jq -r '"\(.id)+\(.login)@users.noreply.github.com"' \
	<<< $(curl -s https://api.github.com/users/briandfoy)
22255+briandfoy@users.noreply.github.com
{% endhighlight %}

Combined with the `.email` lookup to use that if there, and otherwise make the email:

{% highlight console %}
$ jq -r '"\(.name // .login) <\(.email // "\(.id)+\(.login)@users.noreply.github.com")>"' <<< $(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/users/briandfoy)
{% endhighlight %}

Make it the "Co-Authored-By" line:

{% highlight console %}
$ jq -r '"Co-authored-by: \(.name // .login) <\(.email // "\(.id)+\(.login)@users.noreply.github.com")>"' \
	<<< $(curl -s -H "Authorization: Bearer $GITHUB_TOKEN" https://api.github.com/users/briandfoy)
Co-authored-by: brian d foy <22255+briandfoy@users.noreply.github.com>
{% endhighlight %}

Put all those together:

{% highlight text %}
#!/bin/bash
# Usage: github-email USERNAME
# Outputs the guessed email for a GitHub user
#   1. the public email on their profile (set GITHUB_TOKEN)
#   2. the author email on their most recent public commit
#   3. their no-reply address

if [ $# -ne 1 ]; then
    echo "Usage: ${0##*/} USERNAME" >&2
    exit 2
fi

user=$1
api=https://api.github.com
auth=()
[ -n "$GITHUB_TOKEN" ] && auth=(-H "Authorization: Bearer $GITHUB_TOKEN")

user_json=$(curl -s "${auth[@]}" "$api/users/$user")
if ! jq -e '.id' <<<"$user_json" >/dev/null; then
    echo "Could not look up '$user': $(jq -r '.message // "unknown error"' <<<"$user_json")" >&2
    exit 1
fi

name=$(jq -r '.name // .login' <<<"$user_json")

# 1. Public email from the profile
email=$(jq -r '.email // empty' <<<"$user_json")
if [ -n "$email" ]; then
    echo "Method: public profile email" >&2
else
    # 2. Author email from their most recent public commit
    commit_json=$(curl -s "${auth[@]}" "$api/search/commits?q=author:$user&sort=author-date&order=desc&per_page=1")
    email=$(jq -r '.items[0].commit.author.email // empty' <<<"$commit_json")
    if [ -n "$email" ]; then
        repo=$(jq -r '.items[0].repository.full_name' <<<"$commit_json")
        url=$(jq -r '.items[0].html_url' <<<"$commit_json")
        echo "Method: last commit in $repo" >&2
        echo "Commit: $url" >&2
    else
        # 3. No-reply address
        email=$(jq -r '"\(.id)+\(.login)@users.noreply.github.com"' <<<"$user_json")
        echo "Method: no-reply address" >&2
    fi
fi

echo "Co-authored-by: $name <$email>"
{% endhighlight %}


