---
layout: post
title: The Iterator Design Pattern
categories:
tags:
stopwords:
last_modified:
original_url:
---

[% META
	author  = 'brian d foy'
	title   = 'The Iterator Design Pattern'
	tags    = 'perl iterators design_patterns'
	issue   = '0.5'
%]

[% PROCESS article_header %]

<p class="abstract">
The Iterator pattern separates the details of traversing a collection
so that they can vary independently.  Perl provides some of these
parts already, although in some cases I need to provide my own
implementations of them.
</p>

    <h2>Introduction</h2>

<p class="full_text">
Iterators as a design pattern are much more apparent as a pattern in
languages that do not have aggregates as first class objects.  Perl
has lists, along with the variable types arrays and hashes, and it is
trivial to go through any of these with built-in Perl structures like
<code class="inline">foreach</code>, <code class="inline">each</code>,
<code class="inline">map</code>, and so on.  The file input operator,
<code class="inline">&lt;></code>, iterates through the lines of the
file. The <code class="inline">readdir()</code> and <code
class="inline">glob()</code> functions iterate through filenames.  In
scalar context, the match operator with the global flag, <code
class="inline">m//g</code>, iterates through matches.
</p>

<p class="full_text">
In Perl I do not have to write classes to traverse an array, but I may
need to write code to go through my own complex data structures
because Perl's built-in control structures, like <code
class="inline">foreach()</code>, <code class="inline">map()</code>,
and <code class="inline">grep()</code>, do not define an interface
that objects can use to control the iteration.  They take a list, and
I have to know what all of the elements of the list at the same time.
A data structure might not even exist&mdash;the elements might be
represented by an algorithm that determines the next element so that
the object does not have to store all of the elements.
</p>

<p class="full_text">
Iterators involve three parts:  the <i>data</i>, the <i>iterator</i>
that knows how to get the next item, and the <i>controller</i> which
invokes the iterator.  These may not always show up as distinct parts.
</p>

<p class="full_text">
The iterator has to know at least two things:  how to get the next
element and when no more elements are available.  Depending on the
type of traversal, it may also need to know something about its state
or the order it should follow. The controller uses this logic through
some sort of interface, which may or may not be apparent, to interact
with the data.
</p>

<p class="full_text">
Since I separate each of these things when I use this pattern, I can
easily change any one of them without affecting the others since they
are <i>loosely coupled</i>.  I reduce their dependence on other to give
ourselves more flexibility and to improve the reusability of my code.
For instance, I can change the iterator's traversal from depth-first
to breadth-first, and the controller says the same since it uses the
same interface.  I can use the same controller for other iterators
with the same interface, or the same iterator with other controllers,
which gives me more choices if I decide I need to change something.
</p>

 <h2>Types of iterators</h2>

<p class="full_text">
Iterators come in two types: those where the something else&mdash;a
distinct controller&mdash;controls the iteration, called <i>external
iterators</i>, and those where the iterator controls itself, called
<i>internal iterators</i>.  Which one I decide to use depends on what
I need to do.  As the implementor of an iterator I have to do about
the same amount of work in either case, although other programmers
benefit, or suffer, from which one I decide to use.
</p>

<h3>Internal iterators</h3>

<p class="full_text">
With internal iterators, I tell a method or function to perform some
operation on each element of a collection because I already
know that I will have to visit most or all of the elements, and as
long as I do that I do not care how it happens.  Internal iterators
often combine the controller and iterator aspects into a single thing
which simplifies the life of the programmer who uses the iterator in his
code.
</p>

<p class="full_text">
The <code class="inline">map()</code> and <code
class="inline">grep()</code> built-in functions use internal
iterators.  They go through all of the elements in the data
independent of our control because they combine the iterator and
controller. I give these functions a bit of code that they apply to
each of the elements in a list.  The <code class="inline">map()</code>
function returns a list of values based on the original list, and the
<code class="inline">grep()</code> function returns a list of values
from the original list that satisfied a condition.  The controller and
iterator parts are part of the perl core.  I do not have to tell these
functions how to get the next element in the data, when they have gone
through all of the elements, or that they should move on to the next
element:
</p>

<pre class="code">
my @squares = map { $_ * $_ } 0 .. 10;

my @odds = grep { $_ % 2 } 0 .. 100;
</pre>

