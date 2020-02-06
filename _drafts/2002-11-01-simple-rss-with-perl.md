---
layout: post
title: Simple RSS with Perl
categories:
tags:
stopwords:
last_modified:
original_url:
---

[% META
	author  = 'brian d foy'
	title   = 'Simple RSS with Perl'
	tags    = 'rss perl xml'
	issue   = '0.6'
%]

[% PROCESS article_header %]

<h2>Introduction</h2>

<p class="full_text">
The Rich Site Summary (RSS) is a set of stories, usually from the same
web site.  The RSS file contains XML data which other programs can parse
to create custom presentations.
</p>

<p class="full_text">
There are several major versions of RSS.  The first version, 0.9, is
simple to read and simple to use.  It does not contain as much
information as later versions which provide various additions to the RSS
format&mdash;even arbitrary extension through XML namespace magic.  I think
that is overkill for my purposes, and I do not want to do the extra work
to handle the extra features. I use version 0.9, and I only show that in
this article.
</p>

<p class="full_text">
<font class="term">The Perl Review</font> publishes RSS files for each
issue and for collections of related articles. A few other web sites
actually use them.  In the other direction, we use several other sites'
RSS files on our web site for "Perl at a Glance".
</p>

<h2>Creating RSS</h2>

<p class="full_text">
Files in RSS 0.9 typically have the extension <code
class="inline">.rdf</code> for Resource Description Framework.  The
XML format is very simple.  Code listing <a class="code_link"
href="#rss">RSS file format</a> shows the actual RSS file for the last
issue.  Line 1 is the required XML header. Line 3 pulls in the
appropriate definitions.  The RSS data  has <i
class="term">channel</i> and <i class="term">item</i> data.  The
channel is the name of the feed and typically has a title and a link
to the original website.  Line 7 starts my channel element with a
title element with the name of the issue, and a link element to the
issue file. The rest of the elements are items, sometimes called <i
class="term">headlines</i>.  Each item has a title and link.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="rss">RSS file format</a></p>
<font class="line_number"> 1</font> &lt;?xml version="1.0"?>
<font class="line_number"> 2</font>
<font class="line_number"> 3</font> &lt;rdf:RDF
<font class="line_number"> 4</font> xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
<font class="line_number"> 5</font> xmlns="http://my.netscape.com/rdf/simple/0.9/">
<font class="line_number"> 6</font>
<font class="line_number"> 7</font> &lt;channel>
<font class="line_number"> 8</font> &lt;title>The Perl Review, v0 i5, September 2002&lt;/title>
<font class="line_number"> 9</font> &lt;link>http://www.theperlreview.com/Issues/The_Perl_Review_0_5.pdf&lt;/link>
<font class="line_number">10</font> &lt;/channel>
<font class="line_number">11</font>
<font class="line_number">12</font> &lt;item>
<font class="line_number">13</font> &lt;title>Extreme Mowing, by Andy Lester&lt;/title>
<font class="line_number">14</font> &lt;link>http://www.theperlreview.com/Articles/v0i5/extreme_mowing.pdf&lt;/link>
<font class="line_number">15</font> &lt;/item>
<font class="line_number">16</font>
<font class="line_number">17</font> &lt;item>
<font class="line_number">18</font> &lt;title>What Perl Programmers Should Know About Java, by Beth Linker&lt;/title>
<font class="line_number">19</font> &lt;link>http://www.theperlreview.com/Articles/v0i5/perl-java.pdf&lt;/link>
<font class="line_number">20</font> &lt;/item>
<font class="line_number">21</font>
<font class="line_number">22</font> &lt;item>
<font class="line_number">23</font> &lt;title>Filehandle Ties, by Robby Walker&lt;/title>
<font class="line_number">24</font> &lt;link>http://www.theperlreview.com/Articles/v0i5/filehandle_ties.pdf&lt;/link>
<font class="line_number">25</font> &lt;/item>
<font class="line_number">26</font>
<font class="line_number">27</font> &lt;item>
<font class="line_number">28</font> &lt;title>The Iterator Design Pattern, by brian d foy&lt;/title>
<font class="line_number">29</font> &lt;link>http://www.theperlreview.com/Articles/v0i5/iterators.pdf&lt;/link>
<font class="line_number">30</font> &lt;/item>
<font class="line_number">31</font>
<font class="line_number">32</font> &lt;/rdf:RDF>
</pre>


<p class="full_text">
Creating this file is very easy.  I can write it by hand, but I can also
create it with a program, which I want to do since all of the data comes
from a database and I want to automate the process.
</p>

