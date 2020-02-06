---
layout: post
title: The Façade Design Pattern
categories:
tags:
stopwords:
last_modified:
original_url:
---

[% META
	author  = 'brian d foy'
	title   = 'The Fa&ccedil;ade Design Pattern'
	tags    = 'perl design_patterns facade'
	issue   = '0.4'
%]

[% PROCESS article_header %]

<p class="abstract">
The Fa&ccedil;ade design pattern provides an easy-to-use interface to an
otherwise complicated collection of interfaces or subsystems.  It
makes things easier by hiding the details of its implementation.
</p>

<h2>Introduction</h2>

<p class="full_text">
The Fa&ccedil;ade design pattern connects the code we write for
applications, which do specific tasks such as creating a report, and
the low level implementation that handles the details such as reading
file, interacting with the network, and creating output.  The
fa&ccedil;ade is an interface that an application can use to get
things done without worrying about the details.  The fa&ccedil;ade
decouples these layers so that they don't depend on each other, which
makes each easier to develop, easier to use, and promotes code re-use.
</p>

<p class="full_text">
I can use this design pattern to deal with a complex system that
already exists, or one that I want to make from scratch. Several Perl
modules available on the [% te.external_url('http://search.cpan.org',
'Comprehensive Perl Archive Network (CPAN)' ) %] represent
fa&ccedil;ades, even if they do not admit it.
</p>

<h2>Illustration of use</h2>

<p class="full_text">
To request a simple file from a web site, I have to create a
connection to the web site, request the resource using a proper
HyperText Transfer Protocol (HTTP) request, receive the HTTP response,
parse the response, and finally handle the data.  I have to do much
more work if I want to handle common web features like cookies, forms,
and caching. If I want to fetch a resource from an FTP server instead
of a web server, I need to handle a completely different protocol.
</p>

<p class="full_text">
If I look at this problem, some immediate objects present themselves:
connection, request, response, and resource.  However, I only want to
fetch the resource and continue on with my real work rather than deal
with myriad objects to do something that is logically so simple. To
code this myself in a reasonable amount of time might take a couple of
screenfuls of code depending on how careful I am and how many features
I decide to support.
</p>

<p class="full_text">
The [% te.cpan_module( 'LWP' ) %] module (Library for WWW in Perl)
provides a fa&ccedil;ade for doing all of these things.  I tell [%
te.cpan_module( 'LWP' ) %] to fetch a resource and it does the rest,
including all of the protocol-specific details for HTTP, FTP, or any
other protocol that [% te.cpan_module( 'LWP' ) %] understands.
</p>

<p class="full_text">
I use [% te.cpan_module( 'LWP::Simple' ) %] which makes fetching a
web resource as simple as it can get. I do not have to specify the
protocol, the connection method, or parse the response. Indeed, if I
know the URL, and I can fetch the resource:
</p>

<pre class="code">
use LWP::Simple qw(get);

my $url = 'http://www.perl.org';
my $data = get( $url );
</pre>

<p class="full_text">
The [% te.cpan_module( 'LWP::Simple' ) %] module is a
fa&ccedil;ade&mdash;it provides a simple interface that unifies
protocol, network, and parsing aspects of the problem so that I do one
thing&mdash;fetch the resource.  If someone changes [% te.cpan_module( 'LWP' ) %] or underlying
implementations, I do not have to change my script and I still benefit
from the improvement.
</p>

<h2>Focus on the task</h2>

<p class="full_text">
A fa&ccedil;ade restricts the functionality, and thus the complexity,
of a system by creating specialized interfaces for specific tasks. The
[% te.cpan_module( 'HTML::Parser' ) %] module is a base class, so the
programmer must write a subclass that tells the parser what to do and
when to do it, but it does not perform a specific task other than the
parsing, such as syntax checking or data extraction.  However, as in
my [% te.cpan_module( 'LWP' ) %] example, I simply want to complete a single, logical
task&mdash;not program [% te.cpan_module( 'HTML::Parser' ) %]
subclasses.  In reality, I like writing [% te.cpan_module(
'HTML::Parser' ) %] subclasses, but not everyone with whom I work
does, so I can create fa&ccedil;ades for them.
</p>

