---
layout: post
title: The Iterator Design Pattern
categories:
tags:
stopwords:
last_modified:
original_url:
---

The Iterator pattern separates the details of traversing a collection so that they can vary independently.  Perl provides some of these parts already, although in some cases I need to provide my own implementations of them.

## Introduction

Iterators as a design pattern are much more apparent as a pattern in languages that do not have aggregates as first class objects.  Perl has lists, along with the variable types arrays and hashes, and it is trivial to go through any of these with built-in Perl structures like `foreach`, `each`, `map`, and so on.  The file input operator, `<>`, iterates through the lines of the file. The `readdir()` and `glob()` functions iterate through filenames.  In scalar context, the match operator with the global flag, `m//g`, iterates through matches.

In Perl I do not have to write classes to traverse an array, but I may need to write code to go through my own complex data structures because Perl's built-in control structures, like `foreach()`, `map()`, and `grep()`, do not define an interface that objects can use to control the iteration.  They take a list, and I have to know what all of the elements of the list at the same time. A data structure might not even exist&mdash;the elements might be represented by an algorithm that determines the next element so that the object does not have to store all of the elements.

Iterators involve three parts:  the *data*, the *iterator* that knows how to get the next item, and the *controller* which invokes the iterator.  These may not always show up as distinct parts.

The iterator has to know at least two things:  how to get the next element and when no more elements are available.  Depending on the type of traversal, it may also need to know something about its state or the order it should follow. The controller uses this logic through some sort of interface, which may or may not be apparent, to interact with the data.

Since I separate each of these things when I use this pattern, I can easily change any one of them without affecting the others since they are *loosely coupled*.  I reduce their dependence on other to give ourselves more flexibility and to improve the reusability of my code. For instance, I can change the iterator's traversal from depth-first to breadth-first, and the controller says the same since it uses the same interface.  I can use the same controller for other iterators with the same interface, or the same iterator with other controllers, which gives me more choices if I decide I need to change something.

## Types of iterators

Iterators come in two types: those where the something else&mdash;a distinct controller&mdash;controls the iteration, called *external iterators*, and those where the iterator controls itself, called *internal iterators*.  Which one I decide to use depends on what I need to do.  As the implementor of an iterator I have to do about the same amount of work in either case, although other programmers benefit, or suffer, from which one I decide to use.

### Internal iterators

With internal iterators, I tell a method or function to perform some operation on each element of a collection because I already know that I will have to visit most or all of the elements, and as long as I do that I do not care how it happens.  Internal iterators often combine the controller and iterator aspects into a single thing which simplifies the life of the programmer who uses the iterator in his code.

The `map()` and `grep()` built-in functions use internal iterators.  They go through all of the elements in the data independent of our control because they combine the iterator and controller. I give these functions a bit of code that they apply to each of the elements in a list.  The `map()` function returns a list of values based on the original list, and the `grep()` function returns a list of values from the original list that satisfied a condition.  The controller and iterator parts are part of the perl core.  I do not have to tell these functions how to get the next element in the data, when they have gone through all of the elements, or that they should move on to the next element:

{% highlight perl %}
my @squares = map { $_ * $_ } 0 .. 10;

my @odds = grep { $_ % 2 } 0 .. 100;
{% endhighlight %}