<p class="full_text">
Code listing <a class="code_link" href="#xml-rss">Create RSS files
with XML::RSS</a> shows a simple program to create the RSS data in
code listing <a class="code_link" href="#rss">RSS file format</a>. The
[% te.cpan_module( 'XML::RSS' ) %] module can handle several versions
of RSS, so in line 5 I specify version 0.9.  I can change the version
number to another one that [% te.cpan_module( 'XML::RSS' ) %] can
handle and see the results.  Other versions are a bit more
complicated, but [% te.cpan_module( 'XML::RSS' ) %] handles them for
me through the same interface so I can decide to switch later and not
have to completely rewrite the script.
</p>


<p class="full_text">
On line 10, I create the RSS channel from the first two lines from
<code class="inline">DATA</code>. On line 15, I start a while loop to
process the rest of the data.  I skip lines without non-whitespace,
<code class="inline">chomp</code> the line that I read in the while
condition, then read another line of data and <code
class="inline">chomp</code> that.  I expect the first line to be the
title and the line after that to be the link address.  I add these to
my RSS object on line 22.
</p>


<p class="full_text">
On line 28, I simply print the RSS data as a string.  It should look
close to the output in code listing <a class="code_link"
href="#rss">RSS file format</a>, although some people may see slight
differences for different versions of [% te.cpan_module( 'XML::RSS' )
%].
</p>


<pre class="code">
<p class="code_title"><a class="ref_name" name="xml-rss">Create RSS files with XML::RSS</a></p>
<font class="line_number"> 1</font> #!/usr/bin/perl -w
<font class="line_number"> 2</font> use strict;
<font class="line_number"> 3</font>
<font class="line_number"> 4</font> use XML::RSS
<font class="line_number"> 5</font> my $rss = XML::RSS->new( version => '0.9' );
<font class="line_number"> 6</font>
<font class="line_number"> 7</font> chomp( my $channel_title = &gt;DATA> );
<font class="line_number"> 8</font> chomp( my $channel_link  = &gt;DATA> );
<font class="line_number"> 9</font>
<font class="line_number">10</font> $rss->channel(
<font class="line_number">11</font> 		title        => $channel_title,
<font class="line_number">12</font> 		link         => $channel_link,
<font class="line_number">13</font> 		);
<font class="line_number">14</font>
<font class="line_number">15</font> while( defined( my $title = &gt;DATA> ) )
<font class="line_number">16</font> 		{
<font class="line_number">17</font> 		next unless $title =~ /\S/;
<font class="line_number">18</font> 		chomp $title;
<font class="line_number">19</font>
<font class="line_number">20</font> 		chomp( my $link = &gt;DATA> );
<font class="line_number">21</font>
<font class="line_number">22</font> 		$rss->add_item(
<font class="line_number">23</font> 				title => $title,
<font class="line_number">24</font> 				link  => $link,
<font class="line_number">25</font> 				);
<font class="line_number">26</font> 		}
<font class="line_number">27</font>
<font class="line_number">28</font> print $rss->as_string;
<font class="line_number">29</font>
<font class="line_number">30</font> __END__
<font class="line_number">31</font> The Perl Review, v0 i5, September 2002
<font class="line_number">32</font> http://www.theperlreview.com/Issues/The_Perl_Review_0_5.pdf
<font class="line_number">33</font>
<font class="line_number">34</font> Extreme Mowing, by Andy Lester
<font class="line_number">35</font> http://www.theperlreview.com/Articles/v0i5/extreme_mowing.pdf
<font class="line_number">36</font>
<font class="line_number">37</font> What Perl Programmers Should Know About Java, by Beth Linker
<font class="line_number">38</font> http://www.theperlreview.com/Articles/v0i5/perl-java.pdf
<font class="line_number">39</font>
<font class="line_number">40</font> Filehandle Ties, by Robby Walker
<font class="line_number">41</font> http://www.theperlreview.com/Articles/v0i5/filehandle_ties.pdf
<font class="line_number">42</font>
<font class="line_number">43</font> The Iterator Design Pattern, by brian d foy
<font class="line_number">44</font> http://www.theperlreview.com/Articles/v0i5/iterators.pdf
</pre>

<h2>Parsing RSS</h2>

