---
layout: post
title: Importing array values into Postgres from CSV
categories:
tags: postgres
stopwords: csv
last_modified:
original_url:
---

I want to import from a CSV file some array values into a Postgres table, but I didn't find examples. There are many examples with INSERT statements, but I already know how to do that (because there are examples).

Postgres allows a column to hold multiple values (or almost anything, really). In text, you put array values in braces and separate them with commas. There are plenty of examples of this:

{% highlight text %}
postgres=# create table array_test ( pk integer primary key, members varchar array );

postgres=# insert into array_test values ( 1, '{dog,cat,bird}' );
INSERT 0 1

postgres=# select * from array_test;
 pk |    members
----+----------------
  1 | {dog,cat,bird}
(1 row)

postgres=# select members[2] from array_test;
 members
---------
 cat
(1 row)
{% endhighlight %}

No big whoop. Now I have this file in *import_test.csv*:

{% highlight text %}
2,"{lizard,kangaroo}"
{% endhighlight %}

It's as easy as I thought it would be. That column in the CSV uses the same syntax I used in the INSERT:

{% highlight text %}
postgres=# \copy array_test from 'import.csv' delimiter ',' CSV
COPY 1

postgres=# select members[2] from array_test;
 members
----------
 cat
 kangaroo
(2 rows)
{% endhighlight %}

What about elements with commas in them? This works too:

{% highlight text %}
3,"{lizard,""otter, sea"",kangaroo}"
{% endhighlight %}

An empty field was harder. Two commas in a row (`"{rat,,mouse}"`) doesn't work, but quotes around the empty field work:

{% highlight text %}
4,"{rat,"""",mouse}"
{% endhighlight %}

Single quotes work around an array element work too:

{% highlight text %}
5,"{rat,'',mouse}"
{% endhighlight %}

What if I swap those quotes around so the single quotes are on the outside? This is a bit silly because most CSV tools are going to use ", but I figured I'd try:

{% highlight text %}
6,'{rat,"",mouse}'
{% endhighlight %}

The default quote is a " so this won't work:

{% highlight text %}
postgres=# \copy array_test from 'import.csv' delimiter ',' CSV
ERROR:  extra data after last expected column
CONTEXT:  COPY array_test, line 1: "6,'{rat,"",mouse}'"
{% endhighlight %}

I can change the quote but it's a bit odd. At first I thought that I could quote the quote, like `"'"`, but that doesn't work. Nor does `"\'"` nor various things like that. Inside the single ticks, I double up the single tick:

{% highlight text %}
postgres=# \copy array_test from 'import.csv' delimiter ',' quote '''' CSV
COPY 1
{% endhighlight %}

But Postgres also has [dollar quoting](https://www.postgresql.org/docs/current/sql-syntax-lexical.html#SQL-SYNTAX-DOLLAR-QUOTING), where I form the quote delimiter with double `$` on each side, with an optional tag between the `$`:

{% highlight text %}
postgres=# \copy array_test from 'import.csv' delimiter ',' quote $$'$$ CSV
COPY 1

postgres=# \copy array_test from 'import.csv' delimiter ',' quote $foo$'$foo$ CSV
COPY 1
{% endhighlight %}


## Further reading

* [Pg docs: Arrays](https://www.postgresql.org/docs/current/arrays.html)
* [Pg docs: COPY — copy data between a file and a table](https://www.postgresql.org/docs/current/sql-copy.html)
* [COPY (import) data into PostgreSQL array column
](https://stackoverflow.com/a/11170273/2766176)