<p class="full_text">
When I use the [% te.cpan_module( 'File::Find' ) %] module, I let its
<code class="inline">find()</code> function iterate through the
directories on its own, and it applies the callback function to each
file as it finds it:
</p>

<pre class="code">
#!/usr/bin/perl
use File::Find ();

File::Find::find( { wanted => \&wanted }, '.' );

sub wanted
	{
	print "$File::Find::name\n" if /^.*\.tex\z/s;
	}
</pre>

<p class="full_text">
[% te.cpan_module( 'File::Find' ) %] knows how to get to the next
element because it keeps track of its place in the filesystem and
makes repeated calls for directory contents.  When it asks for more
files and the filesystem tells it that no more exist, [%
te.cpan_module( 'File::Find' ) %] knows it is done.  As the
programmer, I do not know any of this though. Once I start the <code
class="inline">find()</code> function, it moves from element to
element on its own.
</p>

<p class="full_text">
Modules which implement composite data structures can define methods
to iterate over all of their elements to perform an operation, such as
a callback function or a Visitor object. The [% te.cpan_module(
'Netscape::Bookmarks' ) %] module represents the information in a
Netscape (and now Mozilla, too) bookmarks file, usually stored in HTML
on a local computer, in a data structure so I can do interesting
things with the data such as spell-checking, re-arranging, importing
new links, converting formats, or link checking.  On the insides it is
a collection of different objects from the [% te.cpan_module(
'Netscape::Bookmarks' ) %] classes <code
class="inline">Category</code>, <code class="inline">Link</code>,
<code class="inline">Separator</code>, and <code
class="inline">Alias</code>.
</p>

<p class="full_text">
The [% te.cpan_module( 'Netscape::Bookmarks::Category' ) %] module
provides a <code class="inline">recurse()</code> function that applies
a <code class="inline">call_back</code> routine to every element in
the current category and below, as well as an <code
class="inline">introduce()</code> routine that passes its elements
one-by-one to a Visitor object.  The module handles the details of the
iteration and the controller for us.  Once I start the iterator it
goes to completion on its own.  Code listing <a class="internal_link"
href="#netscape">netscape</a> shows how little work the application
programmer needs to do to traverse the entire [% te.cpan_module(
'Netscape::Bookmarks' ) %] structure&mdash;indeed, that is the point.
Not only does the programmer need to write only a couple lines of
code, but if I change the mechanics or the implementation, the
programmer does not have to change his code.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="netscape">Perl to PHP</a></p>
use Netscape::Bookmarks;

my $bookmarks = Netscape::Bookmarks->new( $file );

$bookmarks->recurse( \&call_back );

$bookmarks->introduce( $visitor );
</pre>

<p class="full_text">
The <code class="inline">recurse()</code> and <code
class="inline">introduce()</code> methods define a traversal order,
and that order is not important to me as long as I get a chance to
process each element.
</p>

<p class="full_text">
Classes define internal iterators to handle tasks that to operate on
every element of the collection in a uniform matter. The iterator
treats all of the elements the same way and when the iterator is done
with one element it automatically moves on to the next one.  I create
methods like <code class="inline">recurse()</code> when I do not want
to do a lot of work at the application level. My scripts which use the
module obey the interface, and if I find a better way to do it, the
applications do not need to change. You may see a bit of the Facade
design pattern here.
</p>

    <h3>External iterators</h3>

<p class="full_text">
Most programmers use external iterators all the time without even
knowing it.  When I provide the controller and decide when to move on
to the next element, I use an external iterator.  Since the list
is a fundamental Perl concept, Perl naturally has a lot of features to
work with lists, and a lot of external iterator idioms.
</p>

<p class="full_text">
To go through the elements of a list, I can use the <code
class="inline">foreach()</code> control structure as an external
iterator.  I control the iterator because I have the ability to skip
items (with <code class="inline">next</code>), stop the iteration
(with <code class="inline">last</code>), or reprocess the current
element (with <code class="inline">redo</code>). The <code
class="inline">foreach()</code> controller does not move onto the next
element until I let it, which I might do implicitly by not telling it
to do something else.
</p>

<pre class="code">
foreach my $url ( @urls )
    {
    next if $link->scheme ne 'http';
    redo if $link->domain eq 'www.perl.org';
    last if $link->query =~ m/foo/;
    }
</pre>