<p class="full_text">
The [% te.cpan_module( 'XML::RSS' ) %] module makes parsing RSS even
more easy that creating it.  In code listing <a class="code_link"
href="#fetch">Fetch and parse RSS feeds</a>, which shows
the actual program we use to generate the HTML for "Perl at a
Glance", most of the work deals with HTML, not RSS.  Line 7 defines
the RSS files to download. I found those by either visiting the site
or asking the author if they had RSS files.  For instance, Randal
Schwartz has RSS feeds for most of his columns although he does not
advertise this on his web site&mdash;at least not somewhere I could
find.
</p>

<p class="full_text">
Line 18 defines the location the program stores output files. Each
feed has an associated output file which contains just its portion of
HTML that another program collates into the final web page.
</p>

<p class="full_text">
Line 20 starts the foreach loop which cycles through all of the RSS
files.  On line 22, I copy the URL to <code
class="inline">$file</code> so I can manipulate <code
class="inline">$file</code> and use it as the file name in the open on
line 26.  If I cannot open the file, I skip to the next feed.  On line
34, I select the file handle I just opened so I do not have to specify
it in all of the print statements.
</p>

<p class="full_text">
On line 36, I create a new RSS object.  I do not have to specify the
version I want to use because [% te.cpan_module( 'XML::RSS' ) %]
figures it out based on the data I feed it in line 38.  Once the
module parses the data, I simply access the parts that I need. On
lines 40 and 41 I get the channel title and image, which are hash
references I store in <code class="inline">$channel</code> and <code
class="inline">$image</code>.
</p>

<p class="full_text">
On line 43, I start the HTML output.  At some point I will change this
program to use [% te.cpan_module( 'Test::Template' ) %], but for now
something is better than nothing, even if this is horribly wrong.
Next issue I will convert this program to store configuration and
template data apart from the code to make up for it.
</p>

<p class="full_text">
On line 49, I check if <code class="inline">$image</code> has a url
key.  The feed might not have included a logo and I do not want a
broken image icon to show up if it did not.  With an image, I use the
image location to form the link back to the original site, and without
an image, I use the channel title.
</p>