<p class="full_text">
Fa&ccedil;ades to [% te.cpan_module( 'HTML::Parser' ) %] do small,
common tasks while they hide all of the complexity behind-the-scenes.
I am the only one in the programming team who has to understand [%
te.cpan_module( 'HTML::Parser' ) %] so I can create much simpler
interfaces for the rest of the team. They should not have to write an
entire subclass if they only want to extract the links of an HTML
document, for instance.  Simple things should be simple.
</p>

<p class="full_text">
If I wanted to extract references (which most people call "links")
from an HTML document, I can use the [% te.cpan_module(
'HTML::LinkExtor' ) %] module. It handles most of the complexity for
me while still giving me a reasonable amount of flexibility through a
callback mechanism. I use a callback to extract all of the anchor
references (the <code class="inline">HREF</code> attribute from the
<code class="inline">A</code> tag).  I still have to do a bit of the
dirty work since [% te.cpan_module( 'HTML::LinkExtor' ) %] passes the
tag name and a list of attribute-value pairs to <code
class="inline">call_back()</code>.  I still have to know the details
of the implementation of [% te.cpan_module( 'HTML::LinkExtor' ) %] to
work with it.
</p>

<pre class="code">
require HTML::LinkExtor;

use vars qw( @links );

sub call_back
	{
	my( $tag, %attr ) = @_;
	return unless exists $attr{href};

	push @links, $attr{href};
	}

my $parser = HTML::LinkExtor->new( \&call_back, "http://www.example.com" );

$parser->parse_file("index.html");
</pre>


<p class="full_text">
I can sacrifice flexibility for convenience by using a simpler
Fa&ccedil;ade, [% te.cpan_module( 'HTML::SimpleLinkExtor' ) %], which
simply returns the references but does not have a callback mechanism.
In the next program, I do the same thing that I do with [%
te.cpan_module( 'HTML::LinkExtor' ) %] example in the previous
program, and my fellow programmers do not know how [% te.cpan_module(
'HTML::SimpleLinkExtor' ) %] does it.  They do not need to worry about
writing the callback function. They simply get the result that they
need:
</p>

<pre class="code">
use HTML::SimpleLinkExtor;

my $extor = HTML::SimpleLinkExtor->new( "http://www.example.com" );
$extor->parse_file("index.html");

my @links = $extor->href;
</pre>


<p class="full_text">
If I want to do something different with [% te.cpan_module(
'HTML::LinkExtor' ) %], like extracting URLs from tags with <code class="inline">SRC</code>
attributes, I have to modify the <code
class="inline">call_back()</code> subroutine, or I can  use a method
from [% te.cpan_module( 'HTML::SimpleLinkExtor' ) %], a simpler
fa&ccedil;ade, like I do in this program:
</p>

<pre class="code">
use HTML::SimpleLinkExtor;

my $extor = HTML::SimpleLinkExtor->new( "http://www.example.com" );
$extor->parse_file("index.html");

my @all_links = $extor->links;
</pre>


<p class="full_text">
In both of these examples, the fa&ccedil;ades allows programmers to focus on
the task&mdash;extracting links&mdash;rather than on the programming.  Since
each fa&ccedil;ade provides a task-oriented interface, programmers do not spend time
thinking about how the task should be completed, just as they do not
think too much about HTTP or TCP/IP when they use their web browser to visit
their favorite web pages.
</p>

<p class="full_text">
The [% te.cpan_module( 'HTML::SimpleLinkExtor' ) %] works for most uses, but also cannot handle
complex cases at all.  Reduced flexibility is the major  consequences
of a fa&ccedil;ade. The more restrictive fa&ccedil;ades are easier to use at
the cost of flexibility. [% te.cpan_module( 'HTML::LinkExtor' ) %] has more flexibility, but
is a bit more complicated and I have to do more work to use it. The
more flexible interfaces can handle more situations and respond to
special cases at the cost of simplicity.  Specific situations require
different levels of flexibility and simplicity, and as a result,
different fa&ccedil;ades, if any at all.
</p>

<h2>Fa&ccedil;ades promote reusability</h2>

<p class="full_text">
Many programmers already use a sort of fa&ccedil;ade, although they typically call
it a subroutine. Subroutines did not always exist, and they represented
a pattern of their own at one time.  Today most languages take subroutines
for granted even though they are the foundation of re-usable code.
</p>

<p class="full_text">
The abstract nature of the subroutine allows programmers not only to
group program statements into logical operations behind a subroutine
name, like the fa&ccedil;ades in the previous section, but they also allow
programmers to reuse that group of program statements without
repeatedly typing them.  Programmers can reuse and share collections
of subroutines that they group in libraries which can form the
interface of a fa&ccedil;ade.
</p>

