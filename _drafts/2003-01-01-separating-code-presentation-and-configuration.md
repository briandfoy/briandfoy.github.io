---
layout: post
title: Separating Code, Presentation, and Configuration
categories:
tags:
stopwords:
last_modified:
original_url:
---

[% META
	author  = 'brian d foy'
	title   = 'Separating Code, Presentation, and Configuration'
	tags    = 'config perl mvc'
	issue   = '0.7'
%]

[% PROCESS article_header %]

<p class="abstract">
I take a program from a previous article and separate the code,
presentation, and configuration into separate parts to make the
program more flexible and easier to maintain.
</p>

<h2>Introduction</h2>

<p class="full_text">
In the last issue, I presented a program I use to pull and display
Rich Site Summaries (RSS) from other web sites (see <a
class="article_link" href="rss.html">Simple RSS with Perl</a>. I used
literal values in the code to specify which files to download and how
to present the data, and I promised I would fix that in this issue.
</p>

<p class="full_text">
Code listing <a href="#old_code" class="internal_link">Hard-Coded
Configuration</a> shows the same program I presented in the previous
article.  The <code class="inline">@files</code> array holds the files
I want to download, <code class="inline">$base</code> is the directory
where my output is stored, and several print statements create HTML
with simple variable interpolation (rather than CGI.pm's HTML
functions, for example). This code is inflexible and a maintenance
hassle.  When I want to change the list of sites or the output, I risk
breaking the program if I type the wrong thing or make another
mistake.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="old_code">Hard-Coded Configuration</a></p>
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

my $base = '/usr/home/comdog/TPR/rss-html';

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

    print &lt;&lt;"HTML";
    &lt;table cellpadding=1>&lt;tr>&lt;td bgcolor="#000000">
    &lt;table cellpadding=5>
        &lt;tr>&lt;td bgcolor="#aaaaaa" align="center">
HTML

    if( $image->{url} )
        {
        my $img = qq|&lt;img src="$$image{url}" alt="$$channel{title}">|;
        print qq|&lt;a href="$$channel{link}">$img&lt;/a>&lt;br>\n|;
        }
    else
        {
        print qq|&lt;a href="$$channel{link}">$$channel{title}&lt;/a>&lt;br>\n|;
        }

    print &lt;&lt;"HTML";
        &lt;font size="-1">$$channel{description}&lt;/font>
    &lt;/td>&lt;/tr>
    &lt;tr>&lt;td bgcolor="#bbbbff" width=200>&lt;font size="-1">
HTML

    foreach my $item ( @{ $rss->{items} } )
        {
        print qq|&lt;b>&lt;/b>&lt;a href="$$item{link}">$$item{title}&lt;/a>&lt;br>&lt;br>\n|;
        }

    print &lt;&lt;"HTML";
        &lt;/font>&lt;/td>&lt;/tr>
    &lt;/td>&lt;/tr>&lt;/table>
    &lt;/td>&lt;/tr>&lt;/table>
HTML

    close $fh;
    }
</pre>

</p>

<h2>Separating presentation</h2>

<p class="full_text">
A good design does not tie itself to a particular presentation of the
data. My program should fetch the data and make it available to
something that presents it&mdash;that I am working with RSS should not
matter.  I might want to produce HTML, TeX, plain text, or even some
format that I cannot anticipate.
</p>

<p class="full_text">
Everyone seems to write their own templating system, but I like Mark
Jason Dominus's [% te.cpan_module( 'Text::Template' ) %]. It does
almost everything I need, does not require extra programs to do its
work, and is pure Perl. It has a simple interface and I do not have to
learn a templating language because the templates use Perl.
</p>

<p class="full_text">
Code listing <a href="#use-template" class="internal_link">Using
Templates</a> is the same program as code listing <a href="#old_code"
class="internal_link">Hard-Coded Configuration</a>, but uses [%
te.cpan_module( 'Text::Template' ) %] instead of embedded HTML. In
line 5 I import the <code class="inline">fill_in_file()</code> method.
 In line 13 I specify the template I will use.   All of the HTML in
the program is now in the template file in code listing <a
href="#html" class="internal_link">HTML Output</a>.
</p>

<p class="full_text">
The [% te.cpan_module( 'Text::Template' ) %] module can accept data as
a hash.  The keys of the hash become variable names in the template,
and the value becomes the template variable value, but also determines
the variable type.  If the hash value is an a simple scalar, the
template variable is a scalar. If the hash value is an anonymous
array, the template variable is an array, and so on.
</p>

<p class="full_text">
The object created by [% te.cpan_module( 'XML::RSS' ) %] is an
anonymous hash.  The module has an abstract interface for creation,
but not for access.  This is just the sort of thing I need to pass to
my template.  In the template, <code
class="inline">$rss->{channel}</code>, which has a anonymous hash
value, becomes <code class="inline">%channel</code> in the template,
and <code class="inline">$rss->{items}</code>, which has an anonymous
array value, becomes <code class="inline">@items</code> in the
template.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="use_template">Using Templates</a></p>
#!/usr/bin/perl -w
use strict;

use LWP::Simple;
use Text::Template qw(fill_in_file);
use XML::RSS;

my @files = qw(
http://use.perl.org/useperl.rss
);

my $base     = '.';
my $template = 'rss-html.tmpl';

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

    my $rss = XML::RSS->new();
    my $data = get( $url );
    $rss->parse( $data );

    print fill_in_file( $template, HASH => $rss );
    close $fh;
    }
</pre>

<p class="full_text">
Inside the template, [% te.cpan_module( 'Text::Template' ) %] runs
blocks of code it finds between curly braces.  It replaces the block
of code with the last evaluated expression.  The variable names are
the keys of the hash reference I passed as an argument to <code
class="inline">fill_in_file()</code> in code listing <a
href="#use_template" class="internal_link">Using Templates</a>.
</p>