<p class="full_text">
Some collections do not exist as lists and so I must explicitly access
one element at a time.  The <code class="inline">while()</code> control structure controls
the iteration by repeatedly fetching the next element to process.
In this case, I have to know how to get the next element.  The
[% te.cpan_module( 'DBI' ) %] interface returns rows from a record set one at a time through
the <code class="inline">fetchrow_array()</code> method.  The <code class="inline">DBD</code> driver knows how to fetch the
next element, and <code class="inline">fetchrow_array()</code> returns false when I have fetched
all of the records, signalling the end of the iteration.  I can decide
to stop the iteration at any point, even if I have not fetched all of
the records.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="dbi">DBI's iterator</a></p>
use DBI;

my $dbh = DBI->new(...);
my $sth = $dbh->prepare(...);

while( my @row = $sth->fetchrow_array ) {
	... }
</pre>


<h3>One controller, multiple iterators</h3>

<p class="full_text">
Since I control external iterators, I can use more than one iterator
at the same time.  If I want to compare two files, for instance, I can
use the line input operator on two different filehandles at the same
time.  Each time I go through the while loop I get the next item from
each of the iterators.  Here the <code class="inline">while</code>
controller uses two iterators:
</p>

<pre class="code">
while( my ( $old, $new ) = (scalar &lt;OLD>, scalar &lt;NEW>) ) {
	... }
</pre>


<h3>One iterator, multiple controllers</h3>

<p class="full_text">
I do not have to use the same control for all parts of the iteration.
In the next bit of code, I read the first line of
standard input using the line input operator (the iterator) with an
assignment (the controller, if you will) to a scalar variable. Perhaps
this line represents the column headings in a flat-file database.
After that, I read in the next ten lines with a different controller,
the <code class="inline">while()</code> loop, after which I go through
the remaining lines with <code class="inline">grep()</code>.  I can
only do this because I can decide when to move on to the next element.
</p>

<pre class="code">
my $titles = &lt;STDIN>;

my $count = 0;
while( &lt;STDIN> ) {
	last if $count++ >= 10;
	... }

my @lines = grep { /Perl/ } &lt;STDIN>;
</pre>


<h3>Working with data not in memory</h3>

<p class="full_text">
I also use external iterators when all of the of the data cannot or
should not be in memory at the same time. If I work with a tied DBM
hash, my hash represents possibly large numbers of keys and values
stored on disk.  Since the elements of the hash are not in memory, I
save space.  If I use the <code class="inline">keys()</code> or <code
class="inline">values()</code> functions those potentially large
numbers of keys or values are now stored in memory, negating my
savings. The <code class="inline">each()</code> iterator fetches one
key-value pair at a time:
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="each">Iterating with each()</a></p>
while( my($key, $value) = each %DBM )
    {
    $sum += $value;
    }
</pre>

<p class="full_text">
This is the same idiom as reading a file line-by-line rather than all
at once.  Since the filehandle potentially delivers more memory than
our program can handle or more RAM that our hardware has, most people
recommend you read the file one line at a time, like I do in code
listing <a class="internal_link" href="#line-by-line">Reading line by
line</a>.  The earlier [% te.cpan_module( 'DBI' ) %] example in code
listing <a class="internal_link" href="#dbi">DBI's iterator</a> does
the same thing.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="line-by-line">Reading line by line</a></p>
while( &lt;FILE> )
	{
	...
	}
</pre>


    <h2>Iterator interfaces</h2>

<p class="full_text">
Once I decide that I need to create my own iterator, I have to design
an interface for it.  The design pattern only shows me the general
solution, so I have to look at the specific problem to see how I can
apply the general pattern.
</p>

    <h3>Object methods</h3>

<p class="full_text">
Some modules save memory by computing elements only when needed, or
fetch data on request from remote sources, like my earlier [%
te.cpan_module( 'DBI' ) %] example in code listings <a
class="internal_link" href="#dbi">DBI's iterator</a> or <a
class="internal_link" href="#each">Iterating with each()</a>.  In
these cases the object has a method to return the next element.
</p>