<p class="full_text">
What if I want to check the status of a web resource? If I went
through all of the steps myself every time I needed to do this, I
would have to create an HTTP request, connect to the web server,
receive the response, parse the response, and check the response code
against known status codes.  Later, once I have coded this four or
five lines of [% te.cpan_module( 'LWP' ) %] code (or 15 to 20 lines of socket code) in all of my
applications that need it, I will probably discover that I need to fix
some of the code and to make the change in several places.  If I
put all of that code in a subroutine that all of my applications can
share, I only have to fix things in one place and programmers using
my module do not need to do anything at all.
</p>

<p class="full_text">
I first ran into the link validation problem when I created a
user-configurable directory of internet resources which I wanted to
validate every day. I wanted to make sure that the links in the
directories actually led to a web page rather than the annoying <code class="inline">404
Not Found</code> server error.  I also wanted to catch dead links before a
customer added them to his directory.  I needed to do the same simple
task in several applications, and the few lines of repeated code in each
application seemed so innocent that I missed the obvious refactoring
potential.
</p>

<p class="full_text">
With a couple of customers using the service, I did not notice
anything amiss with my validation code.  It caught dead links and did
not have false positives. With tens of users and a couple hundred
thousand resources to validate, I discovered that not all web servers
respond in the same way to certain types of HTTP requests, and that
some servers even had little known bugs.  One notorious server
returned an HTTP error for any HEAD request\footnote{ Every HTTP
request specifies a method.  A HEAD request asks the server for the
resource's meta data, but not the resource itself so it does not have
to download potentially large amounts of data.}, so I had to program
some special cases.  The task which I thought was simple grew much
more complex, but I wanted to work on the level of a "ping"&mdash;a
simple "yes" or "no" answer. Tests on small data sets did not
reveal any problems in the parts per ten thousand range, but things
quickly got out of hand after that.
</p>

<p class="full_text">
My refactored solution was a fa&ccedil;ade.  At the application level I did
not care about server eccentricities, work-arounds for HTTP
non-compliance, or most error recovery.  I simply wanted to know
if the URL actually pointed to something.
I created a glorified subroutine, gave it a module name, and used it
whenever I needed an HTTP response code. I uploaded the module to [% te.external_url('http://search.cpan.org', 'CPAN' ) %]
as [% te.cpan_module( 'HTTP::SimpleLinkChecker' ) %].  The next program
shows the entire fa&ccedil;ade&mdash;a single function behind which all of the
real work takes place.  The fa&ccedil;ade takes care of all of the details,
including all of my accrued knowledge about specific server behaviors,
so that it could recognize possible problems and double check
errors to a HEAD request by actually downloading the resource.
</p>

<pre class="code">
use HTTP::SimpleLinkChecker qw(check_link);

my $code = check_link("http://www.example.com");
</pre>

<p class="full_text">
If someone uses this module and decides to upgrade to a newer version when
I release one, he can get the benefit of all of my improvements and
enhancements without changing any of his code, while at the same time,
he benefits from any enhancements to its [% te.cpan_module( 'LWP' ) %] infrastructure
even if he does not use the latest version of [% te.cpan_module( 'HTTP::SimpleLinkChecker' ) %].
This <i>loose coupling</i> makes a programmer's life much easier since
the fa&ccedil;ade hides changes to the underlying system.  Changes in other
parts of the system have little or no maintenance consequences on the
programmer's application.  Since the fa&ccedil;ade depends very loosely on
the underlying implementation, I can distribute it separately.  Other
people do not need a specific version of [% te.cpan_module( 'LWP' ) %].  I make it easy for
people to use so that they will use it rather than going through the
pain and suffering that I did.
</p>

<h2>Fa&ccedil;ades as objects</h2>

<p class="full_text">
A fa&ccedil;ade object acts as the gatekeeper of all method calls for the
underlying implementation.  Each method may in-turn act upon
additional objects or classes to perform its task, but the programmer
does not have to know anything about that. The fa&ccedil;ade object knows
which underlying objects (Delegation represents another sort of
pattern with which the Fa&ccedil;ade pattern might collaborate).  Many
patterns work in concert with other patterns, and although I do not
discuss Delegation here, you can read about it in the documentation of
Damian Conway's [% te.cpan_module( 'Class::Delegation' ) %] or Kurt Starsinic's
[% te.cpan_module( 'Class::Delegate' ) %].
</p>

