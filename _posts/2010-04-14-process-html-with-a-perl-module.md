---
layout: post
title: Process HTML with a Perl Module
categories: programming
tags: rescued-content perl html
stopwords:
last_modified:
original_url: http://www.informit.com/articles/article.aspx?p=1581075
status: _posts
---

[*This originally appeared on Inform IT at [http://www.informit.com/articles/article.aspx?p=1581075](https://web.archive.org/web/20151011045345/http://www.informit.com/articles/article.aspx?p=1581075) but has since disappeared. I've made minor edits. I've revisited this topic with Mojolicious in [Process HTML with a Perl Module, Redux](/process-html-with-a-perl-module-redux/)*]

Joseph Hall, Joshua McAdams, and I have recently updated [Effective Perl Programming](https://www.effectiveperlprogramming.com). When Joseph wrote the first edition in 1997, Perl 5 was still young and the answer to many problems was brute-force programming. Now effective Perl programming involves using the right tools that are already out there. Throughout this article, I'll refer to additional information in our book by pointing out its Item number so you can read more about the techniques I use.

<!--more-->

Joseph wrote the first edition in 1997, Perl 5 was still young and the answer to many problems was brute force programming. Now effective Perl programming involves using the right tools that are already out there. Throughout this article, I'll refer to additional information in our book by pointing out its Item number so you can read more about the techniques I use.

Given a mess of HTML text to process, many Perl programmers will reflexively reach into their regular expression toolbox. Since many people grew up with Perl's string handling features, they tend to use those for every task. But, instead of focusing on their high-level task, they end up spending most of their time struggling with the low-level details of patterns to match the myriad ways that the HTML text might be structured and formatted. [One answer on HTML processing on Stackoverflow](http://stackoverflow.com/questions/1732348/regex-match-open-tags%20-except-xhtml-self-contained-tags/1732454#1732454) popularly expresses the frustration many programmers have for people who insist on using regular expressions to handle HTML.

Programming is certainly fun, but isn't it even more fun to get more done instead of constantly inventing HTML parsing? I suppose that some people might enjoy inventing new HTML parsers for every program, but that's not a very efficient way to work.

The most common answer to most Perl questions dealing with HTML is simply "Are you using a CPAN module?" The [Comprehensive Perl Archive Network](https://metacpan.org/), or just CPAN, is Perl's killer feature. Not only does CPAN have a module for almost anything, but there are also several aggregator services such as CPAN Search that bring together many of the community projects, including [CPAN Testers](https://cpantesters.org) and [CPAN RT](https://rt.cpan.org) issue tracker. You can find out just about anything you want to know about the [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) by looking at its CPAN Search page. Many of our updated Items in [Effective Perl Programming](https://www.effectiveperlprogramming.com) provide advice on the right modules to use (Item 71), as well as which ones you might want to avoid (Item 68). Sometimes it isn't clear which module you should use, so we give you some advice on evaluating modules too (Item 67).

Since many other people have to process HTML text too, there are already many solutions on CPAN. Most of them handle all the niggling details you probably weren't thinking about while you were digging around in your regex toolbox. There are several modules that can process HTML text in different ways, but for this example you'll use [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) to extract the title and the `<title>` text. This article is very similar to "Process XML data with XML::Twig" that I've posted at the [Effective Perler blog](https://www.effectiveperlprogramming.com) that supports our book.

Throughout this article, you'll work with this HTML text from a file named *test.html**:

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


The first part of your process to parse this file, no matter the higher-level goal, is simple. You create a new [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) object then tell it what to parse:

{% highlight perl %}
#!perl
use strict;
use warnings;

use HTML::TreeBuilder;

my $html  = HTML::TreeBuilder->new;
my $root  = $html->parse_file( 'test.html' );
{% endhighlight %}

`$root` stores the object that points to the top of the tree structure that represents the text that you parsed. You can now interact with the tree to find parts within it and work with those parts individually. To get the title of the HTML page, you need to find the `<head>` tag then find the `<title>` tag within that. The `find()` method traverses the tree looking for the right spot then returns an [HTML::Element](https://metacpan.org/pod/HTML::Element) object that represents just that part of the tree. In this case, you stored that subtree in $head. To find the `<title>`, you use `find()` with just the `$head` subtree:

{% highlight perl %}
# Do it one step at a time
my $head  = $root->find( 'head' );
my $title = $head->find( 'title' );
{% endhighlight %}

Once you find the element that you want, you can extract the content from it. The `content_array_ref` returns an array reference of items that represent everything under that part of the tree. Under a `<title>` tag, you don't expect anything other than the title (and if that's not true, someone's in trouble!), so you grab the first item in the list, which is at index 0:

{% highlight perl %}
my $title_text = $title->content_array_ref->[0];
{% endhighlight %}

If you are concerned about HTML documents that don't have a `TITLE` tag, you can wrap that in an `eval` block:

{% highlight perl %}
if( my $title_text = eval{ $title->content_array_ref->[0] } ) {
	print "Title is [$title_text]\n";
	}
{% endhighlight %}

To get the `<title>` content, you went step-by-step to extract the `<head>`, look inside the `<head>` subtree, and finally extract the content. You could use method chaining to do it all at once, again in an eval to catch any parsing problems:

{% highlight perl %}
# Do it all together:
if( my $h1 = eval {
	$root->find( 'body' )->find( 'h1' )->content_array_ref->[0] }
	) {
	print "H1 is [$h1]\n";
	}
{% endhighlight %}

Putting that all together, you have your HTML processing script, and you didn't write a single regular expression:

{% highlight perl %}
#!perl
use strict;
use warnings;

use 5.010;

use HTML::TreeBuilder;

my $html  = HTML::TreeBuilder->new;
my $root  = $html->parse_file( 'test.html' );

# Do it one step at a time
my $head  = $root->find( 'head' );
my $title = $head->find( 'title' );
if( my $title_text = eval{ $title->content_array_ref->[0] } ) {
	print "Title is [$title_text]\n";
	}

# Do it all together:
if( my $h1 = eval {
	$root->find( 'body' )->find( 'h1' )->content_array_ref->[0] }
	) {
	print "H1 is [$h1]\n";
	}
{% endhighlight %}

That's all fine and good, but it gets even better. I'm the author of a module named [HTML::SimpleLinkExtor](https://metacpan.org/pod/HTML::SimpleLinkExtor), which is based on [HTML::LinkExtor](https://metacpan.org/pod/HTML::LinkExtor), which is based on [HTML::Parser](https://metacpan.org/pod/HTML::Parser). Although it works, and it was quite useful and novel in its day, [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) makes it almost trivial now. You just have to know what sort of tags you need to extract without worrying about the extraction details. How could you do that with the tree structure that [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) provides?

The trick is to use a queue to keep track of which parts of the tree you haven't processed. You start with the root element, get its content list, and decide what to do. In this case, you'll use Perl 5.10's `foreach-when` (Item 24), which is the Perly version of switch. The foreach portion "topicalizes" the item it's working on by storing it in `$_` (and it has to be `$_`), and the `when()` is Perl's answer to C's `case()`. If the element is not a reference, it's not an [HTML::Element](https://metacpan.org/pod/HTML::Element) object so you just skip it. If it's a reference, it should be an [HTML::Element](https://metacpan.org/pod/HTML::Element) object, so check if it is an `<a>` tag. If it's an `<a>` tag, extract the `<href>` attribute and push it onto `@links`. Otherwise, push the item onto the queue for further processing: whatever it is might have sub-elements that contain `<a>` tags:

{% highlight perl %}
#!perl
use strict;
use warnings;

use 5.010;

my $html  = HTML::TreeBuilder->new;
my $root  = $html->parse_file( 'test.html' );

my @queue = ( $root->elementify );
my @links = ();
while( my $element = shift @queue ) {
	foreach ( $element->content_list ) {
		when( not ref $_ ) { 1; }
		when( $_->tag eq 'a' ) {
			push @links, $_->attr( 'href' );
			}
		default {
			printf "Tag was %s\n", $_->tag;
			push @queue, $_;
			}
		}
	}
{% endhighlight %}

That's so much simpler than what [HTML::SimpleLinkExtor](https://metacpan.org/pod/HTML::SimpleLinkExtor) does. You don't have to add additional branches (see "Eliminate needless loops and branching" in the book's blog); you just have to make that middle branch a bit more flexible. Add a `%tags` hash that lists the tags you are interested in and make their values the attribute name that holds the link. Now you check that the tag exists in the hash, and if so, you extract the right attribute value:

{% highlight perl %}
#!perl
use strict;
use warnings;

use 5.010;

use HTML::TreeBuilder;

my $html  = HTML::TreeBuilder->new;
my $root  = $html->parse_file( 'test.html' );

my @queue = ( $root->elementify );
my @links = ();

my %tags = qw(
	a     href
	img   src
	frame src
	);

while( my $element = shift @queue ) {
	foreach ( $element->content_list ) {
		when( not ref $_ ) { 1; }
		when( exists $tags{ $_->tag } ) {
			my $tag = $_->tag;
			push @links, $_->attr( $tags{$tag} );
			}
		default {
			printf "Tag was %s\n", $_->tag;
			push @queue, $_;
			}
		}
	}

print "Links are @links\n";
{% endhighlight %}

I wish I'd had this module when I created [HTML::SimpleLinkExtor](https://metacpan.org/pod/HTML::SimpleLinkExtor). Life would have been so much simpler.

How about transforming the HTML text, though? So far you've only extracted elements. [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder) also lets you change the tree as you process it. Suppose that you want to add `<class>` attributes to every `<a>` and `<tt>` tag because you want to use a CSS stylesheet.

You need to add a link to the stylesheet, so after you create the HTML tree, you create a separate [HTML::Element](https://metacpan.org/pod/HTML::Element) object in `$css_link` to represent the `<link>` tag that you want to insert. After you create the new element, you find the `<head>` tag as before then use the `insert_element()` method to add the `$css_link` element:

{% highlight perl %}
#!perl
use strict;
use warnings;

use 5.010;

use HTML::TreeBuilder;

my $html  = HTML::TreeBuilder->new;
my $root  = $html->parse_file( 'test.html' );

my $css_link = HTML::Element->new(
	'link',
	'rev'  => 'stylesheet',
	'href' => 'http://www.example.com/test.css',
	'type' => 'text/css',
	);

$root->find( 'head' )->insert_element( $css_link );
{% endhighlight %}

For the next part of the program, you use a variation of the previous example. Instead of collecting a list of links, however, you modify the `<a>` and `<img>` tags that you find. When you call the `attr()` method with more than one argument, it sets the attribute rather than fetch it:

{% highlight perl %}
my @queue = ( $root->elementify );

my %tags = qw(
	a     link
	img   picture
	);

while( my $element = shift @queue ) {
	foreach ( $element->content_list ) {
		when( not ref $_ ) { 1; }
		when( exists $tags{ $_->tag } ) {
			my $tag = $_->tag;
			push @links, $_->attr( class => $tags{$tag} );
			}
		default {
			push @queue, $_;
			}
		}
	}
{% endhighlight %}

When you are finished processing, you output the new HTML text by calling the `as_HTML` method:

{% highlight perl %}
print $root->as_HTML;
{% endhighlight %}

The output shows your added CSS `link`, and class attribute in the `a` tags:

{% highlight html %}
<html>
	<head>
		<title>This is the title</title>

		<link css="text/css" href="http://www.example.com/test.css" rev="stylesheet" />
	</head>
	<body>
		<h1>This is the heading</h1><a class="link" href="http://search.cpan.org">Search CPAN</a> <a class="link" href="http://perldoc.perl.org">Perldoc</a><div><a class="link" href="http://testers.cpan.org">Testers</a> <img class="picture" src="http://www.example.com/images/logo.gif" /></div>

	</body>
</html>
{% endhighlight %}

Wasn't that simple? You didn't have to know anything about what HTML text actually looks like, what its rules are, or any of the myriad low-level details that trip up most people. You focus on the higher-level processing that makes up your task, and with [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder), you end up using a natural, easy-to-follow interface that your maintenance programmers can understand. Now that's effective Perl.
