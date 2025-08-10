---
layout: post
title: Separating Code, Presentation, and Configuration
categories: perl programming
tags: config mvc config rescued-content the-perl-review
stopwords: Bek Dominus's Oberin pm's
last_modified:
original_url:
---

*I originally published this in The Perl Review 0.7, January 2003*

I take a program from a previous article and separate the code, presentation, and configuration into separate parts to make the program more flexible and easier to maintain.

<!--more-->

## Introduction

In the previous issue, I presented a program I use to pull and display Rich Site Summaries (RSS) from other web sites (see [Simple RSS with Perl](/2002-11-01-simple-rss-with-perl/). I used literal values in the code to specify which files to download and how to present the data, and I promised I would fix that in this issue.

Code listing <a href="#old_code" class="internal_link">Hard-Coded Configuration</a> shows the same program I presented in the previous article. The `@files` array holds the files I want to download, `$base` is the directory where my output is stored, and several print statements create HTML with simple variable interpolation (rather than CGI.pm's HTML functions, for example). This code is inflexible and a maintenance hassle. When I want to change the list of sites or the output, I risk breaking the program if I type the wrong thing or make another mistake.

<a class="ref_name" name="old_code">Hard-coded configuration</a>
{% highlight perl %}
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

    print <<"HTML";
        <font size="-1">$$channel{description}</font>
    </td></tr>
    <tr><td bgcolor="#bbbbff" width=200><font size="-1">
HTML

    foreach my $item ( @{ $rss->{items} } )
        {
        print qq|<a href="$$item{link}">$$item{title}</a><br><br>\n|;
        }

    print <<"HTML";
        </font></td></tr>
    </td></tr></table>
    </td></tr></table>
HTML

    close $fh;
    }
{% endhighlight %}

## Separating presentation

A good design does not tie itself to a particular presentation of the data. My program should fetch the data and make it available to something that presents it—that I am working with RSS should not matter. I might want to produce HTML, TeX, plain text, or even some format that I cannot anticipate.

Everyone seems to write their own templating system, but I like Mark Jason Dominus's [Text::Template](https://www.metacpan.org/pod/Text::Template). It does almost everything I need, does not require extra programs to do its work, and is pure Perl. It has a simple interface and I do not have to learn a templating language because the templates use Perl.

Code listing <a href="#use-template" class="internal_link">Using Templates</a> is the same program as code listing <a href="#old_code" class="internal_link">Hard-Coded Configuration</a>, but uses [Text::Template](https://www.metacpan.org/pod/Text::Template) instead of embedded HTML. In line 5 I import the `fill_in_file()` method. In line 13 I specify the template I will use. All of the HTML in the program is now in the template file in code listing <a href="#html" class="internal_link">HTML Output</a>.

The [Text::Template](https://www.metacpan.org/pod/Text::Template) module can accept data as a hash. The keys of the hash become variable names in the template, and the value becomes the template variable value, but also determines the variable type. If the hash value is an a simple scalar, the template variable is a scalar. If the hash value is an anonymous array, the template variable is an array, and so on.

The object created by [XML::RSS](https://www.metacpan.org/pod/XML::RSS) is an anonymous hash. The module has an abstract interface for creation, but not for access. This is just the sort of thing I need to pass to my template. In the template, `$rss->{channel}`, which has a anonymous hash value, becomes `%channel` in the template, and `$rss->{items}`, which has an anonymous array value, becomes `@items` in the template.

<a class="ref_name" name="use_template">Using templates</a>
{% highlight perl linenos %}
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
{% endhighlight %}

Inside the template, [Text::Template](https://www.metacpan.org/pod/Text::Template) runs blocks of code it finds between curly braces. It replaces the block of code with the last evaluated expression. The variable names are the keys of the hash reference I passed as an argument to `fill_in_file()` in code listing <a href="#use_template" class="internal_link">Using Templates</a>.


<a class="ref_name" name="html">HTML output</a>
{% highlight html %}
<table cellpadding=1><tr><td bgcolor="#000000">
<table cellpadding=5>
    <tr>
        <td bgcolor="#aaaaaa" align="center">
        <a href="{ $channel{link} }">{

            $image ? qq|<img src="$image" alt="$channel{title}">| : $channel{title}

         }</a><br>

        { $channel{description} }
        </td>
    </tr>

    <tr>
        <td bgcolor="#bbbbff" width=200><font size="-1">
{
        my $str;

        foreach my $item ( @items )
            {
            $str .= qq|<b><</b><a href="$$item{link}">$$item{title}</a><br><br>\n|;
            }

        $str;
        }       </font></td>
    </tr>
</td></tr></table>
</td></tr></table>
{% endhighlight %}

Once I have the templating system in place, I can change the presentation without affecting the logic of the code. If I decide to change the way I present the data, I only change the template. If I want plain text instead of HTML, I simply modify the template for the new format that I want, as I do in code listing <a href="#text" class="internal_link">Text Output</a>.

<a class="ref_name" name="text">Text output</a>
{% highlight perl %}
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
{% endhighlight %}

## Separating configuration

A good design also permits the script to adapt to a different environment. In code listing <a href="#old_code" class="internal_link">Hard-Coded Configuration</a>, I hard-coded the value of the output directory into the script which makes it fragile—if my home directory changes, my script breaks. Also, in code listing <a href="#use_template" class="internal_link">Using Templates</a>, I hard-coded the template file name, even though I can change the presentation by changing the template. I should be able to give each template a descriptive name rather than use the same name no matter the content.

Many freely-available scripts that I find on the internet require that the user edit a top portion of the script, or an included library that contains only configuration data. This approach requires the end user to know the basics of the programming language and to edit code—a mistake breaks the script. Bad configuration data can give unexpected results, but they should not break the program.

I can specify run-time configuration data in several ways, and I only show one of them. [Comprehensive Perl Archive Network (CPAN)](http://search.cpan.org) has several modules to parse different configuration file formats or command line arguments. Designers should choose an approach that fits their needs.

When I first started to routinely separate configuration data from my scripts, I tried several of the modules on CPAN, and settled on [ConfigReader::Simple](https://www.metacpan.org/pod/ConfigReader::Simple) which uses a simple key-value line-oriented format. I used it often enough that I started to send in my changes to Bek Oberin, the original author, then completely took over maintenance of the module.

Code listing <a href="#use_config" class="internal_link">Using External Config</a> adapts code listing <a href="#use-template" class="internal_link">use-template</a> to use [ConfigReader::Simple](https://www.metacpan.org/pod/ConfigReader::Simple). I create a new configuration object, then read values from the object. The module turns the names of the configuration keys into method names for easy access (although exotic key names that I cannot coerce into a Perl identifier require the `get()` method to access their value). Code listing <a href="#config_file" class="internal_link">External Config File</a> shows the configuration file.

<a class="ref_name" name="use_config">Using external config</a>
{% highlight perl %}
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

foreach my $url ( @files ) {
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
{% endhighlight %}

And here's the configuration file:

<a class="ref_name" name="config_file">External config file</a>
{% highlight text %}
base .
template rss-html.tmpl
files http://use.perl.org/useperl.rss
extension html
{% endhighlight %}

## Conclusion

I can reduce the size of my programs by separating the code from the presentation logic and the configuration information.  This separation makes the program more flexible and easier to adapt to new environments. Templates allow the output to show up in many forms without changes to the code, and configuration files allow me to change the way the program operates without affecting the code.  The [Text::Template](https://www.metacpan.org/pod/Text::Template) and [ConfigReader::Simple](https://www.metacpan.org/pod/ConfigReader::Simple) make this about as simple as it can be.