<p class="full_text">
If I want to parse an HTML page to extract various things from the
&lt;HEAD&gt; as well as some of the links, I can use [%
te.cpan_module( 'HTML::HeadParser' ) %] and [% te.cpan_module(
'HTML::LinkExtor' ) %], but at the application level that is too much
detail. I am stuck thinking about HTML parsing when I should be
getting my real work done. I can also create my own HTML fa&ccedil;ade
that hides the two modules&mdash;or any other
implementation&mdash;that I use.
</p>

<p class="full_text">
In this next program, I wrap the interfaces to [% te.cpan_module(
'HTML::HeadParser' ) %] and [% te.cpan_module( 'HTML::SimpleLinkExtor'
) %] in a single interface so I only have to deal with all of them in
my application:
</p>

<pre class="code">
package HTML::SimpleExtractor;

require HTML::HeadParser;
require HTML::SimpleLinkExtor;

sub new
	{
	my( $class, $url ) = @_;

	return unless $data = LWP::Simple->get($url);

	bless \$data, $class;
	}

sub title
	{
	return HTML::HeadParser->new()->parse($$_[0])->header('Title');
	}

sub links
	{
	HTML::SimpleLinkExtor->new()->parse($$_[0])->links;
	}

1;

__END__
</pre>


<p class="full_text">
Once I have my fa&ccedil;ade in place, I can write applications that I
do not need to couple to any particular module.  Since the next
program does not know that I used [% te.cpan_module(
'HTML::HeadParser' ) %] it does not need to change if I decide to use
something different for that portion of the task. The fa&ccedil;ade
hides the changes:
</p>

<pre class="code">
#!/usr/bin/perl -w
use strict;

use HTML::SimpleExtractor;

my $html = HTML::SimpleExtractor->new('http://www.example.com');

my $title = $html->title;
my $links = $html->links;

$" = "\n\t";

print "$title\n\t@links\n";

__END__
</pre>


<p class="full_text">
In this case, I can change any of the details involved with fetching
and parsing the HTML to something smarter and more efficient later.
This can be quite expedient when the responsibility for the fa&ccedil;ade and
the application belong to different programmers or teams, or when it
would take much longer to fully implement the fa&ccedil;ade than to finish
any of the applications.  I can create something that works today even
if it is not the best implementation then I can incrementally change
and improve it as time allows.
</p>

<p class="full_text">
Even though my example is very simple-minded, I get the job done. I
hide the two modules behind the fa&ccedil;ade, and I can immediately
use [% te.cpan_module( 'HTML::SimpleExtractor' ) %] in my
applications. Once I have more time to devote to the module, I can
change how it does its job while all of my applications that use it
stay the same.  None of my application code depends on the specifics
of the implementation, and may not even know that the implementation
has changed.
</p>

<h2>Ad hoc fa&ccedil;ades</h2>

<p class="full_text">
Most frequently the work programmers seem to do involves an
established base code that has entrenched itself into the work flow of
their organizations, and the further away they are from the creation
time of this code, the more difficult it is to maintain or learn,
especially if it is as sparsely documented as most such code I have
seen.  New team members can have an especially difficult time learning
a byzantine code base which ends up strangling the work flow.
</p>

<p class="full_text">
A fa&ccedil;ade can gradually fix this without an immediate or complete
rewrite of the old code. Since a fa&ccedil;ade provides a unified interface
to an complex, underlying system, it can also hide years of
improvements, multitudes of styles, and unforeseen problems in the
original code. A new interface that connects various legacy subsystems
of the old code provides a way for programmers to replace the
functionality later while creating new applications with the new
interface. New programmers do not need to learn the entire system
if one of the old salt programmers create a fa&ccedil;ade for them.
</p>

<p class="full_text">
As more and more applications use the new fa&ccedil;ade, and
hopefully fewer and fewer applications use the old code base
as programmers gradually replace them, the application base moves
towards something much more maintainable since the
application code does not rely on the underlying fa&ccedil;ade
implementation.  Programmers can re-implement portions of
that at their leisure without breaking applications.
</p>

<p class="full_text">
Typically, these sorts of fa&ccedil;ades pull together a particular way of
doing things in a particular context such as a special business need
or workflow.  I might have several closely related applications, and
as I develop them in parallel parts of them start to look the same
because they do similar things and use the same resources. Such an
application's first few lines might look this, where I immediately pull
in several modules:
</p>