When I use the [File::Find](https://metacpan.org/pod/File::Find) module, I let its `find()` function iterate through the directories on its own, and it applies the callback function to each file as it finds it:

{% highlight perl %}
#!/usr/bin/perl
use File::Find ();

File::Find::find( { wanted => \&wanted }, '.' );

sub wanted
	{
	print "$File::Find::name\n" if /^.*\.tex\z/s;
	}
{% endhighlight %}

[File::Find](https://metacpan.org/pod/File::Find) knows how to get to the next element because it keeps track of its place in the filesystem and makes repeated calls for directory contents.  When it asks for more files and the filesystem tells it that no more exist, [File::Find](https://metacpan.org/pod/File::Find) knows it is done.  As the programmer, I do not know any of this though. Once I start the `find()` function, it moves from element to element on its own.

Modules which implement composite data structures can define methods to iterate over all of their elements to perform an operation, such as a callback function or a Visitor object. The [Netscape::Bookmarks](https://metacpan.org/pod/Netscape::Bookmarks) module represents the information in a Netscape (and now Mozilla, too) bookmarks file, usually stored in HTML on a local computer, in a data structure so I can do interesting things with the data such as spell-checking, re-arranging, importing new links, converting formats, or link checking.  On the insides it is a collection of different objects from the [Netscape::Bookmarks](https://metacpan.org/pod/Netscape::Bookmarks) classes `Category`, `Link`, `Separator`, and `Alias`.

The [Netscape::Bookmarks::Category](https://metacpan.org/pod/Netscape::Bookmarks::Category) module provides a `recurse()` function that applies a `call_back` routine to every element in the current category and below, as well as an `introduce()` routine that passes its elements one-by-one to a Visitor object.  The module handles the details of the iteration and the controller for us.  Once I start the iterator it goes to completion on its own.  Code listing <a class="internal_link" href="#netscape">netscape</a> shows how little work the application programmer needs to do to traverse the entire [Netscape::Bookmarks](https://metacpan.org/pod/Netscape::Bookmarks) structure&mdash;indeed, that is the point. Not only does the programmer need to write only a couple lines of code, but if I change the mechanics or the implementation, the programmer does not have to change his code.

<p class="code_title"><a class="ref_name" name="netscape">Perl to PHP</a></p>
{% highlight perl %}
use Netscape::Bookmarks;

my $bookmarks = Netscape::Bookmarks->new( $file );

$bookmarks->recurse( \&call_back );

$bookmarks->introduce( $visitor );
{% endhighlight %}

The `recurse()` and `introduce()` methods define a traversal order, and that order is not important to me as long as I get a chance to process each element.

Classes define internal iterators to handle tasks that to operate on every element of the collection in a uniform matter. The iterator treats all of the elements the same way and when the iterator is done with one element it automatically moves on to the next one.  I create methods like `recurse()` when I do not want to do a lot of work at the application level. My scripts which use the module obey the interface, and if I find a better way to do it, the applications do not need to change. You may see a bit of the Facade design pattern here.

### External iterators

Most programmers use external iterators all the time without even knowing it.  When I provide the controller and decide when to move on to the next element, I use an external iterator.  Since the list is a fundamental Perl concept, Perl naturally has a lot of features to work with lists, and a lot of external iterator idioms.

To go through the elements of a list, I can use the `foreach()` control structure as an external iterator.  I control the iterator because I have the ability to skip items (with `next`), stop the iteration (with `last`), or reprocess the current element (with `redo`). The `foreach()` controller does not move onto the next element until I let it, which I might do implicitly by not telling it to do something else.

{% highlight perl %}
foreach my $url ( @urls )
    {
    next if $link->scheme ne 'http';
    redo if $link->domain eq 'www.perl.org';
    last if $link->query =~ m/foo/;
    }
{% endhighlight %}

Some collections do not exist as lists and so I must explicitly access one element at a time.  The `while()` control structure controls the iteration by repeatedly fetching the next element to process. In this case, I have to know how to get the next element.  The [DBI](https://metacpan.org/pod/DBI) interface returns rows from a record set one at a time through the `fetchrow_array()` method.  The `DBD` driver knows how to fetch the next element, and `fetchrow_array()` returns false when I have fetched all of the records, signalling the end of the iteration.  I can decide to stop the iteration at any point, even if I have not fetched all of the records.

<p class="code_title"><a class="ref_name" name="dbi">DBI's iterator</a></p>
{% highlight perl %}
use DBI;

my $dbh = DBI->new(...);
my $sth = $dbh->prepare(...);

while( my @row = $sth->fetchrow_array ) {
	... }
{% endhighlight %}

### One controller, multiple iterators

Since I control external iterators, I can use more than one iterator at the same time.  If I want to compare two files, for instance, I can use the line input operator on two different filehandles at the same time.  Each time I go through the while loop I get the next item from each of the iterators.  Here the `while` controller uses two iterators:

{% highlight perl %}
while( my ( $old, $new ) = (scalar <OLD>, scalar <NEW>) ) {
	... }
{% endhighlight %}

### One iterator, multiple controllers

I do not have to use the same control for all parts of the iteration. In the next bit of code, I read the first line of standard input using the line input operator (the iterator) with an assignment (the controller, if you will) to a scalar variable. Perhaps this line represents the column headings in a flat-file database. After that, I read in the next ten lines with a different controller, the `while()` loop, after which I go through the remaining lines with `grep()`.  I can only do this because I can decide when to move on to the next element.

{% highlight perl %}
my $titles = <STDIN>;

my $count = 0;
while( <STDIN> ) {
	last if $count++ >= 10;
	... }

my @lines = grep { /Perl/ } <STDIN>;
{% endhighlight %}

### Working with data not in memory

I also use external iterators when all of the of the data cannot or should not be in memory at the same time. If I work with a tied DBM hash, my hash represents possibly large numbers of keys and values stored on disk.  Since the elements of the hash are not in memory, I save space.  If I use the `keys()` or `values()` functions those potentially large numbers of keys or values are now stored in memory, negating my savings. The `each()` iterator fetches one key-value pair at a time:

<p class="code_title"><a class="ref_name" name="each">Iterating with each()</a></p>
{% highlight perl %}
while( my($key, $value) = each %DBM )
    {
    $sum += $value;
    }
{% endhighlight %}

This is the same idiom as reading a file line-by-line rather than all at once.  Since the filehandle potentially delivers more memory than our program can handle or more RAM that our hardware has, most people recommend you read the file one line at a time, like I do in code listing <a class="internal_link" href="#line-by-line">Reading line by line</a>.  The earlier [DBI](https://metacpan.org/pod/DBI) example in code listing <a class="internal_link" href="#dbi">DBI's iterator</a> does the same thing.

<p class="code_title"><a class="ref_name" name="line-by-line">Reading line by line</a></p>
{% highlight perl %}
while( <FILE> )
	{
	...
	}
{% endhighlight %}

## Iterator interfaces

Once I decide that I need to create my own iterator, I have to design an interface for it.  The design pattern only shows me the general solution, so I have to look at the specific problem to see how I can apply the general pattern.

### Object methods

Some modules save memory by computing elements only when needed, or fetch data on request from remote sources, like my earlier [DBI](https://metacpan.org/pod/DBI) example in code listings <a class="internal_link" href="#dbi">DBI's iterator</a> or <a class="internal_link" href="#each">Iterating with each()</a>.  In these cases the object has a method to return the next element.

The [Set::CrossProduct](https://metacpan.org/pod/Set::CrossProduct) module lets me deal with all of the combinations of elements from two or more sets.  For instance, for the two sets (a,b)` and `(1,2)` I get the combinations `(a, 1)`, `(a, 2)`, `(b, 1)`, and `(b, <font class="line_number">2</font>)`.  The number of combinations is, at most, the product of the number of elements in each set, which means that the number of elements can be very large for even a small number of moderately sized set.  Five sets of five items has over 3,000 combinations.  In the next example, I get back all of the combinations at once and store them in `@combinations`, meaning that I potentially use up a lot of memory even though I later go through the combinations sequentially in the `foreach()` loop.  This has the same problems as reading an entire file into an array.

{% highlight perl %}
use Set::CrossProduct;

my $cross_product = Set::CrossProduct->new( [ [qw(a b)], [ 1, 2 ] ] );

# get all combinations at once
my @combinations  = $cross_product->combinations;

foreach my $item ( @combinations )
	{
    print "The combination is @$item\n";
    }
{% endhighlight %}

[Set::CrossProduct](https://metacpan.org/pod/Set::CrossProduct) does not store the combinations in memory though. It simply stores the sets and keeps track of which combination it needs to make next. The `combinations()` method creates the list for me. [Set::CrossProduct](https://metacpan.org/pod/Set::CrossProduct) provides a next()` method, the iterator, which lets a controller fetch the next value. It is an external iterator, so I need to provide the controller to make the iterator move from one element to the next so I only have to store one combination at a time. In code listing <a class="internal_link" href="#set-cross">set-cross</a> I use a `while()` loop to repeatedly fetch the next combination&mdash;each time testing the return value of the `next()` method to see if it returned a combination:

{% highlight perl %}
use Set::CrossProduct;

my $cross_product = Set::CrossProduct->new( [ [qw(a b)], [ 1, 2 ] ] );

while( my $item = $cross_product->next )
    {
    print "The combination is @$item\n";
    }
{% endhighlight %}

#### When has the iterator finished?

How do I know when no more elements are available?  The interface has to signal to the controller that the iterator has gone through all of the elements and that the controller should not ask for any more.

I can return a false value but does not always work.  The line input operator, for instance, uses `undef` to signal the end of input.  That means it does not use all the false values for this signal since 0 and the empty string are not undefined. Any value besides `undef` comes from the data source and is an element of the iteration.  I test specifically for the `undef` value to see if the input is finished:

{% highlight perl %}
while( defined( $line = <STDIN> ) ) {
	... }
{% endhighlight %}

Perl has a special idiom for this if I use the default variable `$_`. I could write it out to look the same as code listing <a class="internal_link" href="#line-line">line-line</a> but with `$_`, or I can write in much more simply as in code listing <a class="internal_link" href="#line-default">line-default</a> which does the same thing. The `while()` condition tests to see if the item is defined, not that it is true. This is a special case only for when I use the line input operator with `$_` in the `while()` condition.

{% highlight perl %}
while( <STDIN> ) { # really while( defined( $_ = <STDIN> ) )
	... }
{% endhighlight %}

What if `while()` value is a valid value? I cannot use it to signal the end of the iteration.  I might be able to use another value that does not cannot appear in the data, but if any value is valid, I cannot use inspection to decide what to do (Mark Jason Dominus calls this the Semi-predicate Problem).

I can design an iterator which has another method which tells me the state of the iteration.  I check this method before I attempt to fetch the next element to see if any more elements are available, and if none are, the controller knows to stop.  In this example, if the `has_more_elements()` method returns false I stop the iterator:

<p class="code_title"><a class="ref_name" name="has_more">Checking for more elements</a></p>
{% highlight perl %}
while( $iterator->has_more_elements )
	{
	$item = $iterator->next;
	...;
	}
{% endhighlight %}

More Perl-like methods work too.  I can always return a reference to the data instead of the data itself. Even a reference to a false value is true since I test to determine if the variable is a reference instead of checking its value. The iterator returns a non-reference to signal that no more elements are available.  The interface is the almost the same as code listing <a class="internal_link" href="#has-more">Checking for more elements</a> since a reference is always true, even if the data it points to would evaluate to false.

If the `next()` method always returns a reference, perhaps an array reference, I can tell the difference between undef and the anonymous array of one element that contains the undef value.  The values `[ undef ]`, a reference,  and `undef`, are different. Code listing <a class="internal_link" href="#ref">Returning references</a> loops until the `next()` method returns any false value since references are always true.

<p class="code_title"><a class="ref_name" name="ref">Returning references</a></p>
{% highlight perl %}
while( my $ref = $iterator->next ) # [ undef ] works, undef doesn't
	{
	my @items = @$ref;
	...
	}
{% endhighlight %}

### Custom controllers

The [Object::Iterate](https://metacpan.org/pod/Object::Iterate) module defines some controllers for these sorts of interfaces so I can interact with the object just like I do with lists for `foreach()`, `map()`, and `grep()`. It defines `iterate`, `igrep`, and `imap` which look almost just like the perl built-in functions, but takes an object that can respond to a couple of special method names.  Code listing <a class="internal_link" href="#iterate-controllers">Controllers</a> shows the `iterate()`, `imap()`, and `igrep()` functions.

<p class="code_title"><a class="ref_name" name="iterate-controllers">Controllers</a></p>
{% highlight perl %}
use Object::Iterate qw(iterate igrep imap);

iterate { print "$_\n" } $some_object;

my @output = imap { ... } $some_object;

my @filtered = igrep { ... } $some_object;
{% endhighlight %}

Each of these functions goes through all of the elements of the object through the object's interface.  Without hints from the object, the [Object::Iterate](https://metacpan.org/pod/Object::Iterate) module uses the special object methods `__next__` and `__more__` to get the next element and determine if more elements exist.  The object's class has to implement these methods itself, and the three controllers work with any object that follows the interface.  The functions act as internal iterators just like those I showed earlier in "Internal iterators".  Once I start them they go through the entire structure without further control from me.

Code listing <a class="internal_link" href="#object-iterate">iterate()</a> shows the implementation for the `iterate()` function. It takes an anonymous subroutine as its first argument which lets it mimic the syntax for `map {}`.  The object over which it will iterate is the second argument.  In lines 5-8, `iterate()` ensures that the object has the right special methods.  In the `while()` loop, `iterate()` does the same thing as in code listing <a class="internal_link" href="#has-more">Checking for more elements</a>.

<p class="code_title"><a class="ref_name" name="object-iterate">iterate()</a></p>
{% highlight perl linenos %}
sub iterate (&$)
	{
	my( $sub, $object ) = @_;

	croak( "iterate object has no $Next() method" )
		unless UNIVERSAL::can( $_[0], '__next__' );
	croak( "iterate object has no $More() method" )
		unless UNIVERSAL::can( $_[0], '__more__' );

	while( $object->__more__ ) {
		local $_;

		$_ = $object->__next__;

		$sub->();
		}
	}
{% endhighlight %}

### Closures

I do not necessarily need modules and classes to create iterators either.  I can use a closure to hold all of the information. If I want to iterate over odd numbers, an infinite series which I cannot ever completely store in memory, I can create a closure that returns the next odd number each time I call it.  It maintains its own state and I avoid all of the overhead of method lookups.

<p class="code_title"><a class="ref_name" name="line-by-line">Reading line by line</a></p>
{% highlight perl %}
my $odds = do { my $next = -1;  sub { $next += 2; return $next } };

while( my $number = $odds->() )
    {
    print "The next number is $number\n";
    }
{% endhighlight %}

Some people call closures "inside-out objects". Objects are data with behavior while closures are behavior with data, so they make handy iterators.  I combine the data and iterator portion to create the closure.  Each time I dereference the closure, I get back the next value.  The closure comprises the iterator and the data portion, while I supply the controller.

### Tied scalars

Tied scalars must have a `FETCH` method, but nothing specifies what I have to do or which data I have to return with that method.  The [Tie::Cycle](https://metacpan.org/pod/Tie::Cycle) module ties an anonymous array to a scalar so that each time I access the scalar's value, I get the next item from the array, and when I get to the end of the array it goes back to the beginning.  The controller is the use of the scalar on the right-hand side of an expression, the `FETCH` method defines the iterator, and the anonymous array stores the data.  In this case, the tied scalar combines the iterator and the data, although I still provide the controller because I use program logic to decide when to access `$colors` even though I do not use an explicit controller.

I initially created [Tie::Cycle](https://metacpan.org/pod/Tie::Cycle) to handle alternating colors in rows of HTML tables.  I grew weary of creating bugs when I changed the colors or their number, and the amount of distracting code that had to go into calculating an index that stayed within the bounds of the defined elements of an array.  All I wanted was the next color, and I wanted that to be simple.  [Tie::Cycle](https://metacpan.org/pod/Tie::Cycle) handles the annoying parts for me, and I can reuse it wherever I need it. Code listing <a class="internal_link" href="#tie-cycle">Tie::Cycle</a> shows a typical use to shade rows of HTML tables with varying levels of gray.  Each time I access the tied variable `$colors`, on line 7, the [Tie::Cycle](https://metacpan.org/pod/Tie::Cycle) module advances along the anonymous array I gave it as an argument on line 3.

<p class="code_title"><a class="ref_name" name="line-by-line">Tie::Cycle</a></p>
{% highlight perl linenos %}
use Tie::Cycle;

tie my $colors, 'Tie::Cycle', [qw(aaaaaa cccccc ffffff)];

foreach my $row ( @rows )
    {
    my $row_color = $colors;

    print <<"HTML";
<tr>
    <td bgcolor="$row_color">
    ...
    <td>
</tr>
HTML
   }
{% endhighlight %}


### Tied filehandles

I can attach almost any data to a filehandle with a tie.  I have to implement some of the functionality myself, such as determining what the next "line" is, but once I have done that little bit of work I can use all of Perl's filehandle iteration framework.  This can be especially beneficial to new programmers who can work with filehandles but have yet not used Perl's more advanced features.

In code listing <a class="internal_link" href="#scalar-iterator">Scalar::Iterator</a> I tie a normal scalar to an input filehandle so I can read the scalar line-by-line or one character at a time just as if I were reading from a real file.  Code listing <a class="internal_link" href="#using">Using Scalar::Iterator</a> shows its use in a program. The `READLINE` function defines how to read a line (or several lines in list context), and the `GETC` function defines how to read one character. Perl uses `READLINE` when I use the file input operator `<>` and `GETC` when I use the `getc()` function.  In each case, the module removes the piece that I read, so our scalar gets shorter and shorter (unless I add to it by some other means, which I might want to do if I create an in-memory buffer).

I can decide how to read my lines.  In this case, I avoid an annoying chomp by not returning the current value of the input record separator, `$/` (a newline by default, but maybe something different) which in code listing <a class="internal_link" href="#scalar-iterator">scalar-iterator</a> I assign to `$EOL` in line <font class="line_number">14</font> and use in the regular expression, although outside the memory parentheses, in line 21.

<p class="code_title"><a class="ref_name" name="scalar-iterator">Scalar::Iterator</a></p>
{% highlight perl linenos %}
package Scalar::Iterator;

sub TIEHANDLE
    {
    my( $class, $text ) = @_;

    bless \$text, $class;
    }

sub READLINE
    {
    my $self = shift;

    my $EOL = $/;
    if( length $$self > 0 )
        {
        my @lines = ();

        while( length $$self > 0 )
            {
            $$self =~ s|(.*?)$EOL||s;
            print "Matched $1\n";
            push @lines, $1;
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

    return $1 if $$self =~ s|(.)||s;

    return;  # undef signals the end
    }
{% endhighlight %}

<br/><br/>

<p class="code_title"><a class="ref_name" name="using">Using Scalar::Iterator</a></p>
{% highlight perl %}
use Scalar::Iterator;

my $data = ...;

tie *MY_DATA, 'Scalar::Iterator', $data;

my $line = <MY_DATA>;
print "Got one line [$line]\n";

my $char = getc( MY_DATA );
print "Got next character [$char]\n";

print "Got rest of lines:\n", <MY_DATA>;
{% endhighlight %}

I can change the way that I go through the scalar.  I can change what I mean by "line" and "char" to be something else.  After all, the computer does not really know what these things are.  In code listing <a class="internal_link" href="#words">Read by words</a>, I change `READLINE` to read the next sentence, and `GETC` to read the next word.  This is more complicated than it sounds if I wanted to do this to arbitrary text, so I have to do more work than I do for the general case.

Ever wanted to put a regular expression into `$/`?  Well, now I can. In code listing <a class="internal_link" href="#words">Read by words</a> I conveniently used `$EOL` as the end-of-line marker in my example, and I put it at the end of my regular expression in `READLINE`.  If I put regular expression special characters in there, the `s///` operator will interpret them as regular expression sorts of things.  In this case I think I have reached the end of the sentence when I run into the next punctuation character in the class `[.!?]`.  This time I include the end-of-record marker, the sentence ending punctuation, with the sentence. At the same time I collapse consecutive whitespace to a single linear space.

I have to make a minor change to make `GETC` read words.  For this example, I pretend that words only have alphabetic characters and ignore special cases like contractions, abbreviations, and hyphenated words.  In that case, `GETC` only has to return the next sequence of letters while skipping over non-alphabetic characters it finds first.

My data has not changed.  It still can be anything that I like, but I can easily change how I go through it, since all the bits of the iterator stay separate from the object (not really an instance, in this case).  If I decide to change how I go through the object, the iterator is the only thing that changes.  I can even define several different iterators and use them at the same time if I like.  I do not have to do much more work to turn our sentence reader into a paragraph reader, and so on. Tied filehandles have infinite uses as iterators, but beware&mdash;tied filehandles can be slow. From ease-of-use, flexibility, and speed, I only get to choose two.

<p class="code_title"><a class="ref_name" name="words">Read by words</a></p>
{% highlight perl %}
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
{% endhighlight %}

## Perl Modules which represent iterators

Besides the modules I used as examples, several other modules express the Iterator design pattern.

### XML::*, HTML::*

Some of the XML and HTML modules represent stream-based parsers.  I give them a big chunk of text, and the module breaks it into pieces and gives me the chance to interact with the pieces.  The parsers act as the iterators and the controllers, while I supply behavior for the items they encounter. The parsers know how to get the next item.

### File::ReadBackwards

The [File::ReadBackwards](https://metacpan.org/pod/File::ReadBackwards) is a simple iterator that gives me the lines from a file one at a time, only starting at the end and working its way to the beginning. I can use its object interface or its tied filehandle interface.  I supply the external iterator, and the module knows how to get the next item.

### Tie::DirHandle

The Perl built-in function `readdir()` is an iterator. In scalar context it gives me the next filename from the directory handle, and in list context give me back all of the filenames.  It defines the logic of the traversal and I supply the controller. This modules hides the `readdir()` so I can use the filehandle iterators to interact with the directory handle.  I get the next filename with the line input operator instead of `readdir()`.

### Tie::IxHash

Normally, hashes do not preserve the order of the elements I add to them.  Perl stores the key-value pairs in a, well, hash tree, for easy lookup. Several modules, including [Tie::IxHash](https://metacpan.org/pod/Tie::IxHash), remember the order of hash operations, including addition of keys,
so I can get the keys back in the order that I added them.  It uses a tied hash to define the logic of traversal, and I can then use the standard Perl external iterators idioms to traverse the hash.

## Conclusion

The Iterator design pattern has three parts:  the data, the iterator, and the controller.  In most cases Perl supplies the iterator and controller with its built-in functionality.  In some cases, I have to write my own iterator to decide how to get the next item in the data and to decide when the iteration is complete.  As with other design patterns, the implementation is just an expression of the pattern, and there is more than one way to do it.  Which way I choose depends on my particular problem.

## References

* [Design Patterns](https://amzn.to/3aPaLxO), by
Erich Gamma, Richard Helm, Ralph Johnson, Jon Vlissides; Addison
Wesley, 1995.


