---
layout: default
title: Blog
permalink: /blog/
---

<div class="posts">
  {% for post in site.posts limit:site.front_page_limit %}
    <article class="post">

      <h1><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></h1>

      <div class="entry">
		  <div class="byline">
			<p>
			<span class="date">{{ post.date | date: "%B %e, %Y" }}</span> - <span class="tags">
				{% assign tags = post.tags | sort %}
				{% for tag in tags %}
				<a href="/tag/{{ tag }}">{{ tag }}&nbsp;</a>
				{% endfor %}
			</span>
			</p>
		  </div>
        {{ post.excerpt }}
      </div>

      <br clear="all" />
      <a href="{{ site.baseurl }}{{ post.url }}" class="read-more">Read More</a>
    </article>
  {% endfor %}
</div>