<pre class="code">
#!/usr/bin/perl -w
use strict;

require cgi-lib.pl;
use DBI;
use HTML::Parser;
use HTML::TreeBuilder;
use LWP;
use Text::Template;

# my Perl implementation here
__END__
</pre>

<p class="full_text">
I can refactor those applications and use a fa&ccedil;ade to contain
all of the details about how I do the work. I want the fa&ccedil;ade
to represent the task, not the method. If I use certain modules by
local policy, then I only have to enforce that policy behind the
fa&ccedil;ade rather than in every application.  For this suite of
hypothetical applications I create a module I call <code class="inline">Tsunami</code> (a deluge
of code perhaps)&mdash;the name I give my fictional product. Instead
of all of the modules I used in the previous program, including the
notoriously old <code class="inline">cgi-lib.pl</code>, now I only have to use one module:
</p>

<pre class="code">
#!/usr/bin/perl

use Tsunami;

my $wave = Tsunami->new(...);

$wave->fetch('http://www.example.com');

my $title = $wave->title();

my $txt   = $wave->as_text();

print $txt;

__END__
</pre>

<p class="full_text">
This also means that other team members, by policy if not practice,
only use one module too. If, for some reason, policy changes so that
<code class="inline">Tsunami</code> should use [% te.cpan_module(
'CGI.pm' ) %] instead of <code class="inline">cgi-lib.pl</code>, I
only have to change one file. If I improve <code
class="inline">Tsunami</code>, everybody benefits.
</p>

<h2>A priori fa&ccedil;ades</h2>

<p class="full_text">
If I have the luxury of prior thought and planning, and I know
that some parts of the system resist planning, I can use a
fa&ccedil;ade to present an application programming interface, and
build up the rest of the stuff as I find out more and more about
the problem.
</p>

<p class="full_text">
Once I go through the object-oriented analysis process and have
identified the objects, I can also identify the different ways
that the programmers will use those objects.  For instance, if
I want to create an application to send messages between two
computers, I know that I need a network object and a message
object.  These objects make it easy to deal with related sets of
information my program must maintain.
</p>

<p class="full_text">
I want to create a application that can "chat" with another, meaning
that the two applications can send messages back and forth between
each other.  I can use a fa&ccedil;ade to represent a simple
interface, with <code class="inline">send()</code> and <code
class="inline">receive()</code> methods.  I might need more later, but
in this contrived example I pretend that I do not know everything this
application might have to do because the specifications are fuzzy and
the scope of the problem scares the project planners (in this case,
me).
</p>

<p class="full_text">
When I start programming, nothing works because I have not written any
code to represent the objects, and at that level I need all of the
objects for the other ones to do their part.  Since a fa&ccedil;ade
hides these objects, it also hides their absence as well.  I can get
something in place quickly, just as in my [% te.cpan_module(
'HTML::SimpleExtractor' ) %] example, and be on my way.
</p>

<p class="full_text">
As with all new programming I start, the first thing I do is write a
test suite.  Since I have no objects to test, all of the tests should
fail, which is my first real test&mdash;tests fail when they should.
</p>

<p class="full_text">
I create my module workspace with <code class="inline">h2xs</code>,
which creates a <code class="inline">t</code> directory for test
files. In my test file I add a check for that:
</p>

<pre class="code">
eval {
     Chat->send('Come here Mr. Watson, I need you');
     };
print $@ ? 'not ' : '', "ok\n";
</pre>

<p class="full_text">
Since the <code class="inline">send()</code> method should die with
an internal error message, I check to see that it does. So far the
module <code class="inline">Chat.pm</code> is the template that <code
class="inline">h2xs</code> created for me.
</p>

<p class="full_text">
One step beyond that I want to test that the parts of the interface
exist, so I need an interface.  I need to create the Chat.pm module.
In this program, I have a minimal module which has one class method,
<code class="inline">send()</code>.  I have not really implemented it
yet, so I call the <code class="inline">die()</code> function if a
program calls the method:
</p>

<pre class="code">
package Chat;

use vars qw( $UNIMPLEMENTED );
$UNIMPLEMENTED = "Not implemented!";

sub send    { die $UNIMPLEMENTED }

1;
</pre>


