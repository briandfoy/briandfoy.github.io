---
layout: default
title: Assets
permalink: /archives/
---

{% assign years = "2021,2020,2019,2018,2017,2016,2014,2013,2012,2011,2010,2008,2007,2006,2005,2004,2003,2002" | split: "," %}
{% for year in years %}
  <h3 class="archive_year" id="archive_year_{{year}}">{{ year }}</h3>
  <ul class="year_list" id="year_list_{{year}}">
	{% for post in site.posts %}
	  {% assign post_year = post.date | date: "%Y" %}
	  {% if post_year == year %}
		<li class="year_item">
		  <span class="post-meta">{{ post.date | date: "%d %b" }}</span>
		  <a class="archive_item" href="{{ post.url }}">{{ post.title }}</a>
		</li>
	  {% endif %}
	{% endfor %}
  </ul>
{% endfor %}
