---
layout: post
title: The Façade Design Pattern
categories: programming
tags: perl rescued-content the-perl-review design-patterns
stopwords: arounds Starsinic's Vlissides hoc
last_modified:
original_url:
---

*I originally published this in The Perl Review 0.4, July 2002*

The Façade design pattern provides an easy-to-use interface to an otherwise complicated collection of interfaces or subsystems. It makes things easier by hiding the details of its implementation.

<!--more-->

## Introduction

The Façade design pattern connects the code we write for applications, which do specific tasks such as creating a report, and the low level implementation that handles the details such as reading file, interacting with the network, and creating output. The façade is an interface that an application can use to get things done without worrying about the details. The façade decouples these layers so that they don't depend on each other, which makes each easier to develop, easier to use, and promotes code re-use.

I can use this design pattern to deal with a complex system that already exists, or one that I want to make from scratch. Several Perl modules available on the [Comprehensive Perl Archive Network (CPAN)](http://search.cpan.org) represent façades, even if they do not admit it.

## Illustration of use

To request a simple file from a web site, I have to create a connection to the web site, request the resource using a proper HyperText Transfer Protocol (HTTP) request, receive the HTTP response, parse the response, and finally handle the data. I have to do much more work if I want to handle common web features like cookies, forms, and caching. If I want to fetch a resource from an FTP server instead of a web server, I need to handle a completely different protocol.

If I look at this problem, some immediate objects present themselves: connection, request, response, and resource. However, I only want to fetch the resource and continue on with my real work rather than deal with myriad objects to do something that is logically so simple. To code this myself in a reasonable amount of time might take a couple of screenfuls of code depending on how careful I am and how many features I decide to support.

The [LWP](https://metacpan.org/pod/LWP) module (Library for WWW in Perl) provides a façade for doing all of these things. I tell [LWP](https://metacpan.org/pod/LWP) to fetch a resource and it does the rest, including all of the protocol-specific details for HTTP, FTP, or any other protocol that [LWP](https://metacpan.org/pod/LWP) understands.

I use [LWP::Simple](https://metacpan.org/pod/LWP::Simple) which makes fetching a web resource as simple as it can get. I do not have to specify the protocol, the connection method, or parse the response. Indeed, if I know the URL, and I can fetch the resource:

{% highlight perl %}
use LWP::Simple qw(get);

my $url = 'http://www.perl.org';
my $data = get( $url );
{% endhighlight %}

The [LWP::Simple](https://metacpan.org/pod/LWP::Simple) module is a façade—it provides a simple interface that unifies protocol, network, and parsing aspects of the problem so that I do one thing—fetch the resource. If someone changes [LWP](https://metacpan.org/pod/LWP) or underlying implementations, I do not have to change my script and I still benefit from the improvement.

## Focus on the task

A façade restricts the functionality, and thus the complexity, of a system by creating specialized interfaces for specific tasks. The [HTML::Parser](https://metacpan.org/pod/HTML::Parser) module is a base class, so the programmer must write a subclass that tells the parser what to do and when to do it, but it does not perform a specific task other than the parsing, such as syntax checking or data extraction. However, as in my [LWP](https://metacpan.org/pod/LWP) example, I simply want to complete a single, logical task—not program [HTML::Parser](https://metacpan.org/pod/HTML::Parser) subclasses. In reality, I like writing [HTML::Parser](https://metacpan.org/pod/HTML::Parser) subclasses, but not everyone with whom I work does, so I can create façades for them.

Façades to [HTML::Parser](https://metacpan.org/pod/HTML::Parser) do small, common tasks while they hide all of the complexity behind-the-scenes. I am the only one in the programming team who has to understand [HTML::Parser](https://metacpan.org/pod/HTML::Parser) so I can create much simpler interfaces for the rest of the team. They should not have to write an entire subclass if they only want to extract the links of an HTML document, for instance. Simple things should be simple.

If I wanted to extract references (which most people call "links") from an HTML document, I can use the [HTML::LinkExtor](https://metacpan.org/pod/HTML::LinkExtor) module. It handles most of the complexity for me while still giving me a reasonable amount of flexibility through a callback mechanism. I use a callback to extract all of the anchor references (the `HREF` attribute from the `A` tag). I still have to do a bit of the dirty work since [HTML::LinkExtor](https://metacpan.org/pod/HTML::LinkExtor) passes the tag name and a list of attribute-value pairs to `call_back()`. I still have to know the details of the implementation of [HTML::LinkExtor](https://metacpan.org/pod/HTML::LinkExtor) to work with it.

{% highlight perl %}
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
{% endhighlight %}

I can sacrifice flexibility for convenience by using a simpler Façade, [HTML::SimpleLinkExtor](https://metacpan.org/pod/HTML::SimpleLinkExtor), which simply returns the references but does not have a callback mechanism. In the next program, I do the same thing that I do with [HTML::LinkExtor](https://metacpan.org/pod/HTML::LinkExtor) example in the previous program, and my fellow programmers do not know how [HTML::SimpleLinkExtor](https://metacpan.org/pod/HTML::SimpleLinkExtor) does it. They do not need to worry about writing the callback function. They simply get the result that they need:

{% highlight perl %}
use HTML::SimpleLinkExtor;

my $extor = HTML::SimpleLinkExtor->new( "http://www.example.com" );
$extor->parse_file("index.html");

my @links = $extor->href;
{% endhighlight %}

If I want to do something different with [HTML::LinkExtor](https://metacpan.org/pod/HTML::LinkExtor), like extracting URLs from tags with `SRC` attributes, I have to modify the `call_back()` subroutine, or I can use a method from [HTML::SimpleLinkExtor](https://metacpan.org/pod/HTML::SimpleLinkExtor), a simpler façade, like I do in this program:

{% highlight perl %}
use HTML::SimpleLinkExtor;

my $extor = HTML::SimpleLinkExtor->new( "http://www.example.com" );
$extor->parse_file("index.html");

my @all_links = $extor->links;
{% endhighlight %}

In both of these examples, the façades allows programmers to focus on the task—extracting links—rather than on the programming. Since each façade provides a task-oriented interface, programmers do not spend time thinking about how the task should be completed, just as they do not think too much about HTTP or TCP/IP when they use their web browser to visit their favorite web pages.

The [HTML::SimpleLinkExtor](https://metacpan.org/pod/HTML::SimpleLinkExtor) works for most uses, but also cannot handle complex cases at all. Reduced flexibility is the major consequences of a façade. The more restrictive façades are easier to use at the cost of flexibility. [HTML::LinkExtor](https://metacpan.org/pod/HTML::LinkExtor) has more flexibility, but is a bit more complicated and I have to do more work to use it. The more flexible interfaces can handle more situations and respond to special cases at the cost of simplicity. Specific situations require different levels of flexibility and simplicity, and as a result, different façades, if any at all.

## Façades promote reusability

Many programmers already use a sort of façade, although they typically call it a subroutine. Subroutines did not always exist, and they represented a pattern of their own at one time. Today most languages take subroutines for granted even though they are the foundation of re-usable code.

The abstract nature of the subroutine allows programmers not only to group program statements into logical operations behind a subroutine name, like the façades in the previous section, but they also allow programmers to reuse that group of program statements without repeatedly typing them. Programmers can reuse and share collections of subroutines that they group in libraries which can form the interface of a façade.

What if I want to check the status of a web resource? If I went through all of the steps myself every time I needed to do this, I would have to create an HTTP request, connect to the web server, receive the response, parse the response, and check the response code against known status codes. Later, once I have coded this four or five lines of [LWP](https://metacpan.org/pod/LWP) code (or 15 to 20 lines of socket code) in all of my applications that need it, I will probably discover that I need to fix some of the code and to make the change in several places. If I put all of that code in a subroutine that all of my applications can share, I only have to fix things in one place and programmers using my module do not need to do anything at all.

I first ran into the link validation problem when I created a user-configurable directory of internet resources which I wanted to validate every day. I wanted to make sure that the links in the directories actually led to a web page rather than the annoying **404 Not Found** server error. I also wanted to catch dead links before a customer added them to his directory. I needed to do the same simple task in several applications, and the few lines of repeated code in each application seemed so innocent that I missed the obvious refactoring potential.

With a couple of customers using the service, I did not notice anything amiss with my validation code. It caught dead links and did not have false positives. With tens of users and a couple hundred thousand resources to validate, I discovered that not all web servers respond in the same way to certain types of HTTP requests, and that some servers even had little known bugs. One notorious server returned an HTTP error for any HEAD request, so I had to program some special cases. The task which I thought was simple grew much more complex, but I wanted to work on the level of a "ping"—a simple "yes" or "no" answer. Tests on small data sets did not reveal any problems in the parts per ten thousand range, but things quickly got out of hand after that.

My refactored solution was a façade. At the application level I did not care about server eccentricities, work-arounds for HTTP non-compliance, or most error recovery. I simply wanted to know if the URL actually pointed to something. I created a glorified subroutine, gave it a module name, and used it whenever I needed an HTTP response code. I uploaded the module to [CPAN](http://search.cpan.org) as [HTTP::SimpleLinkChecker](https://metacpan.org/pod/HTTP::SimpleLinkChecker). The next program shows the entire façade—a single function behind which all of the real work takes place. The façade takes care of all of the details, including all of my accrued knowledge about specific server behaviors, so that it could recognize possible problems and double check errors to a HEAD request by actually downloading the resource.

{% highlight perl %}
use HTTP::SimpleLinkChecker qw(check_link);

my $code = check_link("http://www.example.com");
{% endhighlight %}

If someone uses this module and decides to upgrade to a newer version when I release one, he can get the benefit of all of my improvements and enhancements without changing any of his code, while at the same time, he benefits from any enhancements to its [LWP](https://metacpan.org/pod/LWP) infrastructure even if he does not use the latest version of [HTTP::SimpleLinkChecker](https://metacpan.org/pod/HTTP::SimpleLinkChecker). This *loose coupling* makes a programmer's life much easier since the façade hides changes to the underlying system. Changes in other parts of the system have little or no maintenance consequences on the programmer's application. Since the façade depends very loosely on the underlying implementation, I can distribute it separately. Other people do not need a specific version of [LWP](https://metacpan.org/pod/LWP). I make it easy for people to use so that they will use it rather than going through the pain and suffering that I did.

## Façades as objects

A façade object acts as the gatekeeper of all method calls for the underlying implementation. Each method may in-turn act upon additional objects or classes to perform its task, but the programmer does not have to know anything about that. The façade object knows which underlying objects (Delegation represents another sort of pattern with which the Façade pattern might collaborate). Many patterns work in concert with other patterns, and although I do not discuss Delegation here, you can read about it in the documentation of Damian Conway's [Class::Delegation](https://metacpan.org/pod/Class::Delegation) or Kurt Starsinic's [Class::Delegate](https://metacpan.org/pod/Class::Delegate).

If I want to parse an HTML page to extract various things from the <HEAD> as well as some of the links, I can use [HTML::HeadParser](https://metacpan.org/pod/HTML::HeadParser) and [HTML::LinkExtor](https://metacpan.org/pod/HTML::LinkExtor), but at the application level that is too much detail. I am stuck thinking about HTML parsing when I should be getting my real work done. I can also create my own HTML façade that hides the two modules—or any other implementation—that I use.

In this next program, I wrap the interfaces to [HTML::HeadParser](https://metacpan.org/pod/HTML::HeadParser) and [HTML::SimpleLinkExtor](https://metacpan.org/pod/HTML::SimpleLinkExtor) in a single interface so I only have to deal with all of them in my application:

{% highlight perl %}
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
{% endhighlight %}

Once I have my façade in place, I can write applications that I do not need to couple to any particular module. Since the next program does not know that I used [HTML::HeadParser](https://metacpan.org/pod/HTML::HeadParser) it does not need to change if I decide to use something different for that portion of the task. The façade hides the changes:

{% highlight perl %}
#!/usr/bin/perl -w
use strict;

use HTML::SimpleExtractor;

my $html = HTML::SimpleExtractor->new('http://www.example.com');

my $title = $html->title;
my $links = $html->links;

$" = "\n\t";

print "$title\n\t@links\n";

__END__
{% endhighlight %}

In this case, I can change any of the details involved with fetching and parsing the HTML to something smarter and more efficient later. This can be quite expedient when the responsibility for the façade and the application belong to different programmers or teams, or when it would take much longer to fully implement the façade than to finish any of the applications. I can create something that works today even if it is not the best implementation then I can incrementally change and improve it as time allows.

Even though my example is very simple-minded, I get the job done. I hide the two modules behind the façade, and I can immediately use [HTML::SimpleExtractor](https://metacpan.org/pod/HTML::SimpleExtractor) in my applications. Once I have more time to devote to the module, I can change how it does its job while all of my applications that use it stay the same. None of my application code depends on the specifics of the implementation, and may not even know that the implementation has changed.

## Ad hoc façades

Most frequently the work programmers seem to do involves an established base code that has entrenched itself into the work flow of their organizations, and the further away they are from the creation time of this code, the more difficult it is to maintain or learn, especially if it is as sparsely documented as most such code I have seen. New team members can have an especially difficult time learning a byzantine code base which ends up strangling the work flow.

A façade can gradually fix this without an immediate or complete rewrite of the old code. Since a façade provides a unified interface to an complex, underlying system, it can also hide years of improvements, multitudes of styles, and unforeseen problems in the original code. A new interface that connects various legacy subsystems of the old code provides a way for programmers to replace the functionality later while creating new applications with the new interface. New programmers do not need to learn the entire system if one of the old salt programmers create a façade for them.

As more and more applications use the new façade, and hopefully fewer and fewer applications use the old code base as programmers gradually replace them, the application base moves towards something much more maintainable since the application code does not rely on the underlying façade implementation. Programmers can re-implement portions of that at their leisure without breaking applications.

Typically, these sorts of façades pull together a particular way of doing things in a particular context such as a special business need or workflow. I might have several closely related applications, and as I develop them in parallel parts of them start to look the same because they do similar things and use the same resources. Such an application's first few lines might look this, where I immediately pull in several modules:

{% highlight perl %}
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
{% endhighlight %}

I can refactor those applications and use a façade to contain all of the details about how I do the work. I want the façade to represent the task, not the method. If I use certain modules by local policy, then I only have to enforce that policy behind the façade rather than in every application. For this suite of hypothetical applications I create a module I call `Tsunami` (a deluge of code perhaps)—the name I give my fictional product. Instead of all of the modules I used in the previous program, including the notoriously old `cgi-lib.pl`, now I only have to use one module:

{% highlight perl %}
#!/usr/bin/perl

use Tsunami;

my $wave = Tsunami->new(...);

$wave->fetch('http://www.example.com');

my $title = $wave->title();

my $txt   = $wave->as_text();

print $txt;

__END__
{% endhighlight %}

This also means that other team members, by policy if not practice, only use one module too. If, for some reason, policy changes so that `Tsunami` should use [CGI.pm](https://metacpan.org/pod/CGI.pm) instead of `cgi-lib.pl`, I only have to change one file. If I improve `Tsunami`, everybody benefits.

## A priori façades

If I have the luxury of prior thought and planning, and I know that some parts of the system resist planning, I can use a façade to present an application programming interface, and build up the rest of the stuff as I find out more and more about the problem.

Once I go through the object-oriented analysis process and have identified the objects, I can also identify the different ways that the programmers will use those objects. For instance, if I want to create an application to send messages between two computers, I know that I need a network object and a message object. These objects make it easy to deal with related sets of information my program must maintain.

I want to create a application that can "chat" with another, meaning that the two applications can send messages back and forth between each other. I can use a façade to represent a simple interface, with `send()` and `receive()` methods. I might need more later, but in this contrived example I pretend that I do not know everything this application might have to do because the specifications are fuzzy and the scope of the problem scares the project planners (in this case, me).

When I start programming, nothing works because I have not written any code to represent the objects, and at that level I need all of the objects for the other ones to do their part. Since a façade hides these objects, it also hides their absence as well. I can get something in place quickly, just as in my [HTML::SimpleExtractor](https://metacpan.org/pod/HTML::SimpleExtractor) example, and be on my way.

As with all new programming I start, the first thing I do is write a test suite. Since I have no objects to test, all of the tests should fail, which is my first real test—tests fail when they should.

I create my module workspace with `h2xs`, which creates a `t` directory for test files. In my test file I add a check for that:

{% highlight perl %}
eval {
     Chat->send('Come here Mr. Watson, I need you');
     };
print $@ ? 'not ' : '', "ok\n";
{% endhighlight %}

Since the `send()` method should die with an internal error message, I check to see that it does. So far the module `Chat.pm` is the template that `h2xs` created for me.

One step beyond that I want to test that the parts of the interface exist, so I need an interface. I need to create the Chat.pm module. In this program, I have a minimal module which has one class method, `send()`. I have not really implemented it yet, so I call the `die()` function if a program calls the method:

{% highlight perl %}
package Chat;

use vars qw( $UNIMPLEMENTED );
$UNIMPLEMENTED = "Not implemented!";

sub send    { die $UNIMPLEMENTED }

1;
{% endhighlight %}

I expect the test from code listing \ref{send-test} to fail because `send()` calls the `die()` function, but I can modify the test to see if I get the right message in `$@`. In this program, the test succeeds even though the `send()` uses `die()`, since that is the behavior I expect—part of the interface now exists.

{% highlight perl %}
eval {
     Chat->send('Come here Mr. Watson, I need you');
     };
print $@ eq $Chat::UNIMPLEMENTED ? '' : 'not ', "ok\n";
{% endhighlight %}

A similar test for an undefined method should give me a different sort of error. Next, I test to see if the `receive()` method exists, and if it does, then something is wrong. I have not defined `receive()` yet.

{% highlight perl %}
eval {
     Chat->receive('I am on my way');
     };
print $@ ? '' : 'not ', "ok\n";
{% endhighlight %}

Although I still do not have any objects, I can change my `send()` method to take two arguments, a message and a recipient argument, although I have not said anything about what they are. I have, however, made progress on the interface even though I still do not have anything to actually do the work.

{% highlight perl %}
sub send
	{
	my( $class, $message, $recipient ) = @_;

	return unless defined $message and defined $recipient;

	return 1;
	}
{% endhighlight %}

My test for `send()` changes to make sure it does the right thing for different argument lists. I add three tests for different numbers of arguments. Only the call to `send()` with the right number of arguments should succeed. The other tests check for failure when `send()` should fail.

{% highlight perl %}
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
{% endhighlight %}

This process continues as I add more to the interface and as I implement the objects that will actually do the work. In the mean time, I have done useful work that has gotten to towards my goal, and I have created a suite of tests to help me along the way. The implementation does not concern me too much at this point because I can easily change it later. The rest of the project depends on the façade. Only the façade knows about the implementation, so everything else, including applications and tests, do not have to wait for the complete implementation to start work.

Once I progress far enough to have `Message` and `Recipient` objects, if I decide I need them, I can change my `send()` method to use them. I could check each argument to ensure that they belong to the proper class. Each object automatically inherits the `isa()` method from `UNIVERSAL`, the base class of all Perl classes, and returns true if the object is an instance of the class named as the argument, or a class that inherits from it. All of my tests still do the same thing:

{% highlight perl %}
sub send
	{
	my( $class, $message, $recipient ) = @_;

	return unless $message->isa('Chat::Message') and
		$recipient->isa('Chat::Recipient');

	return 1;
	}
{% endhighlight %}

If later I change the objects or their behavior, I have not wasted too much time. My façade and its tests still work. Any application I have written does not need to change significantly. The façade handles the details and the interactions between the various objects. At the same time, other programmers can start to use the interface to create applications. The programs will not work until everything is complete, of course, but the programmers have a jump start on the process because they can code and test before everything is in place. They essentially work in parallel, instead of serially, with the programmers implementing the objects and the façade. The creation of classes is not a work flow bottleneck since the façade decouples the application and lower level implementations.

## Perl modules which are façades

Several modules exhibit a Façade design pattern, although their authors may not have thought about design patterns or façades in particular. A good design stays out of the way and does not draw attention to itself. A good façade keeps most of us truly ignorant about whatever is behind it.

Most of the modules on CPAN with "Simple" in their name use the façade design pattern, including [LWP::Simple](https://metacpan.org/pod/LWP::Simple), [HTTP::SimpleLinkChecker](https://metacpan.org/pod/HTTP::SimpleLinkChecker), and [HTML::SimpleLinkExtor](https://metacpan.org/pod/HTML::SimpleLinkExtor) which I used for examples.

### LWP

The [LWP](https://metacpan.org/pod/LWP) family of modules act as a façade with a unified interface to various network protocols including HTTP, HTTPS, FTP, NNTP, and even the local filesystem. It can handle some protocol specific details too.

### DBI

The [DBI](https://metacpan.org/pod/DBI) module provide a simple interface to several database servers or file formats. I can query several types of server or file formats with the same interface while DBI—actually the appropriate DBD—handles the connection, query, response, and other tasks. The [DBI](https://metacpan.org/pod/DBI) interface even allows me to change the database server behind the scenes (from SQL Server to postgresql, perhaps) without changing much more than the `DBI->connect` statement. I do not need to worry about the connection implementation, protocols, or data format.

### Tied classes

Perl's `tie` functionality is a type of façade. What looks like a normal Perl scalar, array, or hash stands-in for a possibly complex object behind the scenes. The most impressive use of this sort of façade, in my opinion, is the [Win32::TieRegistry](https://metacpan.org/pod/Win32::TieRegistry) module, which represents the quite complex Microsoft Windows registry as a tied hash. This module even sees the following as equivalent:

{% highlight perl %}
$Registry->{'LMachine/Software/Perl'}
$Registry->{'LMachine'}->{'Software'}->{'Perl'}
{% endhighlight %}

I do not have to know very much, if anything, about the Registry. I do need to know how I name a key, but I do not need to know how it is stored or accessed since I already understand Perl hashes and references. This module takes what I already know and lets me use it instead of learning low-level vendor interfaces.

This façade also allows me to develop on foreign platforms. I can reimplement the code so that I can have a Unix version of the Windows registry, for instance. This fake version of the Registry allows me to use all of the great tools and setups I already have on my unix accounts while targeting Windows platforms. If my application had to use explicit calls to the Windows programming interface I would not be able to do that.

## Conclusion

The Façade design pattern provides a simple interface to a complex collection of modules or code. The Façade design pattern removes the details of the task from the application layer which allows me to focus on the task rather than the details, as well as allowing me to change implementations without changing my applications. This makes code more modular, maintainable, and easier to use. It decouples application code from the low level implementation which allows parallel development at different levels.

## References

You can read more about design patterns in [Design Patterns](https://amzn.to/3aPaLxO), Erich Gamma, Richard Helm, Ralph Johnson, Jon Vlissides, Addison Wesley, 1995.

Test suites for Perl modules usually use [Test::Harness](https://metacpan.org/pod/Test::Harness), although I find actual test files easier to understand. I have some simple tests in the test.pl of [HTML::SimpleLinkExtractor](https://metacpan.org/pod/HTML::SimpleLinkExtractor) distribution, or the `t` directory of [HTTP::SimpleLinkChecker](https://metacpan.org/pod/HTTP::SimpleLinkChecker).

All real modules in this article are in the [CPAN](http://search.cpan.org).
