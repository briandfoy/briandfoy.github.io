---
layout: post
title: Five Ways to Improve Your Perl Programming
categories: rescued-content
tags:
stopwords:
last_modified:
original_url: http://www.onlamp.com/pub/a/onlamp/2007/04/12/five-ways-to-improve-your-perl-programming.html
---

I recently finished writing [Mastering Perl](https://www.masteringperl.org), the third in the progression of Perl tutorial books from O'Reilly Media. In [Learning Perl](https://www.masteringperl.org), we wanted to show the 80 percent of Perl that most people use all of the time. That's good enough to write short script of around 100 lines or so. Next, in [Intermediate Perl](https://www.intermediateperl.com), we showed how to write reusable code that you could share with others, as well as how to write more complicated programs. When it came to writing [Mastering Perl](https://www.masteringperl.org), I considered all of the things that were usually missing from the Perl applications I saw in code reviews. What were Perl programmers missing?

<!--more-->

I thought about the life cycle of a typical Perl program. You write a quick hack on Friday afternoon to get something done and then leave for the weekend having accomplished your job, leaving the world a better place. Next Monday, you mention it to Adele, a colleague, and she wants to use it too, so you send her a copy. Another programmer, Bob, wants to use it too, but needs it to work a bit differently. He's a Java guy and doesn't know that much Perl. The change isn't that bad, so you make the modification and send it to him. In the meantime, Adele made her own modifications and passed it on to Charlie.

Pretty soon, your Friday afternoon hack has become mission critical software—how'd that ever happen? Besides your regular work, you're now supporting this script in all of its forms. Dave, the sysadmin, uses find and discovers 17 similar versions of your program–and that's just on one machine.

Now, instead of getting your own work done, you are helping everyone else get his or her work done. What seemed to be a timesaver for your immediate problem is now sucking away your time. I've been in a couple of situations like this when I was a beginning Perler, and along the way I've picked up some things to avoid these situations. You don't have to start every program with the five features I'll show, but once you start using a program for more than just a quick hack, these tips can save you a lot of time supporting your Perl application. Next to the headings, I've provided the corresponding chapter number from [Mastering Perl](https://www.masteringperl.org).

## Cleaning Up Your Code (Chapter 7)

Everyone writes sloppy code. It just goes with the territory. You start testing an idea, then replace half of that code with something else, and all the while the braces, indents, and idioms get more and more out of sync. You can't be bothered to worry about those with lunch coming up in a half hour! But now other people are looking at your code. It's time to impress them with your beautiful coding style! In addition, other people might have an easier time working with your code when it's easier to read.

`perltidy`, which you get by installing the [Perl::Tidy](https://metacpan.org/pod/Perl::Tidy) distribution, reformats your code to look consistent. Write a bunch of slop and run it through perltidy, and it comes out sparkling clean with things aligned and indented. By default it uses the style outlined in the [perlstyle](https://perldoc.perl.org/perlstyle) documentation, but it's also configurable. It puts the reformatted script in a new file so you don't lose the original.

I've intentionally obfuscated this word counting program, which I now want to reformat:

{% highlight perl %}
#!/usr/bin/perl
use strict;use warnings;my %Words;while(<>){chomp;s{^\s+}{};s{\s+$}{};
my $line=lc;my @words=split/\s+/,$line;foreach my $word(@words){
$word=~s{\W}{}g;next unless length $word;$Words{$word}++;}}foreach
my $word(sort{$Words{$b}<=>$Words{$a}}keys %Words){last
if $Words{$word}<10;printf"%5d	%s\n",$Words{$word},$word;}
{% endhighlight %}

`perltidy` turns it into a much more readable form:

{% highlight perl %}
% perltidy word_counter.pl     # output in word_counter.pl.tdy
% cat word_counter.pl.tdy
{% endhighlight %}

{% highlight perl %}
#!/usr/bin/perl
# yucky
use strict;
use warnings;
my %Words;
while (<>) {
	chomp;
	s{^\s+}{};
	s{\s+$}{};
	my $line = lc;
	my @words = split /\s+/, $line;
	foreach my $word (@words) {
		$word =~ s{\W}{}g;
		next unless length $word;
		$Words{$word}++;
	}
}
foreach my $word ( sort { $Words{$b} <=> $Words{$a} } keys %Words ) {
	last
	  if $Words{$word} < 10;
	printf "%5d  %s\n", $Words{$word}, $word;
}
{% endhighlight %}

Many editors have `perltidy` plug-ins too, such as emacs and vim, so you can apply it to a section of code as you edit. You don't have to tell anyone you got help with the formatting. Just say that you always code like that.

That's only for the format of the code, though–what about cleaning up the actual code? The perlcritic program, which comes with Jeffrey Thalhammer's [Perl::Critic](https://metacpan.org/pod/Perl::Critic) module, finds violations of Damian Conway's *Perl Best Practices*. You can set the severity level to get the granularity you want. Start with the worst offenses first, because it gets really picky in the end. The severity levels start at 5 for the worst violations, and go down to 1 for the very picky warnings:

{% highlight text %}
% perlcritic -severity 5 program.pl
{% endhighlight %}

You can then work your way down to the annoying nits (that you fix to make it seem like you're working between checkups on your World of Warcraft character). `perlcritic` is highly configurable too, and you can write your own subclasses to check things in your local coding policy, modify or turn off the policies already in place, or use third-party policy modules.

## Configuration (Chapter 11)

The cute hack you did Friday afternoon is now running all over the company, and maybe even some of your friends outside of work have heard about it and want it too, but with a couple of changes. Why can't everyone just use the same script?

The trick is to change the behavior of the script without changing the code, saving you the effort of editing the script every time a new person wants to use it.

Luckily, Perl comes with a number of ways to make your code configurable. For example, have you ever looked at Perl's `-s` switch (see the perlrun documentation)? It's the poor man's option parsing, although that's often enough to get started. It turns single-hyphen switches on the command line into package variables:

{% highlight perl %}
#!/usr/bin/perl -sw
use strict;

use vars qw( $a $abc );

print "The value of the -a switch is [$a]\n";
print "The value of the -abc switch is [$abc]\n";
{% endhighlight %}

Perl has several modules for more powerful parsing of command-line options (89 last time I counted). However, you can probably get everything you want from either [Getopt::Std](https://perldoc.perl.org/Getopt::Std) or [Getopt::Long](https://perldoc.perl.org/Getopt::Long), both of which come with Perl.

The [Config::Inifiles](https://metacpan.org/pod/Config::IniFiles) module handles the format that Windows made popular, and it gives values a scope:

{% highlight text %}
[Debugging]
;ComplainNeedlessly=1
ShowPodErrors=1

[Network]
email=brian.d.foy@gmail.com

[Book]
title=Mastering Perl
publisher=O'Reilly Media
author=brian d foy
{% endhighlight %}

Once you use [Config::Inifiles](https://metacpan.org/pod/Config::IniFiles) to load the configuration information, you use its val method to specify a section and value to access:

{% highlight perl %}
#!/usr/bin/perl
# config-ini.pl

use Config::IniFiles;

my $file = "mastering_perl.ini";

my $ini = Config::IniFiles->new(
	-file => $file
	) or die "Could not open $file!";

my $email = $ini->val( 'Network', 'email' );
my $author = $ini->val( 'Book', 'author' );

print "Kindly send complaints to $author ($email)\n";
{% endhighlight %}

There are several other Perl configuration modules, and there's probably already one for the format that you're using. Check out the Config:: namespace on the [Comprehensive Perl Archive Network](https://metacpan.org) for more details.

## Logging (Chapter 13)

I wish I had known how easy logging could be when I was starting to use Perl. It's even easier with Michael Schilli's port of log4j, the Java logging package, to Perl. With [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl), you can easily log messages of different priorities using almost any format you like, and send those messages to one or more destinations (or even no destination at all.) For instance, you can send very important messages to the pager of the operator on duty, but normal messages to a logfile.

The easy method takes no configuration. Here's the quick-n'-dirty example from the [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl) documentation:

{% highlight perl %}
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($ERROR);

DEBUG "This doesn't go anywhere";
ERROR "This gets logged";
{% endhighlight %}

You can configure the logger minutely, and you use the same methods to send messages. I won't go into the details of the configuration format here (there are more than enough examples in the links on the [log4perl project page](https://web.archive.org/web/20070429135708/http://log4perl.sourceforge.net/)), but you can define different loggers. This one is called root.logger.rhea.

{% highlight perl %}
use Log::Log4perl;

Log::Log4perl::init_and_watch('/etc/log4perl.conf',10);

$logger = Log::Log4perl->get_logger('root.logger.rhea');

$logger->debug('This is a debugging message');
$logger->info('This is just for information');
$logger->warn('etc');
$logger->error('..');
$logger->fatal('..');
{% endhighlight %}

Inside your program, that's all you have to do. When you want to see the debugging messages, you change the configuration to do something with the messages sent to the debug method. Otherwise, the logger ignores those. No more commenting out those `print STDERR` statements. [Log::Log4perl](https://metacpan.org/pod/Log::Log4perl) can even check the configuration file periodically at an interval you define, so you can change the logging behavior on the fly. You don't have to take down your application to increase the logging level it is using.

## Persistence (Chapter 14)

Persistence lets your program pick up where it left off, among other things. You can save data in one run of a program and use it in another run of the same program, or even in a different program. You can even use the data with a different program on a different machine. Unfortunately, there isn't a good way to re-create sockets, filehandles, or other such features, but that's life.

The [Storable](https://perldoc.perl.org/Storable) module, which comes with Perl, can "freeze" data in a machine-readable and platform-neutral manner. The result of `nfreeze` is a string. You can send that over a socket, store it in a file, or anything else you can do with a string. Once you want it back, you thaw it:

{% highlight perl %}
#!/usr/bin/perl
# storable-thaw.pl

use Business::ISBN;
use Data::Dumper;
use Storable qw(nfreeze thaw);

my $isbn = Business::ISBN->new( '0596102062' );

my $frozen = eval { nfreeze( $isbn ) };
if( $@ ) { warn "Serious error from Storable: $@" }

my $other_isbn = thaw( $frozen );

print "The ISBN is ", $other_isbn->as_string, "\n";
{% endhighlight %}

The [DBM::Deep](https://metacpan.org/pod/DBM::Deep) module makes disk-based data available to your program as a regular Perl data structure. You create the database with [DBM::Deep](https://metacpan.org/pod/DBM::Deep), which returns a hash reference. You treat that as a normal hash reference and [DBM::Deep](https://metacpan.org/pod/DBM::Deep) stores or fetches the data on disk. The data sticks around until you delete the file:

{% highlight perl %}
use DBM::Deep;

my $isbns = DBM::Deep->new( "isbns.db" );
if( $isbns->error ) {
	warn "Could not create database: " . $isbns->error . "\n";
	}

$isbns->{'0596102062'} = 'Intermediate Perl';
{% endhighlight %}

## Subclasses for Applications (Chapter 18)

For the past couple of years, I've been writing all of my Perl programs as modulinos, or modules that can act like programs depending on how I call them. You can look at my Perlmonks article, ["How a script becomes a module,"](http://www.perlmonks.org/?node_id=396759) for more details . If I call it as a program, it runs like a program, but if I use it as a module, it loads its subroutines without running.

In C or Java (among other languages), you use a `main()` routine to specify where the program should start. Perl, being the "do what I mean" sort of language it is, simply treats everything in the file that isn't a routine as the main program. In C, you have to use a `main` subroutine that the program automatically calls for you when you run it:

{% highlight perl %}
#include <stdio.h>

int main( void )
	{
	printf( "Hello World!\n" );
	return(1);
	}
{% endhighlight %}

In Perl, you don't need to do all that extra typing. Perl wants to get you to the solution as soon as possible, so it does away with `main` by wrapping a virtual routine around the entire file:

{% highlight perl %}
#!/usr/bin/perl

print "Hello World!\n";
{% endhighlight %}

You could do a bit more work to get it back to the explicit definition of a `main` subroutine, which you then have to call yourself to get the program to do anything:

{% highlight perl %}
#!/usr/bin/perl

main(); # executes at run-time

sub main
	{
	print "Hello World!\n";
	}
{% endhighlight %}

Here's where it starts to get interesting. When you put all the functionality into subroutines, you've really written a library (or a class). You can make the function look more like object-oriented code because you're already thinking about letting other users override parts of it through a subclass. Thinking that, you only execute the main subroutine when you call the file as a program directly, and not when you use it like a module. The `caller` function takes care of that:

{% highlight perl %}
package Local::MyProgram;

__PACKAGE__->main() unless caller; # executes at run-time, unless used as module

sub main
	{
	my $self = shift;

	print $self->string, "\n";
	}

sub string
	{
	"Hello World!"
	}
{% endhighlight %}

When Adele wants to change something in the program, she doesn't have to edit the source. She just subclasses your module and overrides the parts that she wants to change:

{% highlight perl %}
package Local::AdeleProgram;
use base qw(Local::MyProgram);

__PACKAGE__->main() unless caller; # executes at run-time, unless used as module

sub string
	{
	"Guten Tag!"
	}
{% endhighlight %}

Besides this benefit, you also have an easier time testing your program because you've broken it into distinct parts that lend themselves to unit testing. You can test the parts without running the entire program.