<p class="full_text">
The [% te.cpan_module( 'Set::CrossProduct' ) %] module lets me deal
with all of the combinations of elements from two or more sets.  For
instance, for the two sets (a,b)</code> and <code
class="inline">(1,2)</code> I get the combinations <code
class="inline">(a, 1)</code>, <code class="inline">(a, 2)</code>,
<code class="inline">(b, 1)</code>, and <code class="inline">(b, <font
class="line_number">2</font>)</code>.  The number of combinations is,
at most, the product of the number of elements in each set, which
means that the number of elements can be very large for even a small
number of moderately sized set.  Five sets of five items has over
3,000 combinations.  In the next example, I get back all of the
combinations at once and store them in <code
class="inline">@combinations</code>, meaning that I potentially use up
a lot of memory even though I later go through the combinations
sequentially in the <code class="inline">foreach()</code> loop.  This
has the same problems as reading an entire file into an array.
</p>

<pre class="code">
use Set::CrossProduct;

my $cross_product = Set::CrossProduct->new( [ [qw(a b)], [ 1, 2 ] ] );

# get all combinations at once
my @combinations  = $cross_product->combinations;

foreach my $item ( @combinations )
	{
    print "The combination is @$item\n";
    }
</pre>



<p class="full_text">
[% te.cpan_module( 'Set::CrossProduct' ) %] does not store the
combinations in memory though. It simply stores the sets and keeps
track of which combination it needs to make next. The <code
class="inline">combinations()</code> method creates the list for me.
[% te.cpan_module( 'Set::CrossProduct' ) %] provides a next()</code>
method, the iterator, which lets a controller fetch the next value. It
is an external iterator, so I need to provide the controller to make
the iterator move from one element to the next so I only have to store
one combination at a time. In code listing <a class="internal_link"
href="#set-cross">set-cross</a> I use a <code
class="inline">while()</code> loop to repeatedly fetch the next
combination&mdash;each time testing the return value of the <code
class="inline">next()</code> method to see if it returned a
combination:
</p>

<pre class="code">
use Set::CrossProduct;

my $cross_product = Set::CrossProduct->new( [ [qw(a b)], [ 1, 2 ] ] );

while( my $item = $cross_product->next )
    {
    print "The combination is @$item\n";
    }
</pre>


<h4>When has the iterator finished?</h4>

<p class="full_text">
How do I know when no more elements are available?  The interface has
to signal to the controller that the iterator has gone through all of
the elements and that the controller should not ask for any more.
</p>

<p class="full_text">
I can return a false value but does not always work.  The line input
operator, for instance, uses <code class="inline">undef</code> to
signal the end of input.  That means it does not use all the false
values for this signal since 0 and the empty string are not undefined.
Any value besides <code class="inline">undef</code> comes from the
data source and is an element of the iteration.  I test
specifically for the <code class="inline">undef</code> value to see if
the input is finished:
</p>

<pre class="code">
while( defined( $line = &lt;STDIN> ) ) {
	... }
</pre>

<p class="full_text">
Perl has a special idiom for this if I use the default variable <code
class="inline">$_</code>. I could write it out to look the same as
code listing <a class="internal_link" href="#line-line">line-line</a>
but with <code class="inline">$_</code>, or I can write in much more
simply as in code listing <a class="internal_link"
href="#line-default">line-default</a> which does the same thing. The
<code class="inline">while()</code> condition tests to see if the item
is defined, not that it is true. This is a special case only for when
I use the line input operator with <code class="inline">$_</code> in
the <code class="inline">while()</code> condition.
</p>

<pre class="code">
while( &lt;STDIN> ) { # really while( defined( $_ = &lt;STDIN> ) )
	... }
</pre>

<p class="full_text">
What if <code class="inline">while()</code> value is a valid value? I
cannot use it to signal the end of the iteration.  I might be able to
use another value that does not cannot appear in the data, but if any
value is valid, I cannot use inspection to decide what to do (Mark
Jason Dominus calls this the Semi-predicate Problem).
</p>

<p class="full_text">
I can design an iterator which has another method which tells me the
state of the iteration.  I check this method before I attempt to fetch
the next element to see if any more elements are available, and if
none are, the controller knows to stop.  In this example, if the <code
class="inline">has_more_elements()</code> method returns false I stop
the iterator:
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="has_more">Checking for more elements</a></p>
while( $iterator->has_more_elements )
	{
	$item = $iterator->next;
	...;
	}
</pre>