<p class="full_text">
I expect the test from code listing \ref{send-test} to fail because
<code class="inline">send()</code> calls the <code
class="inline">die()</code> function, but I can modify the test to see
if I get the right message in <code class="inline">$@</code>.  In this
program, the test succeeds even though the <code
class="inline">send()</code> uses <code class="inline">die()</code>,
since that is the behavior I expect&mdash;part of the interface now
exists.
</p>

<pre class="code">
eval {
     Chat->send('Come here Mr. Watson, I need you');
     };
print $@ eq $Chat::UNIMPLEMENTED ? '' : 'not ', "ok\n";
</pre>


<p class="full_text">
A similar test for an undefined method should give me a different sort
of error.  Next, I test to see if the <code
class="inline">receive()</code> method exists, and if it does, then
something is wrong.  I have not defined <code
class="inline">receive()</code> yet.
</p>

<pre class="code">
eval {
     Chat->receive('I am on my way');
     };
print $@ ? '' : 'not ', "ok\n";
</pre>


<p class="full_text">
Although I still do not have any objects, I can change my <code
class="inline">send()</code> method to take two arguments, a message
and a recipient argument, although I have not said anything about what
they are.  I have, however, made progress on the interface even though
I still do not have anything to actually do the work.
</p>

<pre class="code">
sub send
	{
	my( $class, $message, $recipient ) = @_;

	return unless defined $message and defined $recipient;

	return 1;
	}
</pre>

<p class="full_text">
My test for <code class="inline">send()</code> changes to make sure it
does the right thing for different argument lists. I add three tests
for different numbers of arguments.  Only the call to <code
class="inline">send()</code> with the right number of arguments should
succeed.  The other tests check for failure when <code
class="inline">send()</code> should fail.
</p>

<pre class="code">
# should fail -- no recipient
eval {
	Chat->send('Come here Mr. Watson, I need you');
	};
defined $@ ? not_ok() : ok();

# should fail -- no message or recipient
eval {
	Chat->send();
	};
defined $@ ? not_ok() : ok();

# should succeed
eval {
	Chat->send('Come here', 'Mr. Watson');
	};
defined $@ ? not_ok() : ok();
</pre>


<p class="full_text">
This process continues as I add more to the interface and as I
implement the objects that will actually do the work.  In the mean
time, I have done useful work that has gotten to towards my goal, and
I have created a suite of tests to help me along the way.  The
implementation does not concern me too much at this point because I
can easily change it later.  The rest of the project depends on
the fa&ccedil;ade. Only the fa&ccedil;ade knows about the implementation,
so everything else, including applications and tests, do not have to
wait for the complete implementation to start work.
</p>

<p class="full_text">
Once I progress far enough to have <code class="inline">Message</code>
and <code class="inline">Recipient</code> objects, if I decide I need
them, I can change my <code class="inline">send()</code> method to use
them. I could check each argument to ensure that they belong to the
proper class.  Each object automatically inherits the <code
class="inline">isa()</code> method from <code
class="inline">UNIVERSAL</code>, the base class of all Perl classes,
and returns true if the object is an instance of the class named as
the argument, or a class that inherits from it. All of my tests still
do the same thing:
</p>

<pre class="code">
sub send
	{
	my( $class, $message, $recipient ) = @_;

	return unless $message->isa('Chat::Message') and
		$recipient->isa('Chat::Recipient');

	return 1;
	}
</pre>


<p class="full_text">
If later I change the objects or their behavior, I have not wasted too
much time.  My fa&ccedil;ade and its tests still work. Any application I have
written does not need to change significantly.  The fa&ccedil;ade handles the
details and the interactions between the various objects. At the same
time, other programmers can start to use the interface to create
applications.  The programs will not work until everything is
complete, of course, but the programmers have a jump start on the
process because they can code and test before everything is in place.
They essentially work in parallel, instead of serially, with the
programmers implementing the objects and the fa&ccedil;ade.  The creation of
classes is not a work flow bottleneck since the fa&ccedil;ade decouples
the application and lower level implementations.
</p>

<h2>Perl modules which are fa&ccedil;ades</h2>

<p class="full_text">
Several modules exhibit a Fa&ccedil;ade design pattern, although their
authors may not have thought about design patterns or fa&ccedil;ades in
particular.  A good design stays out of the way and does not draw
attention to itself.  A good fa&ccedil;ade keeps most of us truly ignorant
about whatever is behind it.
</p>