<pre class="output">
<p class="code_title"><a class="ref_name" name="html">HTML Output</a></p>
&lt;table cellpadding=1>&lt;tr>&lt;td bgcolor="#000000">
&lt;table cellpadding=5>
    &lt;tr>
        &lt;td bgcolor="#aaaaaa" align="center">
        &lt;a href="{ $channel{link} }">{

            $image ? qq|&lt;img src="$image" alt="$channel{title}">| : $channel{title}

         }&lt;/a>&lt;br>

        { $channel{description} }
        &lt;/td>
    &lt;/tr>

    &lt;tr>
        &lt;td bgcolor="#bbbbff" width=200>&lt;font size="-1">
{
        my $str;

        foreach my $item ( @items )
            {
            $str .= qq|&lt;b>&lt;&lt;/b>&lt;a href="$$item{link}">$$item{title}&lt;/a>&lt;br>&lt;br>\n|;
            }

        $str;
        }       &lt;/font>&lt;/td>
    &lt;/tr>
&lt;/td>&lt;/tr>&lt;/table>
&lt;/td>&lt;/tr>&lt;/table>
</pre>

<p class="full_text">
Once I have the templating system in place, I can change the
presentation without affecting the logic of the code.  If I decide to
change the way I present the data, I only change the template.  If I
want plain text instead of HTML, I simply modify the template for the
new format that I want, as I do in code listing <a href="#text"
class="internal_link">Text Output</a>.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="text">Text Output</a></p>
{ $channel{title} }

{ $channel{description} }

{
my $str;

foreach my $item ( @items )
    {
    $str .= qq|* $$item{title}\n|;
    }

$str;
}
</pre>

</p>

<h2>Separating configuration</h2>

<p class="full_text">
A good design also permits the script to adapt to a different
environment. In code listing <a href="#old_code"
class="internal_link">Hard-Coded Configuration</a>, I hard-coded the
value of the output directory into the script which makes it
fragile&mdash;if my home directory changes, my script breaks.  Also,
in code listing <a href="#use_template" class="internal_link">Using
Templates</a>, I hard-coded the template file name, even though I can
change the presentation by changing the template. I should be able to
give each template a descriptive name rather than use the same name no
matter the content.
</p>

<p class="full_text">
Many freely-available scripts that I find on the internet
require that the user edit a top portion of the script, or
an included library that contains only configuration data.
This approach requires the end user to know the basics of
the programming language and to edit code&mdash;a mistake breaks
the script.  Bad configuration data can give unexpected
results, but they should not break the program.
</p>

<p class="full_text">
I can specify run-time configuration data in several ways, and I only
show one of them.  [% te.external_url( 'http://search.cpan.org',
'Comprehensive Perl Archive Network (CPAN)' ) %] has several modules
to parse different configuration file formats or command line
arguments.  Designers should choose an approach that fits their needs.
</p>

<p class="full_text">
When I first started to routinely separate configuration data from my
scripts, I tried several of the modules on CPAN, and settled on [%
te.cpan_module( 'ConfigReader::Simple' ) %] which uses a simple
key-value line-oriented format.  I used it often enough that I started
to send in my changes to Bek Oberin, the original author, then
completely took over maintenance of the module.
</p>

<p class="full_text">
Code listing <a href="#use_config" class="internal_link">Using
External Config</a> adapts code listing <a href="#use-template"
class="internal_link">use-template</a> to use [% te.cpan_module(
'ConfigReader::Simple' ) %].  I create a new configuration object,
then read values from the object. The module turns the names of the
configuration keys into method names for easy access (although exotic
key names that I cannot coerce into a Perl identifier require the
<code class="inline">get()</code> method to access their value).  Code
listing <a href="#config_file" class="internal_link">External Config
File</a> shows the configuration file.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="use_config">Using External Config</a></p>
#!/usr/bin/perl -w
use strict;

use ConfigReader::Simple;
use LWP::Simple;
use Text::Template qw(fill_in_file);
use XML::RSS;

my $config    = ConfigReader::Simple->new( './rss.config' );

my $base      = $config->base;
my $template  = $config->template;
my $extension = $config->extension;

my @files    = split /\s+/, $config->files;

foreach my $url ( @files )
    {
    my $file = $url;

    $file =~ s|.*/||;

    my $result = open my $fh, "> $base/$file.$extension";

    unless( $result )
        {
        warn "Could not open [$file] for writing! $!";
        next;
        }

    my $rss = XML::RSS->new();
    my $data = get( $url );
    $rss->parse( $data );

    print $fh fill_in_file( $template, HASH => $rss );
    close $fh;
    }
</pre>

<pre class="code">
<p class="code_title"><a class="ref_name" name="config_file">External Config File</a></p>
base .
template rss-html.tmpl
files http://use.perl.org/useperl.rss
extension html
</pre>

<h2>Conclusion</h2>

<p class="full_text">
I can reduce the size of my programs by separating the code from the
presentation logic and the configuration information.  This separation
makes the program more flexible and easier to adapt to new
environments. Templates allow the output to show up in many forms
without changes to the code, and configuration files allow me to
change the way the program operates without affecting the code.  The
[% te.cpan_module( 'Text::Template' ) %] and [% te.cpan_module(
'ConfigReader::Simple' ) %] make this about as simple as it can be.
</p>

<h2>References</h2>

<p class="full_text">
All modules mentioned in this article are in the
[% te.external_url( 'http://search.cpan.org', 'Comprehensive Perl Archive Network (CPAN)' ) %]
</p>

[% PROCESS footer %]

