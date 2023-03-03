---
layout: post
title: Simple RSS with Perl
categories: perl programming
tags: rss xml rescued-content the-perl-review
stopwords: rdf url
last_modified:
original_url:
---

*I originally published this as "Simple RSS with Perl" in The Perl Review 0.6*

<!--more-->

## Introduction

The Rich Site Summary (RSS) is a set of stories, usually from the same
web site.  The RSS file contains XML data which other programs can parse to create custom presentations.

There are several major versions of RSS.  The first version, 0.9, is simple to read and simple to use.  It does not contain as much information as later versions which provide various additions to the RSS format—even arbitrary extension through XML namespace magic.  I think that is overkill for my purposes, and I do not want to do the extra work to handle the extra features. I use version 0.9, and I only show that in this article.

*The Perl Review* publishes RSS files for each issue and for collections of related articles. A few other web sites actually use them.  In the other direction, we use several other sites' RSS files on our web site for "Perl at a Glance".

## Creating RSS

Files in RSS 0.9 typically have the extension *.rdf* for Resource Description Framework.  The XML format is very simple.  Code listing [RSS file format](#rss) shows the actual RSS file for the last issue.  Line 1 is the required XML header. Line 3 pulls in the appropriate definitions.  The RSS data  has *channel* and *item* data.  The channel is the name of the feed and typically has a title and a link to the original website.  Line 7 starts my channel element with a title element with the name of the issue, and a link element to the issue file. The rest of the elements are items, sometimes called *headlines*.  Each item has a title and link.

<p class="code_title"><a class="ref_name" name="rss">RSS file format</a></p>

{% highlight html linenos %}
<?xml version="1.0"?>

<rdf:RDF
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns="http://my.netscape.com/rdf/simple/0.9/">

<channel>
<title>The Perl Review, v0 i5, September 2002</title>
<link>http://www.theperlreview.com/Issues/The_Perl_Review_0_5.pdf</link>
</channel>

<item>
<title>Extreme Mowing, by Andy Lester</title>
<link>http://www.theperlreview.com/Articles/v0i5/extreme_mowing.pdf</link>
</item>

<item>
<title>What Perl Programmers Should Know About Java, by Beth Linker</title>
<link>http://www.theperlreview.com/Articles/v0i5/perl-java.pdf</link>
</item>

<item>
<title>Filehandle Ties, by Robby Walker</title>
<link>http://www.theperlreview.com/Articles/v0i5/filehandle_ties.pdf</link>
</item>

<item>
<title>The Iterator Design Pattern, by brian d foy</title>
<link>http://www.theperlreview.com/Articles/v0i5/iterators.pdf</link>
</item>

</rdf:RDF>
{% endhighlight %}

Creating this file is very easy.  I can write it by hand, but I can also create it with a program, which I want to do since all of the data comes from a database and I want to automate the process.

Code listing [Create RSS files with XML::RSS](#xml-rss) shows a simple program to create the RSS data in code listing [RSS file format](#rss). The [XML::RSS](https://www.metacpan.org/pod/XML::RSS) module can handle several versions of RSS, so in line 5 I specify version 0.9.  I can change the version number to another one that [XML::RSS](https://www.metacpan.org/pod/XML::RSS) can handle and see the results.  Other versions are a bit more complicated, but [XML::RSS](https://www.metacpan.org/pod/XML::RSS) handles them for me through the same interface so I can decide to switch later and not have to completely rewrite the script.

On line 10, I create the RSS channel from the first two lines from `DATA`. On line 15, I start a while loop to process the rest of the data.  I skip lines without non-whitespace, `chomp` the line that I read in the while condition, then read another line of data and `chomp` that.  I expect the first line to be the title and the line after that to be the link address.  I add these to my RSS object on line 22.

On line 28, I simply print the RSS data as a string.  It should look close to the output in code listing [RSS file format](#rss), although some people may see slight differences for different versions of [XML::RSS](https://www.metacpan.org/pod/XML::RSS).

<p class="code_title"><a class="ref_name" name="xml-rss">Create RSS files with XML::RSS</a></p>

{% highlight perl linenos %}
#!/usr/bin/perl -w
use strict;

use XML::RSS
my $rss = XML::RSS->new( version => '0.9' );

chomp( my $channel_title = <DATA> );
chomp( my $channel_link  = <DATA> );

$rss->channel(
		title => $channel_title,
		link => $channel_link,
		);

while( defined( my $title = <DATA> ) )
		{
		next unless $title =~ /\S/;
		chomp $title;

		chomp( my $link = <DATA> );

		$rss->add_item(
			title => $title,
			link  => $link,
			);
		}

print $rss->as_string;

__END__
The Perl Review, v0 i5, September 2002
http://www.theperlreview.com/Issues/The_Perl_Review_0_5.pdf

Extreme Mowing, by Andy Lester
http://www.theperlreview.com/Articles/v0i5/extreme_mowing.pdf

What Perl Programmers Should Know About Java, by Beth Linker
http://www.theperlreview.com/Articles/v0i5/perl-java.pdf

Filehandle Ties, by Robby Walker
http://www.theperlreview.com/Articles/v0i5/filehandle_ties.pdf

The Iterator Design Pattern, by brian d foy
http://www.theperlreview.com/Articles/v0i5/iterators.pdf
{% endhighlight %}

## Parsing RSS

The [XML::RSS](https://www.metacpan.org/pod/XML::RSS) module makes parsing RSS even more easy that creating it.  In code listing [Fetch and parse RSS feeds](#fetch), which shows the actual program we use to generate the HTML for "Perl at a Glance", most of the work deals with HTML, not RSS.  Line 7 defines the RSS files to download. I found those by either visiting the site or asking the author if they had RSS files.  For instance, Randal Schwartz has RSS feeds for most of his columns although he does not advertise this on his web site—at least not somewhere I could find.

Line 18 defines the location the program stores output files. Each feed has an associated output file which contains just its portion of HTML that another program collates into the final web page.

Line 20 starts the foreach loop which cycles through all of the RSS files.  On line 22, I copy the URL to `$file` so I can manipulate `$file` and use it as the file name in the open on line 26.  If I cannot open the file, I skip to the next feed.  On line 34, I select the file handle I just opened so I do not have to specify it in all of the print statements.

On line 36, I create a new RSS object.  I do not have to specify the version I want to use because [XML::RSS](https://www.metacpan.org/pod/XML::RSS) figures it out based on the data I feed it in line 38.  Once the module parses the data, I simply access the parts that I need. On lines 40 and 41 I get the channel title and image, which are hash references I store in `$channel` and `$image`.

On line 43, I start the HTML output.  At some point I will change this program to use [Test::Template](https://www.metacpan.org/pod/Test::Template), but for now something is better than nothing, even if this is horribly wrong. Next issue I will convert this program to store configuration and template data apart from the code to make up for it.

On line 49, I check if `$image` has a url key.  The feed might not have included a logo and I do not want a broken image icon to show up if it did not.  With an image, I use the image location to form the link back to the original site, and without an image, I use the channel title.

On line 67, I iterate through the items in the feed and print a link for each one.  Once I finish with the items I finish the HTML output and close the filehandle.


<p class="code_title"><a class="ref_name" name="fetch">Fetch and parse RSS feeds</a></p>

{% highlight perl linenos %}
#!/usr/bin/perl -w
use strict;

use LWP::Simple;
use XML::RSS;

my @files = qw(
	http://use.perl.org/useperl.rss
	http://search.cpan.org/rss/search.rss
	http://jobs.perl.org/rss/standard.rss
	http://www.perl.com/pace/perlnews.rdf
	http://www.perlfoundation.org/perl-foundation.rdf
	http://www.stonehenge.com/merlyn/UnixReview/ur.rss
	http://www.stonehenge.com/merlyn/WebTechniques/wt.rss
	http://www.stonehenge.com/merlyn/LinuxMag/lm.rss
	);

my $base = '/home/tpr/rss-html';

foreach my $url ( @files )
	{
	my $file = $url;

	$file =~ s|.*/||;

	my $result = open my $fh, "> $base/$file.html";

	unless( $result )
		{
		warn "Could not open [$file] for writing! $!";
		next;
		}

	select $fh;

	my $rss = XML::RSS->new();
	my $data = get( $url );
	$rss->parse( $data );

	my $channel = $rss->{channel};
	my $image   = $rss->{image};

	print <<"HTML";
	<table cellpadding=1><tr><td bgcolor="#000000">
	<table cellpadding=5>
		<tr><td bgcolor="#aaaaaa" align="center">
HTML

	if( $image->{url} )
		{
		my $img = qq|<img src="$$image{url}" alt="$$channel{title}">|;

		print qq|<a href="$$channel{link}">$img</a><br>\n|;
		}
	else
		{
		print qq|<a href="$$channel{link}">$$channel{title}</a><br>\n|;
		}

	print qq|<font size="-1">$$channel{description}</font>\n|;

	print <<"HTML";
	</td></tr>
	<tr><td bgcolor="#bbbbff" width=200><font size="-1">
HTML

	foreach my $item ( @{ $rss->{items} } )
		{
		print qq|<b></b><a href="$$item{link}">$$item{title}</a><br><br>\n|;
		}

	print <<"HTML";
		</font></td></tr>
	</td></tr></table>
	</td></tr></table>
HTML

	close $fh;
	}
{% endhighlight %}

### Updating RSS feeds automatically

Once I decide which feeds I want to process and how I want to present them, I want to fetch them automatically.  I can use `crontab` to schedule the program to run at certain times (`cron` comes with unix-like platforms and is available as third-party tools for Windows).  The frequency that I run this program depends on how often the sites update their feeds.  I typically update things hourly, but not on the hour when everyone else is probably updating their feeds. I update at 17 minutes past the hour:

{% highlight text %}
17 * * * * /usr/home/comdog/bin/rss2html.pl
{% endhighlight %}

### Some things I do not cover

The RSS format handles a lot more than what I have shown, but once I have [XML::RSS](https://www.metacpan.org/pod/XML::RSS) doing the hard work, everything else is easy.  Other commonly-used features include search forms linking to the original site, channel descriptions, item descriptions, channel meta-data for caching, fetching, and more.

## Conclusion

With a minimum of effort, I can create or parse RSS files.  The [XML::RSS](https://www.metacpan.org/pod/XML::RSS) module handles the details of different versions for me so I can know as little or as much RSS as I care to know.  When I parse an RSS file, I can access its parts through familiar Perl data structures.

## References

* [O'Reilly Network RSS DevCenter](http://www.oreillynet.com/rss/)
* [RSS News](http://blogspace.com/rss/)