<p class="full_text">
More Perl-like methods work too.  I can always return a reference to
the data instead of the data itself. Even a reference to a false value
is true since I test to determine if the variable is a reference
instead of checking its value. The iterator returns a non-reference to
signal that no more elements are available.  The interface is the
almost the same as code listing <a class="internal_link"
href="#has-more">Checking for more elements</a> since a reference is always true, even
if the data it points to would evaluate to false.
</p>

<p class="full_text">
If the <code class="inline">next()</code> method always returns a
reference, perhaps an array reference, I can tell the difference
between undef and the anonymous array of one element that contains the
undef value.  The values <code class="inline">[ undef ]</code>, a
reference,  and <code class="inline">undef</code>, are different. Code
listing <a class="internal_link" href="#ref">Returning references</a> loops until the
<code class="inline">next()</code> method returns any false value
since references are always true.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="ref">Returning references</a></p>
while( my $ref = $iterator->next ) # [ undef ] works, undef doesn't
	{
	my @items = @$ref;
	...
	}
</pre>


<h3>Custom controllers</h3>

<p class="full_text">
The [% te.cpan_module( 'Object::Iterate' ) %] module defines some
controllers for these sorts of interfaces so I can interact with the
object just like I do with lists for <code
class="inline">foreach()</code>, <code class="inline">map()</code>,
and <code class="inline">grep()</code>. It defines <code
class="inline">iterate</code>, <code class="inline">igrep</code>, and
<code class="inline">imap</code> which look almost just like the perl
built-in functions, but takes an object that can respond to a couple
of special method names.  Code listing <a class="internal_link"
href="#iterate-controllers">Controllers</a> shows the <code
class="inline">iterate()</code>, <code class="inline">imap()</code>,
and <code class="inline">igrep()</code> functions.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="iterate-controllers">Controllers</a></p>
use Object::Iterate qw(iterate igrep imap);

iterate { print "$_\n" } $some_object;

my @output = imap { ... } $some_object;

my @filtered = igrep { ... } $some_object;
</pre>

<p class="full_text">
Each of these functions goes through all of the elements of the object
through the object's interface.  Without hints from the object, the [%
te.cpan_module( 'Object::Iterate' ) %] module uses the special object
methods <code class="inline">__next__</code> and <code
class="inline">__more__</code> to get the next element and determine
if more elements exist.  The object's class has to implement these
methods itself, and the three controllers work with any object that
follows the interface.  The functions act as internal iterators just
like those I showed earlier in "Internal iterators".  Once I start
them they go through the entire structure without further control from
me.
</p>

<p class="full_text">
Code listing <a class="internal_link"
href="#object-iterate">iterate()</a> shows the implementation for
the <code class="inline">iterate()</code> function. It takes an
anonymous subroutine as its first argument which lets it mimic the
syntax for <code class="inline">map {}</code>.  The object over which
it will iterate is the second argument.  In lines 5-8, <code
class="inline">iterate()</code> ensures that the object has the right
special methods.  In the <code class="inline">while()</code> loop,
<code class="inline">iterate()</code> does the same thing as in code
listing <a class="internal_link" href="#has-more">Checking for more elements</a>.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="object-iterate">iterate()</a></p>
<font class="line_number"> 1</font> sub iterate (&$)
<font class="line_number"> 2</font> 	{
<font class="line_number"> 3</font> 	my( $sub, $object ) = @_;
<font class="line_number"> 4</font>
<font class="line_number"> 5</font> 	croak( "iterate object has no $Next() method" )
<font class="line_number"> 6</font> 		unless UNIVERSAL::can( $_[0], '__next__' );
<font class="line_number"> 7</font> 	croak( "iterate object has no $More() method" )
<font class="line_number"> 8</font> 		unless UNIVERSAL::can( $_[0], '__more__' );
<font class="line_number"> 9</font>
<font class="line_number">10</font> 	while( $object->__more__ ) {
<font class="line_number">11</font> 		local $_;
<font class="line_number">12</font>
<font class="line_number">13</font> 		$_ = $object->__next__;
<font class="line_number">14</font>
<font class="line_number">15</font> 		$sub->();
<font class="line_number">16</font> 		}
<font class="line_number">17</font> 	}
</pre>


	<h3>Closures</h3>

<p class="full_text">
I do not necessarily need modules and classes to create iterators
either.  I can use a closure to hold all of the information.
If I want to iterate over odd numbers, an infinite series
which I cannot ever completely store in memory, I can
create a closure that returns the next odd number each time I
call it.  It maintains its own state and I avoid all of the
overhead of method lookups.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="line-by-line">Reading line by line</a></p>
my $odds = do { my $next = -1;  sub { $next += 2; return $next } };