<p class="full_text">
Most of the modules on CPAN with "Simple" in their name use the
fa&ccedil;ade design pattern, including [% te.cpan_module( 'LWP::Simple' ) %], [% te.cpan_module( 'HTTP::SimpleLinkChecker' ) %],
and [% te.cpan_module( 'HTML::SimpleLinkExtor' ) %] which I used for examples.
</p>

	<h3>LWP</h3>

<p class="full_text">
The [% te.cpan_module( 'LWP' ) %] family of modules act as a fa&ccedil;ade with a unified interface to
various network protocols including HTTP, HTTPS, FTP, NNTP, and even
the local filesystem.  It can handle some protocol specific details
too.
</p>

	<h3>DBI</h3>

<p class="full_text">
The [% te.cpan_module( 'DBI' ) %] module provide a simple interface to several database servers
or file formats.  I can query several types of server or file formats
with the same interface while DBI&mdash;actually the appropriate
DBD&mdash;handles the connection, query, response, and other tasks.  The
[% te.cpan_module( 'DBI' ) %] interface even allows me to  change the database server behind the
scenes (from SQL Server to postgresql, perhaps) without changing much
more than the <code class="inline">DBI-&gt;connect</code> statement.  I do not need to worry about
the connection implementation, protocols, or data format.
</p>

	<h3>Tied classes</h3>

<p class="full_text">
Perl's <code class="inline">tie</code> functionality is a type of fa&ccedil;ade.  What looks
like a normal Perl scalar, array, or hash stands-in for a
possibly complex object behind the scenes.  The most
impressive use of this sort of fa&ccedil;ade, in my opinion, is the
[% te.cpan_module( 'Win32::TieRegistry' ) %] module, which represents the quite
complex Microsoft Windows registry as a tied hash.  This
module even sees the following as equivalent:
</p>

<pre class="code">
$Registry->{'LMachine/Software/Perl'}
$Registry->{'LMachine'}->{'Software'}->{'Perl'}
</pre>

<p class="full_text">
I do not have to know very much, if anything, about the Registry.  I
do need to know how I name a key, but I do not need to know how it is
stored or accessed since I already understand Perl hashes and
references.  This module takes what I already know and lets me use it
instead of learning low-level vendor interfaces.
</p>

<p class="full_text">
This fa&ccedil;ade also allows me to develop on foreign platforms. I can
reimplement the code so that I can have a Unix version of the Windows
registry, for instance.  This fake version of the Registry allows me
to use all of the great tools and setups I already have on my unix
accounts while targeting Windows platforms.  If my application had to
use explicit calls to the Windows programming interface I would not be
able to do that.
</p>

<h2>Conclusion</h2>

<p class="full_text">
The Fa&ccedil;ade design pattern provides a simple interface to a complex
collection of modules or code. The Fa&ccedil;ade design pattern removes the
details of the task from the application layer which allows me to
focus on the task rather than the details, as well as allowing me to
change implementations without changing my applications.  This makes
code more modular, maintainable, and easier to use.  It decouples
application code from the low level implementation which allows
parallel development at different levels.
</p>

<h2>References</h2>

<p class="full_text">
You can read more about design patterns in <i>Design Patterns</i>,
Erich Gamma, Richard Helm, Ralph Johnson, Jon Vlissides, Addison
Wesley, 1995.
</p>

<p class="full_text">
Test suites for Perl modules usually use [% te.cpan_module(
'Test::Harness' ) %], although I find actual test files easier to
understand.  I have some simple tests in the test.pl of [%
te.cpan_module( 'HTML::SimpleLinkExtractor' ) %] distribution, or the
<code class="inline">t</code> directory of [% te.cpan_module( 'HTTP::SimpleLinkChecker' ) %].
</p>

<p class="full_text">
All real modules in this article are in the [%
te.external_url('http://search.cpan.org', 'CPAN' ) %].
</p>

<h2>About the author</h2>

<p class="full_text">
brian d foy is the publisher of <i class="title tpr">The Perl
Review</i>, and the author of several modules available on [%
te.external_url('http://search.cpan.org', 'CPAN' ) %], including [%
te.cpan_module( 'HTML::SimpleLinkExtor' ) %] and [% te.cpan_module(
'HTTP::SimpleLinkChecker' ) %]. He teaches and writes on Perl topics
in between doing real work.
</p>

[% PROCESS footer %]

