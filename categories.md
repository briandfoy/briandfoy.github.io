---
layout: page
title: Categories
permalink: /categories/
---

{% assign categories = site.categories | sort %}

<p>
{% for category in categories %}
  <a href="#{{ category[0] | slugify }}">{{ category[0] }}</a> ({{ category[1].size }})
{% endfor %}
</p>

{% for category in categories %}
<h2 id="{{ category[0] | slugify }}">{{ category[0] }}</h2>
<ul>
  {% for post in category[1] %}
  <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a> – {{ post.date | date: "%B %e, %Y" }}</li>
  {% endfor %}
</ul>
{% endfor %}
