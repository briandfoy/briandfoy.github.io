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
			<span class="date">{{ post.date | date: "%B %e, %Y" }}</span> - <span class="categories">
				{% assign categories = post.categories | sort %}
				{% for category in categories %}
				<a href="/category/{{ category }}">{{ category }}&nbsp;</a>
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
