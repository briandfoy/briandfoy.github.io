---
layout: post
title: Downloading all my StackOverflow Answers
categories: programming
tags: stackoverflow
stopwords:
last_modified:
original_url:
status: _posts
---

For some reason, I had this notion that all of my <a href="https://www.stackoverflow.com">StackOverflow</a> activity would disappear, which was heightened by StackOverflow being down when I first tried to figure out how to download the data.

<!--more-->

StackOverflow had, for a long time, provided complete data downloads. You can still get to that by going to your own profile, then Settings, then "Data Dump Access", in a URL that looks like <i>https://stackoverflow.com/users/data-dump-access/2766176</i>, where that trailing set of digits is your User ID.

That's about 65 GB, since they don't bother to split it into smaller files. My browser got to about 11 GB before it crapped out and StackOverflow banned my IP. Oh well.

Then I found a StackOverflow Data Explorer <a href="https://data.stackexchange.com/stackoverflow/query/edit/1963223#resultSets">query to get just the answers for a particular user</A>, which produced a 5MB CSV file. Much better.

{% highlight sql %}
select
    a.Score, a.Body, q.Id, q.Title, q.Body, q.CreationDate, q.Tags
from
    Posts q
  inner join
    Posts a
  on q.Id = a.ParentId and a.postTypeId = 2 and q.postTypeId = 1
where
  a.OwnerUserId = ##UserId##
order by q.CreationDate asc
{% endhighlight %}

There is a <a href="https://api.stackexchange.com/docs">Stack Exchange API</a> that has various endpoints, including <a href="https://api.stackexchange.com/docs/answers-on-users#order=desc&sort=activity&ids=2766176&filter=default&site=stackoverflow&run=true">one to fetch answers</a>, but it return ID values, not the actual content, and is annoying paginated.