while( my $number = $odds->() )
    {
    print "The next number is $number\n";
    }
</pre>



<p class="full_text">
Some people call closures "inside-out objects".
Objects are data with behavior while closures are behavior with data,
so they make handy iterators.  I combine the data and iterator portion
to create the closure.  Each time I dereference the closure, I get
back the next value.  The closure comprises the iterator and the data
portion, while I supply the controller.
</p>

    <h3>Tied scalars</h3>

<p class="full_text">
Tied scalars must have a <code class="inline">FETCH</code> method, but
nothing specifies what I have to do or which data I have to return
with that method.  The [% te.cpan_module( 'Tie::Cycle' ) %] module
ties an anonymous array to a scalar so that each time I access the
scalar's value, I get the next item from the array, and when I get to
the end of the array it goes back to the beginning.  The controller is
the use of the scalar on the right-hand side of an expression, the
<code class="inline">FETCH</code> method defines the iterator, and the
anonymous array stores the data.  In this case, the tied scalar
combines the iterator and the data, although I still provide the
controller because I use program logic to decide when to access <code
class="inline">$colors</code> even though I do not use an explicit
controller.
</p>

<p class="full_text">
I initially created [% te.cpan_module( 'Tie::Cycle' ) %] to handle
alternating colors in rows of HTML tables.  I grew weary of creating
bugs when I changed the colors or their number, and the amount of
distracting code that had to go into calculating an index that stayed
within the bounds of the defined elements of an array.  All I wanted
was the next color, and I wanted that to be simple.  [%
te.cpan_module( 'Tie::Cycle' ) %] handles the annoying parts for me,
and I can reuse it wherever I need it. Code listing <a
class="internal_link" href="#tie-cycle">Tie::Cycle</a> shows a typical
use to shade rows of HTML tables with varying levels of gray.  Each
time I access the tied variable <code class="inline">$colors</code>,
on line 7, the [% te.cpan_module( 'Tie::Cycle' ) %] module advances
along the anonymous array I gave it as an argument on line 3.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="line-by-line">Tie::Cycle</a></p>
<font class="line_number"> 1</font> use Tie::Cycle;
<font class="line_number"> 2</font>
<font class="line_number"> 3</font> tie my $colors, 'Tie::Cycle', [qw(aaaaaa cccccc ffffff)];
<font class="line_number"> 4</font>
<font class="line_number"> 5</font> foreach my $row ( @rows )
<font class="line_number"> 6</font>     {
<font class="line_number"> 7</font>     my $row_color = $colors;
<font class="line_number"> 8</font>
<font class="line_number"> 9</font>     print &lt;&lt;"HTML";
<font class="line_number">10</font> &lt;tr>
<font class="line_number">11</font>     &lt;td bgcolor="$row_color">
<font class="line_number">12</font>     ...
<font class="line_number">13</font>     &lt;td>
<font class="line_number">14</font> &lt;/tr>
<font class="line_number">15</font> HTML
<font class="line_number">16</font>    }
</pre>


    <h3>Tied filehandles</h3>

<p class="full_text">
I can attach almost any data to a filehandle with a tie.  I have to
implement some of the functionality myself, such as determining what
the next "line" is, but once I have done that little bit of work I
can use all of Perl's filehandle iteration framework.  This can be
especially beneficial to new programmers who can work with filehandles
but have yet not used Perl's more advanced features.
</p>

<p class="full_text">
In code listing <a class="internal_link"
href="#scalar-iterator">Scalar::Iterator</a> I tie a normal scalar to
an input filehandle so I can read the scalar line-by-line or one
character at a time just as if I were reading from a real file.  Code
listing <a class="internal_link" href="#using">Using
Scalar::Iterator</a> shows its use in a program. The <code
class="inline">READLINE</code> function defines how to read a line (or
several lines in list context), and the <code
class="inline">GETC</code> function defines how to read one character.
Perl uses <code class="inline">READLINE</code> when I use the file
input operator <code class="inline">&lt;></code> and <code
class="inline">GETC</code> when I use the <code
class="inline">getc()</code> function.  In each case, the module
removes the piece that I read, so our scalar gets shorter and shorter
(unless I add to it by some other means, which I might want to do if I
create an in-memory buffer).
</p>