<p class="full_text">
On line 67, I iterate through the items in the feed and print a link
for each one.  Once I finish with the items I finish the HTML output
and close the filehandle.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="fetch">Fetch and parse RSS feeds</a></p>
<font class="line_number"> 1</font> #!/usr/bin/perl -w
<font class="line_number"> 2</font> use strict;
<font class="line_number"> 3</font>
<font class="line_number"> 4</font> use LWP::Simple;
<font class="line_number"> 5</font> use XML::RSS;
<font class="line_number"> 6</font>
<font class="line_number"> 7</font> my @files = qw(
<font class="line_number"> 8</font> http://use.perl.org/useperl.rss
<font class="line_number"> 9</font> http://search.cpan.org/rss/search.rss
<font class="line_number">10</font> http://jobs.perl.org/rss/standard.rss
<font class="line_number">11</font> http://www.perl.com/pace/perlnews.rdf
<font class="line_number">12</font> http://www.perlfoundation.org/perl-foundation.rdf
<font class="line_number">13</font> http://www.stonehenge.com/merlyn/UnixReview/ur.rss
<font class="line_number">14</font> http://www.stonehenge.com/merlyn/WebTechniques/wt.rss
<font class="line_number">15</font> http://www.stonehenge.com/merlyn/LinuxMag/lm.rss
<font class="line_number">16</font> );
<font class="line_number">17</font>
<font class="line_number">18</font> my $base = '/usr/home/comdog/TPR/rss-html';
<font class="line_number">19</font>
<font class="line_number">20</font> foreach my $url ( @files )
<font class="line_number">21</font> 	{
<font class="line_number">22</font> 	my $file = $url;
<font class="line_number">23</font>
<font class="line_number">24</font> 	$file =~ s|.*/||;
<font class="line_number">25</font>
<font class="line_number">26</font> 	my $result = open my $fh, "> $base/$file.html";
<font class="line_number">27</font>
<font class="line_number">28</font> 	unless( $result )
<font class="line_number">29</font> 		{
<font class="line_number">30</font> 		warn "Could not open [$file] for writing! $!";
<font class="line_number">31</font> 		next;
<font class="line_number">32</font> 		}
<font class="line_number">33</font>
<font class="line_number">34</font> 	select $fh;
<font class="line_number">35</font>
<font class="line_number">36</font> 	my $rss = XML::RSS->new();
<font class="line_number">37</font> 	my $data = get( $url );
<font class="line_number">38</font> 	$rss->parse( $data );
<font class="line_number">39</font>
<font class="line_number">40</font> 	my $channel = $rss->{channel};
<font class="line_number">41</font> 	my $image   = $rss->{image};
<font class="line_number">42</font>
<font class="line_number">43</font> 	print &gt;&gt;"HTML";
<font class="line_number">44</font> 	&gt;table cellpadding=1>&gt;tr>&gt;td bgcolor="#000000">
<font class="line_number">45</font> 	&gt;table cellpadding=5>
<font class="line_number">46</font> 		&gt;tr>&gt;td bgcolor="#aaaaaa" align="center">
<font class="line_number">47</font> HTML
<font class="line_number">48</font>
<font class="line_number">49</font> 	if( $image->{url} )
<font class="line_number">50</font> 		{
<font class="line_number">51</font> 		my $img = qq|&gt;img src="$$image{url}" alt="$$channel{title}">|;
<font class="line_number">52</font>
<font class="line_number">53</font> 		print qq|&gt;a href="$$channel{link}">$img&gt;/a>&gt;br>\n|;
<font class="line_number">54</font> 		}
<font class="line_number">55</font> 	else
<font class="line_number">56</font> 		{
<font class="line_number">57</font> 		print qq|&gt;a href="$$channel{link}">$$channel{title}&gt;/a>&gt;br>\n|;
<font class="line_number">58</font> 		}
<font class="line_number">59</font>
<font class="line_number">60</font> 	print qq|&gt;font size="-1">$$channel{description}&gt;/font>\n|;
<font class="line_number">61</font>
<font class="line_number">62</font> 	print &gt;&gt;"HTML";
<font class="line_number">63</font> 	&gt;/td>&gt;/tr>
<font class="line_number">64</font> 	&gt;tr>&gt;td bgcolor="#bbbbff" width=200>&gt;font size="-1">
<font class="line_number">65</font> HTML
<font class="line_number">66</font>
<font class="line_number">67</font> 	foreach my $item ( @{ $rss->{items} } )
<font class="line_number">68</font> 		{
<font class="line_number">69</font> 		print qq|&gt;b>&gt;&gt;/b>&gt;a href="$$item{link}">$$item{title}&gt;/a>&gt;br>&gt;br>\n|;
<font class="line_number">70</font> 		}
<font class="line_number">71</font>
<font class="line_number">72</font> 	print &gt;&gt;"HTML";
<font class="line_number">73</font> 		&gt;/font>&gt;/td>&gt;/tr>
<font class="line_number">74</font> 	&gt;/td>&gt;/tr>&gt;/table>
<font class="line_number">75</font> 	&gt;/td>&gt;/tr>&gt;/table>
<font class="line_number">76</font> HTML
<font class="line_number">77</font>
<font class="line_number">78</font> 	close $fh;
<font class="line_number">79</font> 	}
</pre>

<h3>Updating RSS feeds automatically</h3>


<p class="full_text">
Once I decide which feeds I want to process and how I want to present
them, I want to fetch them automatically.  I can use <code
class="inline">crontab</code> to schedule the program to run at
certain times (<code class="inline">cron</code> comes with unix-like
platforms and is available as third-party tools for windows).  The
frequency that I run this program depends on how often the sites
update their feeds.  I typically update things hourly, but not on the
hour when everyone else is probably updating their feeds. I update at
17 minutes past the hour:
</p>

<pre class="code">
17 * * * * /usr/home/comdog/bin/rss2html.pl
</pre>

<h3>Some things I do not cover</h3>


<p class="full_text">
The RSS format handles a lot more than what I have shown, but once I
have [% te.cpan_module( 'XML::RSS' ) %] doing the hard work,
everything else is easy.  Other commonly-used features include search
forms linking to the original site, channel descriptions, item
descriptions, channel meta-data for caching, fetching, and more.
</p>

<h2>Conclusion</h2>

<p class="full_text">
With a minimum of effort, I can create or parse RSS files.  The [%
te.cpan_module( 'XML::RSS' ) %] module handles the details of
different versions for me so I can know as little or as much RSS as I
care to know.  When I parse an RSS file, I can access its parts
through familiar Perl data structures.
</p>

<h2>References</h2>

<ol>
<li>[% te.external_url('http://www.oreillynet.com/rss/', 'O\'Reilly Network RSS DevCenter' ) %]
<li>[% te.external_url('http://blogspace.com/rss/', 'RSS News' ) %]
</ol>

<h2>About the Author</h2>

<p class="full_text">
brian d foy is the publisher of <font class="tpr">The Perl Review</font>.
</p>

[% PROCESS footer %]

