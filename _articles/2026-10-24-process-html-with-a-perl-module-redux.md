---
layout: post
title: Process HTML with a Perl Module, Redux
categories: programming
tags: perl mojolicious html
stopwords: attr href img McAdams
last_modified:
original_url:
status: _posts
---

Sixteen years ago, a long time ago, in a Perl far, far away, I wrote an article for Inform IT to promote [Effective Perl Programming](https://www.effectiveperlprogramming.com). In [Process HTML with a Perl Module](https://web.archive.org/web/20151011045345/http://www.informit.com/articles/article.aspx?p=1581075), I used [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) to change around some HTML. Today I'd do something completely different and much simpler.

<!--more-->

In that article, I started with this HTML, which is itself dated with *search.cpan.org* went away a long time ago, although [MetaCPAN](https://metacpan.org) still serves its links:

{% highlight html %}
<html>
<head>
<title>This is the title</title>
</head>
<body>
<h1>This is the heading</h1>

<a href="http://search.cpan.org">Search CPAN</a>
<a href="http://perldoc.perl.org">Perldoc</a>
<div>
<a href="http://testers.cpan.org">Testers</a>
<img src="http://www.example.com/images/logo.gif">
</div>

</body>
</html>
{% endhighlight %}

The first task was to extract the title and top heading of the HTML. [Mojo::DOM's](https://metacpan.org/pod/Mojo::DOM) has a nice interface to whatever data structure it builds so I don't have to know about the low-level details:

{% highlight perl %}
use v5.10;

use Mojo::DOM;
use Mojo::File;

my $dom = Mojo::DOM->new( Mojo::File->new($ARGV[0])->slurp('UTF-8') );

say "Title: " . eval { $dom->at('title')->all_text } // '<no title>';
say "H1: "    . eval { $dom->at('h1')->all_text    } // '<no h1>';
{% endhighlight %}


{% highlight plain %}
Title: This is the title
H1: This is the heading
{% endhighlight %}

The second task extracted all the links. Previously, I searched every tag and queried its type. I can use `find` instead (and may have been able to back then too). Mojolicious uses a [Collection](https://metacpan.org/pod/Mojolicious::Collection) that has objects to access and manipulate each found item, with convenience functions such as `attr` to extract parts:

{% highlight perl %}
say "Links:\n\t" . $dom->find('a')->map( attr => 'href' )->join("\n\t");
{% endhighlight %}

I didn't have to make my own loops to handle this because the `map` method does that for me:

{% highlight plain %}
Links:
	http://search.cpan.org
	http://perldoc.perl.org
	http://testers.cpan.org
{% endhighlight %}

I probably could have used a Perl `map` in the old article, but when the internals get too complicated, I tend to use a `foreach`. I think I used to do that because I found people didn't like `map` that much, and I care much less about accommodating that now.

The next part was to expand that example to also pull out `src` values from the `img` tags:

{% highlight perl %}
say "Links:\n\t" . $dom->find('a, img')
	->map( sub { $_->attr( $_->tag eq 'a' ? 'href' : 'src' ) } )
	->join("\n\t");
{% endhighlight %}

{% highlight plain %}
Links:
	http://search.cpan.org
	http://perldoc.perl.org
	http://testers.cpan.org
	http://www.example.com/images/logo.gif
{% endhighlight %}

I can make that extendable by using a hash to map the tag name to the attribute I want:

{% highlight perl %}
my %Attrs = qw(
	a    href
	img  src
	);

say "Links:\n\t" . $dom->find('a, img')
	->map( sub { $_->attr( $Attrs{$_->tag} ) } )
	->join("\n\t");
{% endhighlight %}

Finally, I added a `class` attribute to each `a` and `img` tag. With two arguments, `attr` sets the value in the DOM:

{% highlight perl %}
my %Classes = qw(
	a    link
	img  picture
	);

$dom->find('a, img')
	->map( sub { $_->attr( class => $Classes{$_->tag} ) } )
	->join("\n\t");

say $dom;
{% endhighlight %}

When I output the DOM, I see the new classes in those elements. In the old example, [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) reflowed everything, smooshing the tags together. This output preserved the whitespace, although I don't think [Mojo::DOM](https://metacpan.org/pod/Mojo::DOM) guarantees that:

{% highlight plain %}
<html>
<head>
<title>This is the title</title>
</head>
<body>
<h1>This is the heading</h1>

<a class="link" href="http://search.cpan.org">Search CPAN</a>
<a class="link" href="http://perldoc.perl.org">Perldoc</a>
<div>
<a class="link" href="http://testers.cpan.org">Testers</a>
<img class="picture" src="http://www.example.com/images/logo.gif">
</div>

</body>
</html>
{% endhighlight %}


There are times that I don't want to use [Mojo::DOM](https://metacpan.org/pod/Mojo::DOM) though: it tries to fix broken markup, and sometimes the way it does that makes later tasks a bit harder.