<p class="full_text">
I can decide how to read my lines.  In this case, I avoid an annoying
chomp by not returning the current value of the input record
separator, <code class="inline">$/</code> (a newline by default, but
maybe something different) which in code listing <a
class="internal_link" href="#scalar-iterator">scalar-iterator</a> I
assign to <code class="inline">$EOL</code> in line <font
class="line_number">14</font> and use in the regular expression,
although outside the memory parentheses, in line 21.
</p>

<pre class="code">
<p class="code_title"><a class="ref_name" name="scalar-iterator">Scalar::Iterator</a></p>
<font class="line_number"> 1</font> package Scalar::Iterator;
<font class="line_number"> 2</font>
<font class="line_number"> 3</font> sub TIEHANDLE
<font class="line_number"> 4</font>     {
<font class="line_number"> 5</font>     my( $class, $text ) = @_;
<font class="line_number"> 6</font>
<font class="line_number"> 7</font>     bless \$text, $class;
<font class="line_number"> 8</font>     }
<font class="line_number"> 9</font>
<font class="line_number">10</font> sub READLINE
<font class="line_number">11</font>     {
<font class="line_number">12</font>     my $self = shift;
<font class="line_number">13</font>
<font class="line_number">14</font>     my $EOL = $/;
<font class="line_number">15</font>     if( length $$self > 0 )
<font class="line_number">16</font>         {
<font class="line_number">17</font>         my @lines = ();
<font class="line_number">18</font>
<font class="line_number">19</font>         while( length $$self > 0 )
<font class="line_number">20</font>             {
<font class="line_number">21</font>             $$self =~ s|(.*?)$EOL||s;
<font class="line_number">22</font>             print "Matched $1\n";
<font class="line_number">23</font>             push @lines, $1;
<font class="line_number">24</font>             last unless wantarray;
<font class="line_number">25</font>             }
<font class="line_number">26</font>
<font class="line_number">27</font>         return wantarray ? @lines : $lines[0];
<font class="line_number">28</font>         }
<font class="line_number">29</font>     else
<font class="line_number">30</font>         {
<font class="line_number">31</font>         return;  # undef signals the end
<font class="line_number">32</font>         }
<font class="line_number">33</font>     }
<font class="line_number">34</font>
<font class="line_number">35</font> sub GETC
<font class="line_number">36</font>     {
<font class="line_number">37</font>     my $self = shift;
<font class="line_number">38</font>
<font class="line_number">39</font>     return $1 if $$self =~ s|(.)||s;
<font class="line_number">40</font>
<font class="line_number">41</font>     return;  # undef signals the end
<font class="line_number">42</font>     }
</pre>

<br/><br/>

<pre class="code">
<p class="code_title"><a class="ref_name" name="using">Using Scalar::Iterator</a></p>
use Scalar::Iterator;

my $data = ...;

tie *MY_DATA, 'Scalar::Iterator', $data;

my $line = &lt;MY_DATA>;
print "Got one line [$line]\n";

my $char = getc( MY_DATA );
print "Got next character [$char]\n";

print "Got rest of lines:\n", &lt;MY_DATA>;
</pre>

<p class="full_text">
I can change the way that I go through the scalar.  I can change what
I mean by "line" and "char" to be something else.  After all, the
computer does not really know what these things are.  In code listing
<a class="internal_link" href="#words">Read by words</a>, I change <code
class="inline">READLINE</code> to read the next
sentence, and <code class="inline">GETC</code> to read
the next word.  This is more complicated than it sounds if I wanted to
do this to arbitrary text, so I have to do more work than I do for the
general case.
</p>

<p class="full_text">
Ever wanted to put a regular expression into <code
class="inline">$/</code>?  Well, now I can. In code listing <a
class="internal_link" href="#words">Read by words</a> I conveniently
used <code class="inline">$EOL</code> as the end-of-line marker in my
example, and I put it at the end of my regular expression in <code
class="inline">READLINE</code>.  If I put regular expression special
characters in there, the <code class="inline">s///</code> operator
will interpret them as regular expression sorts of things.  In this
case I think I have reached the end of the sentence when I run into
the next punctuation character in the class <code
class="inline">[.!?]</code>.  This time I include the end-of-record
marker, the sentence ending punctuation, with the sentence. At the
same time I collapse consecutive whitespace to a single linear space.
</p>

