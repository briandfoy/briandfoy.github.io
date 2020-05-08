---
layout: post
title: Postgres Cheatsheet
categories:
tags:
stopwords:
last_modified:
original_url:
---

Show user who owns a database (if `\l` is insufficient):

	SELECT d.datname as "Name",
	pg_catalog.pg_get_userbyid(d.datdba) as "Owner"
	FROM pg_catalog.pg_database d
	WHERE d.datname = ...database name...
	ORDER BY 1;

