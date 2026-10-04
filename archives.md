---
layout: default
title: Archives
permalink: /archives/
---
{% assign posts_by_year = site.posts | group_by_exp: "post", "post.date | date: '%Y'" %}
{% for year in posts_by_year %}
  <h3 class="archive_year" id="archive_year_{{ year.name }}">{{ year.name }}</h3>
  <ul class="year_list" id="year_list_{{ year.name }}">
    {% for post in year.items %}
      <li class="year_item">
        <span class="post-meta">{{ post.date | date: "%d %b" }}</span>
        <a class="archive_item" href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
  </ul>
{% endfor %}