<p class="full_text">
I have to make a minor change to make <code class="inline">GETC</code>
read words.  For this example, I pretend that words only have
alphabetic characters and ignore special cases like contractions,
abbreviations, and hyphenated words.  In that case, <code
class="inline">GETC</code> only has to return the next sequence of
letters while skipping over non-alphabetic characters it finds first.
</p>

<p class="full_text">
My data has not changed.  It still can be anything that I like, but I
can easily change how I go through it, since all the bits of the
iterator stay separate from the object (not really an instance, in
this case).  If I decide to change how I go through the object, the
iterator is the only thing that changes.  I can even define several
different iterators and use them at the same time if I like.  I do not
have to do much more work to turn our sentence reader into a paragraph
reader, and so on. Tied filehandles have infinite uses as iterators,
but beware&mdash;tied filehandles can be slow. From ease-of-use,
flexibility, and speed, I only get to choose two.


<pre class="code">
<p class="code_title"><a class="ref_name" name="words">Read by words</a></p>
sub READLINE
    {
    my $self = shift;

    my $EOL = '[.!?]';
    if( length $$self > 0 )
        {
        my @lines = ();

        while( length $$self > 0 )
            {
            $$self =~ s|(.*?$EOL)||s;
            my $sentence = $1;
            $sentence =~ s/\s+/ /g;
            push @lines, $sentence;
            last unless wantarray;
            }

        return wantarray ? @lines : $lines[0];
        }
    else
        {
        return;  # undef signals the end
        }
    }

sub GETC
    {
    my $self = shift;

    return $1 if $$self =~ s|[^a-z]([a-z])||i;

    return;  # undef signals the end
    }
</pre>


<h2>Perl Modules which represent iterators</h2>

<p class="full_text">
Besides the modules I used as examples, several other modules express the
Iterator design pattern.
</p>

    <h3>XML::*, HTML::*</h3>

<p class="full_text">
Some of the XML and HTML modules represent stream-based parsers.  I
give them a big chunk of text, and the module breaks it into pieces
and gives me the chance to interact with the pieces.  The parsers act
as the iterators and the controllers, while I supply behavior for the
items they encounter. The parsers know how to get the next item.
</p>

    <h3>File::ReadBackwards</h3>

<p class="full_text">
The [% te.cpan_module( 'File::ReadBackwards' ) %] is a simple iterator
that gives me the lines from a file one at a time, only starting at
the end and working its way to the beginning. I can use its object
interface or its tied filehandle interface.  I supply the external
iterator, and the module knows how to get the next item.
</p>

    <h3>Tie::DirHandle</h3>

<p class="full_text">
The Perl built-in function <code class="inline">readdir()</code> is an
iterator. In scalar context it gives me the next filename from the
directory handle, and in list context give me back all of the
filenames.  It defines the logic of the traversal and I supply the
controller. This modules hides the <code
class="inline">readdir()</code> so I can use the filehandle iterators
to interact with the directory handle.  I get the next filename with
the line input operator instead of <code
class="inline">readdir()</code>.
</p>

    <h3>Tie::IxHash</h3>

<p class="full_text">
Normally, hashes do not preserve the order of the elements I add to
them.  Perl stores the key-value pairs in a, well, hash tree, for easy
lookup. Several modules, including [% te.cpan_module( 'Tie::IxHash' )
%], remember the order of hash operations, including addition of keys,
so I can get the keys back in the order that I added them.  It uses a
tied hash to define the logic of traversal, and I can then use the
standard Perl external iterators idioms to traverse the hash.
</p>

	<h2>Conclusion</h2>

<p class="full_text">
The Iterator design pattern has three parts:  the data, the iterator,
and the controller.  In most cases Perl supplies the iterator and
controller with its built-in functionality.  In some cases, I have to
write my own iterator to decide how to get the next item in the data
and to decide when the iteration is complete.  As with other design
patterns, the implementation is just an expression of the pattern, and
there is more than one way to do it.  Which way I choose depends on
my particular problem.
</p>

	<h2>References</h2>

<ul>
<li>[% te.book( 'Design Patterns', '0201633612' ) %], by
Erich Gamma, Richard Helm, Ralph Johnson, Jon Vlissides; Addison
Wesley, 1995.
</ul>

[% PROCESS footer %]

