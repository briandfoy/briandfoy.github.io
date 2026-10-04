---
layout: page
title: Tags
permalink: /tags/
---

{% assign tags = site.tags | sort %}

<p>
{% for tag in tags %}
  <a href="#{{ tag[0] | slugify }}">{{ tag[0] }}</a> ({{ tag[1].size }})
{% endfor %}
</p>

{% for tag in tags %}
<h2 id="{{ tag[0] | slugify }}">{{ tag[0] }}</h2>
<ul>
  {% for post in tag[1] %}
  <li><a href="{{ post.url | relative_url }}">{{ post.title }}</a> – {{ post.date | date: "%B %e, %Y" }}</li>
  {% endfor %}
</ul>
{% endfor %}
