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

* [SSL Certificates For PostgreSQL](https://www.howtoforge.com/postgresql-ssl-certificates)
* [Secure TCP/IP Connections with SSL](https://www.postgresql.org/docs/9.5/ssl-tcp.html)

	$ openssl genrsa -des3 -out server.key 1024
	$ openssl rsa -in server.key -out server.key
	$ chmod 400 server.key
	$ chown postgres.postgres server.key
	$ openssl req -new -key server.key -days 3650 -out server.crt -x509 -subj '/C=US/ST=New York/L=New York/O=The Perl Review/CN=The Perl Review/emailAddress=brian.d.foy@gmail.com'

In _postgresql.conf_:

	ssl on

In _pg_hba.conf_, change `host` to `hostssl`.
