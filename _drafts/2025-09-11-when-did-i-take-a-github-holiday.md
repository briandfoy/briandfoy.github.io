---
layout: post
title: When did I take a GitHub holiday?
categories: programming
tags: github
stopwords:
last_modified:
original_url: https://www.reddit.com/user/briandfoy/comments/1nenq6b/getting_the_dates_that_i_have_not_contributed_to/
---

I'm a bit overly-concerned with the contribution graph in my my GitHub profile, and I'm curious why there are days I don't have a commit. ChatGPT 5 comes along for the ride.

<!--more-->

Sometimes one of my automations goes screwy and misses some of the days it should have done something, and I'll see grey boxes on those dates. Typically that might mean there was a network outage or something similar.

I'd been thinking that I should use the GitHub REST API to get me this data, but they don't have anything that does this. So, I asked ChatGPT 5 what it thought. It spit out something close to this:

{% highlight plain %}
#!/bin/sh

USER=${GITHUB_USER}
FROM=$(date -u +"%Y-01-01T00:00:00Z")
TO=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

gh api graphql -f query='
query($login:String!,$from:DateTime!,$to:DateTime!){
  user(login:$login){
	contributionsCollection(from:$from,to:$to){
	  contributionCalendar{
		weeks{
		  contributionDays{ date contributionCount }
		}
	  }
	}
  }
}' -F login="$USER" -F from="$FROM" -F to="$TO" \
| jq -r '.data.user.contributionsCollection.contributionCalendar.weeks[]
		 .contributionDays[] | select(.contributionCount==0) | .date'
{% endhighlight %}

I adjusted a few things, but this got pretty darned close. The output is a series of YYYY-MM-DD dates:

{% highlight plain %}
2025-09-01
2025-09-03
2025-09-07
{% endhighlight %}

I can feed those dates into something that goes off to investigate or look for error messages on those dates.

It's the sort of thing I'm finding useful about these LLM tools. Yes, I could have figured all of this out but it would have been really annoying.
