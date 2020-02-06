---
layout: post
title: The Singleton Design Pattern
categories: programming
tags: perl design_patterns singletons
stopwords:
last_modified:
original_url:
---

The Singleton design pattern allows many parts of a program to share a single resource without having to work out the details of the sharing themselves. This article discusses this design pattern, shows several possible implementations, and highlights some Perl modules which use singletons.

## About design patterns

Design patterns help structure code, although they do not say anything about how to implement it.  They solve problems before we start to write code because they affect the design of programs by recognizing the possible abstractions in the problem.  More than one pattern may apply, and within any pattern, many ways to implement it.

We typically represent patterns with modules so their implementations are re-usable and abstract and make full use of encapsulation.  The rest of the program does not need to know how the module works, and indeed, the more the program knows about the module's workings, the more of a problem we have.  Patterns promote loose coupling so that their implementation does not affect the rest program.

## When to consider using a singleton

Some things, like a particular hardware interface or serial port, or a software construct such as a database connection, can or should only be used once in a program.

Parts of a program which use those resources may not need to know if other parts of the program are already using them, or if those resources have already been used or have yet to be initialized.  The small part of my program that decides it needs to use that resource simply uses it. The singleton pattern works out the sharing so that I do not need to do so every time I want to share something, and so that I have one place to maintain the code that works out the sharing.

I may consider using a singleton class if my program design shows any of these symptoms:

* Global variables pass data between parts of the application.
* A resource can only be used once
* Several identical instances in different parts of the program represent the same thing

## About the pattern

The Singleton pattern provides a single point of access to a particular instance, and a single point of maintenance. If I decide to change the behavior of my class that implements the singleton, perhaps by limiting the total number of uses of the singleton instance, or even re-implementing the class to allow more than one, but still a limited number of, instances, I only need to modify the class. Every program or point in the program that uses the singleton will immediately get the benefits of change without knowing the details.

## A simple example

To implement the singleton, I need to know if I have already created the instance, and if so, use it.  Otherwise I need to create and remember an instance somehow so I can return it the next time my program needs it.

In code listing <a class="internal_link" href="#counter.pm">Counter.pm</a> I create a very simple example of a global counter.  My program which uses this module should be able to access the counter instance to increase or inspect its value, and different parts of the program will be able to do this without knowing about each other.  If one part of the program adds to the counter, the other part of the program using the counter sees the new value, and vice versa.

<a class="ref_name" name="counter.pm">Counter.pm</a>

{% highlight perl linenos %}
package Counter;

my $singleton = undef;

sub new {
    my( $class ) = @_;

    return $singleton if defined $singleton;

    my $self = 0;
    $singleton = bless \$self, $class;

    return $singleton;
    }

sub value {
    my $self = shift;
    return $$self;
    }

sub increment {
    my $self = shift;
    return ++$$self;
    }

1;
{% endhighlight %}

In line 3, I declare a lexical variable, `$singleton`, in which I store my single instance, which the entire Counter package can access, as long as the entire package is in the same file since `$singleton` is scoped to the file.  I initialize it to `undef` so that I know I have not created the instance yet. If it is something other than  `undef`, I know it contains an instance. Now I know how to check whether or not I have created the instance&mdash;if `$singleton` is defined, then it contains an instance.  Furthermore, I scoped $singleton to my file with `my()`, so code outside of the file cannot affect it.  Indeed, code outside of the class does not even know it exists. In other languages, `$singleton` might be called a private class variable.

The `new()` method performs all of my magic. In line 9 I test `$singleton` to see if it is defined, and if it is I simply return its value.  If it is not defined, I have not yet created an instance, so I go through the rest of the method to create the instance and to store it in `$singleton`.

Two other functions, `value()` and `increment()`, let me inspect and increase the counter by one, respectively.

When I use this module in a program, I do not have to do anything special or know anything about how it is implemented.  All I have to know is that no matter how many times I try to get an instance by calling `new()`, I get the same counter, even if I do not know that is what I call a "singleton".  Code listing <a class="internal_link" href="#counter.pl">Counter.pl</a> shows a short example of the use of my Counter module.

<a class="ref_name" name="counter.pl">Counter.pl</a>

{% highlight perl linenos %}
#!/usr/bin/perl

use Counter;

my $count  = Counter->new();
my $count2 = Counter->new();

print "The counters are the same!\n" if $count eq $count2;

print "Count is now ", $count->increment, "\n";
print "Count is now ", $count2->increment, "\n";
print "Count is now ", $count->increment, "\n";

print "Count is now ", $count2->value, "\n";

print "The counters are the same!\n"
    if $count->value eq $count2->value;
{% endhighlight %}

I create two counters in lines 5 and 6, although these are really the same instance.  In line 8 I compare the two references just to prove to myself that I have really created a singleton. When you write your own test suite, you need to check to make sure your singletons are really singletons.

Once I know that `$count` and `$count2` are the same, I increment the value through `$count` and print the result, then do it again with `$count2`. No matter which one I use, the counter increases by one:

{% highlight text %}
The counters are the same!
Count is now 1
Count is now 2
Count is now 3
The counters are the same!
{% endhighlight %}

### Using only one database connection

Suppose that I need to access a database server from several different parts of my program&mdash;perhaps to load configuration information when it starts, select some fields based on a user query, and insert logging information at the end. In a large program, especially one with good modular design, these functions might live in different modules that handle each of those abstractions in a decoupled way so that they never know about each other.

I could create a [DBI](https://www.metacpan.org/pod/DBI) object in each part of the program that needs to talk to the database, but I might end up with several open database connections.  This is one of the symptoms I listed earlier&mdash;several identical, or close enough to identical, instances.  Additionally, each time I open a database connection I incur additional overhead, which may be significant to my program.

Every time I run my program I take up multiple database connections even though I do not need to.  The different parts of the program just need to talk to the database. They do not need their <i>own</i> connection.

To solve this problem I can create a module to control instantiation of my database objects so that my program only uses one connection. In code listing <a class="internal_link" href="#db_singleton">Database singleton</a> I create a module named DBI::Singleton which subclasses [DBI](https://www.metacpan.org/pod/DBI) to control the number of instances. In this case I want a single instance.

<a class="ref_name" name="counter.pm">Database singleton</a>

{% highlight perl linenos %}
package DBI::Singleton;

use base qw(DBI);
use DBI;

my $Dbh = undef;

sub connect {
    my $class = shift;

    return $Dbh if defined $Dbh;

    $Dbh = DBI->connect( @_ );
    }
{% endhighlight %}

This module looks for similar to my Counter module.  I store the singleton instance in the lexical variable `$Dbh`, and `connect()` is my constructor.  I inherit from [DBI](https://www.metacpan.org/pod/DBI) in line 5, so `DBI.pm` handles any other methods called on the `DBI::Singleton` instance. I also rely on [DBI](https://www.metacpan.org/pod/DBI) to create the instance since I call its `connect()` method explicitly.

That is all there is to it for my simple example.  When I want a database connection anywhere in my program, I simply ask my `DBI::Singleton` module for one in the same way as if I were using the [DBI](https://www.metacpan.org/pod/DBI) module directly.

{% highlight perl %}
my $my_dbh = DBI::Singleton->connect( @arguments );
{% endhighlight %}

The `$my_dbh` variable stores a [DBI](https://www.metacpan.org/pod/DBI) instance since I did not re-bless it into my `DBI::Singleton` package.  If you know about design patterns already, you may recognize a bit of the Factory and Adapter patterns in `DBI::Singleton`'s `connect()`.

How does it work?  I call the `connect()` method in my package.  The first argument is the name of the package, `DBI::Singleton`, which I ignore because I will return a [DBI](https://www.metacpan.org/pod/DBI) instance. Next, I check to see if the variable `$Dbh` is defined.  I created `$Dbh` as a lexical variable with `my()` which means that it is only available inside `DBI::Singleton` file just as in my Counter example from code listing <a class="internal_link" href="#counter.pm">counter.pm</a>. If `$Dbh` is undefined, I continue through the method and connect to the database with the remaining arguments left on the argument list. I save the return value from `connect()` in `$Dbh`, which will be a [DBI](https://www.metacpan.org/pod/DBI) instance if the `connect()` succeeds and `undef`, the original value of `$Dbh`, if it fails.  I still look in `$DBI::errstr` to see what went wrong, but I can fix that in section <a class="internal_link" href="#fix">fix</a>.

Assuming that the connection succeeds, the second time I try to connect to the database with `DBI::Singleton`, `$Dbh` is defined, so `DBI::Singleton`'s `connect()` method returns the stored instance instead of a completely new one. As long as each part of my program that needs a database connection uses `DBI::Singleton->connect()`, my program should only ever use one database connection.

### Class::Singleton

Andy Wardley created a base module, [Class::Singleton](https://www.metacpan.org/pod/Class::Singleton), that I can use for any class I intend to be a singleton.  If I put [Class::Singleton](https://www.metacpan.org/pod/Class::Singleton) into the inheritance tree of my singleton-to-be module by declaring it with `use base`, I can let [Class::Singleton](https://www.metacpan.org/pod/Class::Singleton) handle most of the details.

{% highlight perl %}
package DBI::Singleton;

use base qw(Class::Singleton);
use vars qw($errstr);

use DBI;

*errstr = *DBI::errstr;

sub _new_instance {
    my $class = shift;

    return DBI->connect(@_);
    }
{% endhighlight %}

The flow of this method is the same as in code listing <a class="internal_link" href="#db_singleton">Database singleton</a>, but [Class::Singleton](https://www.metacpan.org/pod/Class::Singleton) handles some of the details. I renamed my connect method to `_new_instance()`, which is a special method that [Class::Singleton](https://www.metacpan.org/pod/Class::Singleton) expects to be in my derived class. When I want an instance, I ask my module for one using the [Class::Singleton](https://www.metacpan.org/pod/Class::Singleton) method named `instance()`.

{% highlight perl %}
my $my_dbh = DBI::Singleton->instance( @arguments );
{% endhighlight %}

Since the instance() method does not exist in my DBI::Singleton package, but I inherit from [Class::Singleton](https://www.metacpan.org/pod/Class::Singleton), perl uses [Class::Singleton](https://www.metacpan.org/pod/Class::Singleton)'s `instance()` method which does all that magic. The first time I call instance(), it looks for the method `_new_instance()` in my derived class. [Class::Singleton](https://www.metacpan.org/pod/Class::Singleton) expects to receive an instance from this method, and when it gets the instance, it stores so that the next time I call `DBI::Singleton`'s `instance()` I get the remembered instance rather than a new one.

In line 8, I also fixed my problem accessing the [DBI](https://www.metacpan.org/pod/DBI) error messages, stored in `$DBI::errstr`, by aliasing `$DBI::Singleton::errstr` to `$DBI::errstr` with a little bit of typeglob magic.  Accessing either of those variables accesses the same information.

### Other paths to the same thing

I do not actually have too many other options on implementing a singleton. I need control of the instance so other code can not change it and affect distant parts of the program, and I need to be able to share it. Here are some other ways to implement a singleton.  Some of them have disadvantages, but may fit particular situations better.

#### Global variables

Global variables allow me to pass data throughout a program with little care or thought, and to use those data with similar lack of care as long as I know the global variable name.  In Perl I have an easier time with this since any package variable is really a global variable as long as I know the package name, and also some Perl special variables are always global variables.

However, the value of a global variable is only as good as what I last did with it, and as the programmer I can do just about anything I like with a global variable including changing its value, perhaps to something that makes no sense, which then affects other parts of my program.  If I use a singleton to control access to this data, each part of the program gets what it expects because I provide a single point of access.  In my examples, I hid the data as a lexical variable in my Counter and `DBI::Singleton` classes so that code outside of the file could not affect its value.  Since global variables cannot provide this sort of protection, they are not always a good way to implement singletons.

The [Class::Singleton](https://www.metacpan.org/pod/Class::Singleton) module, which I discussed earlier, uses package variables to store instances since it needs to be able to deal with many different derived classes.

The [Win32::TieRegistry](https://www.metacpan.org/pod/Win32::TieRegistry) module demonstrates a good use of a package variable to represent its singleton. Every recent Microsoft desktop operating system has a registry where it stores useful information about the operation of the computer.  Other parts of the system, including applications, can read and write to this registry. Although it is dangerous to change parts of the registry on which the operating system depends, it is useful for applications to store some of their own information in the registry.

The operating system has only one registry which all of the applications and processes share.  Accessing the Registry perfectly describes the singleton pattern&mdash;many processes sharing one resource. In [Win32::TieRegistry](https://www.metacpan.org/pod/Win32::TieRegistry), the Registry is represented by a class variable `$Registry` which is set up when the module is first loaded, and exported by default. All subsequent uses access the same entity.  The `$Registry` variable is actually a reference to a tied hash of hashes which is amazingly flexible in its access to its keys, so other approaches to its implementation would be much more complex and more difficult to understand.

#### Using class methods instead of instances

I could implement a singleton with a class that does not use an instance.  Instead of instance methods, I use class methods.  This would work adequately for my Counter example in code listing <a class="internal_link" href="#counter.pm">Counter.pm</a> since I only need to access the counter's value. However, if I implemented my database example with class methods, I would connect to the database and store the [DBI](https://www.metacpan.org/pod/DBI) instance as before, but the return value would not be the instance.  It can be something else, although a value that tells me the success or failure of the action is simple and useful.  Every time I want to call a method on the instance, I have to go through a class method. This provides the level of abstraction I need, but can be tedious and unnecessarily complex to implement because I have to go through two levels of method calls (one for the class and one for the instance) to do what I should be able to do directly.

{% highlight perl %}
my $status = DBI::Singleton->connect( @arguments );
die "Could not connect to database!" unless $status;
{% endhighlight %}

The first time that I call `connect()` the class connects to the database and stores the database object in a class variable, as before.  The `connect()` method returns a status value so I know if the method succeeded.

From there, I have to do more work to get the rest of the functionality since I can only call class methods.  For example, if I wanted to make a database query, the interface is a class method call.

{% highlight perl %}
DBI::Singleton->query( $query_text );
{% endhighlight %}

I create a query method that takes the arguments to the class method and translates it into something that the behind-the-scenes database handle can understand.  In my previous instance implementation in code listing <a class="internal_link" href="#db_singleton">DB Singleton</a>, the first argument to the method was the instance itself, which I called `$self`.  When I call a class method, the first argument is the name of the class, as a string.  In this example, `$class` is literally `DBI::Singleton`.

{% highlight perl %}
sub query {
    my $class = shift;

    my $sth = $Dbh->query(@_);

    return $status;
    }
{% endhighlight %}

Inheritance works as well in class methods and instance methods.  my method does not know the difference without inspecting the first argument to the method to determine if it is a reference (meaning that it is an instance) or a string (meaning that it is a class).  I will look at this more later.

#### Using functions instead of instances

I can also implement singletons without any explicit object-oriented programming.  The [CGI](https://www.metacpan.org/pod/CGI) module does this for its functional mode of programming.  It maintains an internal [CGI](https://www.metacpan.org/pod/CGI) object and controls access it to via its functions.  If I use the object-oriented interface for [CGI.pm](https://www.metacpan.org/pod/CGI.pm),

{% highlight perl %}
use CGI;

my $input = CGI->new();

my @names = $input->param();
{% endhighlight %}

If I use the functional approach to do the same thing, [CGI.pm](https://www.metacpan.org/pod/CGI.pm) still uses an object behind the scenes. No matter which function I use, I end up accessing the same [CGI](https://www.metacpan.org/pod/CGI) object, so this demonstrates a type of singleton.

{% highlight perl %}
use CGI qw(:standard);

my @names = param();
{% endhighlight %}

This has all of the problems of using class methods and the only difference is that the first argument to all of the functions is not an instance or a class name. The [CGI](https://www.metacpan.org/pod/CGI) module jumps through a couple of hoops to make this work seamlessly.

I have to use the functions in a different way than before. In the instance example perl could find the right methods because the constructor had blessed it into a class. Since my database example instance in code listing <a class="internal_link" href="#db_singleton">DB singleton</a> was blessed into [DBI](https://www.metacpan.org/pod/DBI), when I called a method, like query(), perl knew to look in the [DBI](https://www.metacpan.org/pod/DBI) package.  In the class example, perl knew where to look because the class name was explicitly stated when I typed it into the program.  But,if I want to use functions, then I have to tell perl how to find the functions and data. I have two options&mdash;give the full package specification for the function, like `&DBI::Singleton::connect( @arguments )` or export (or define) the functions into the current package.

The former works out to be the same as the class method approach save for the missing class name argument, and it has the advantage of showing future maintenance programmers from which package the `connect()` method comes.

The latter option is a bit tricky.  If the functions are in the current package, I have to choose where to store the data which will represent the singleton. In the previous example I used a lexical variable.  That does not work anymore because I cannot be sure that I will not unintentionally overwrite or hide something in the current package. In short, I have broken encapsulation and data hiding. If I created my functions in their own package, I could explicitly refer to variables in the original namespace.

{% highlight perl %}
sub query {
	$DBI::Singleton::Dbh->query( @_ );
	}
{% endhighlight %}

Not only do I have a lot of extra work to do all of the things that instances and classes gave me for free, but I have to expose the innards of my singleton module and lose the protection of the private variables. I would need a compelling reason to implement a singleton this way.

#### Using all three

Since Perl is not strongly typed, and since all arguments are simply passed as a list of scalars, I can, should I have a lot of extra time on my hands and nothing better to do, write methods that can handle instance methods, class methods, or functions, which I present here as merely for amusement, although it demonstrates a bit of Perl wizardry. I actually know of one developer who implemented such a thing for some enterprise software so that each program could choose its interface.

First, I need to determine which method I am using.  If the first argument is a reference, then I use that reference as the instance. If it is a class name, however, I can ignore it.  If it is neither, then I can assume I am using the functional style. Sound simple? Not so fast.

How do I figure out if the first argument is an instance?  I cannot simply check to see if it is a reference, because references can be used for other things.  I also cannot rely on any instance as the first argument being the right sort of instance since a reference might actually be the expected argument.  I can check to see if the instance belongs to my package with `UNIVERSAL::isa()`.  Even if the first argument passes my `isa()` test, I could still be wrong unless I completely control how the entire interface works.

{% highlight perl %}
my $object = '';

if( ref $_[0] and $_[0]->isa( __PACKAGE__ ) {
    $object = shift;
    }
{% endhighlight %}

The second case expects a string that represents the name of the class, and if that is test is true, I use the private class variable, which in my `DBI::Singleton` example in code listing <a class="internal_link" href="#db_singleton">DB Singleton</a> was `$Dbh`;

{% highlight perl %}
elsif( $_[0]->isa( __PACKAGE__ ) ) {
    my $class = shift;
    $object = $Dbh;
    }
{% endhighlight %}

If none of that works, I can assume that I am using the functional mode, and get the instance from the variable in which I stored it.

{% highlight perl %}
else {
    $object = $Dbh;
    }
{% endhighlight %}

Once I determine how I called the method (or function), I can get on with the real work, although I have to do a few tricks to support all three methods.

Looking at it written out as code I recognize that I am really choosing what `$object` will be, which is a just a contortion of a switch construct.  Perl does not have an explicit switch construct, but I can do just as well with a `do {}` block which, like any other block, returns the last evaluated expression:

{% highlight perl %}
my $instance = do {
    if( ref $_[0] and $_[0]->isa( __PACKAGE__ ) {
        shift;
        }
    elsif( $_[0]->isa( __PACKAGE__ ) ) {
        my $class = shift;
        $Dbh;
        }
    else {
        $Dbh;
        }
    };
{% endhighlight %}

Putting that into absolutely every method or function, however, would take a lot of typing.  A good text editor could do it quickly for me, but the next person who comes along  and has to maintain my code may not have my fancy editor or macros so that is not a good idea either.  Any time I have to type the same code more than a couple of times it is time for a pattern that only requires me to type it once. One way to do this is to use method dispatch.  I could write a wrapper around all methods and functions that does this bit for me, then returns the right thing for the particular mode, but I do not discuss this here.

## Singletons with a life span

I may want my singletons to disappear after some condition is met. Perhaps I should replace the single, remembered instance after a certain time has elapsed, or after a certain number of uses, or anything else that I can dream up.

Suppose that I want my singleton to be recreated if no other references to it exist.  For example, I create some counters as I did in code listing <a class="internal_link" href="#counter.pl">Counter.pl</a>, and when all of the counters are no longer in use, perhaps because they have all gone out of scope, the next request for a counter gives a completely new instance, or re-initializes the old instance, as appropriate.  In my database example in code listing <a class="internal_link" href="#db_singleton">DB singleton</a> I may wish to discard my singleton instance if I do not need the database server for a while so that I do not hold open the connection, and reconnect when I need it again.

I now want to modify the Counter example in code listing <a class="internal_link" href="#counter.pm">Counter.pm</a> so that I only get the same instance as long as some other part of the program is currently using it.  When no part of the program is using the Counter instance, that is, no other program variables reference it, I want the module to create a completely new instance on the next request, which means the next request's counter starts at 0.

If I count the number of times I return an instance, I know how many variables reference my instance. For now, just assume that is true. In code listing <a class="internal_link" href="#counted">Reference counter</a> I create a new class variable to store the number of references to my singleton I think there are.

<a class="ref_name" name="counted">Reference counter</a>

{% highlight perl %}
package Counter;

my $singleton       = undef;
my $reference_count = 0;

sub new {
    my( $class ) = @_;

    if( defined $singleton and $reference_count > 0 ) {
        $reference_count++;
        return $singleton;
        }

    my $self = 0;

    $singleton = bless \$self, $class;

    $reference_count = 1;

    return $singleton;
    }

sub reference_count {
    return $reference_count;
    }

sub value {
    my $self = shift;

    return $$self;
    }

sub increment {
    my $self = shift;

    return ++$$self;
    }

1;
{% endhighlight %}

In `new()` I moved things around so that I could count the number of times I returned a reference to my instance, which I store in `$reference_count`, and I added a class (and instance) method to return the number of references to the singleton.

Now I need to know when the use of a particular reference to my counter has ended so that `$reference_count` reflects reality.  I cannot use `DESTROY` since it only works on the singleton instance when there are no more references to it, but a reference always exists to it since the class variable, `$singleton`, always exists, meaning that perl will never call `DESTROY` on `$singleton`. I could state explicitly that I have finished using a reference by calling a destructor, perhaps called `destroy()`.

{% highlight perl %}
$count3->destroy;
{% endhighlight %}

My destructor, which I have to call explicitly, decrements the reference count and sets the caller to `undef`:

{% highlight perl %}
sub destroy {
    $_[0] = undef;
    $reference_count--;
    }
{% endhighlight %}

This is not good enough because I have to pay extra attention to make sure that I call `destroy()` explicitly and at the right place in the program and at the right time:

{% highlight perl %}
my $count = Counter->new();

$count->increment;
$count->value;

... stuff ...

$count->destroy;
{% endhighlight %}

This still is not good enough because I do not really know when a particular use of the singleton has ended&mdash;I only know when the programmer has remembered to tell the class he is finished with that instance.  For example, suppose that I created a lexical counter, and let the counter go out of scope without calling `destroy()`:

{% highlight perl %}
if( some condition ) {
    my $counter = Counter->new();

    $counter->increment;

    ...stuff...

    $counter->increment;
    }
{% endhighlight %}

Now I have no way to decrement `$reference_count` because `$counter` no longer exists.  Forcing programmers to do such things explicitly is quite unperly.

I also have no way to keep the programmer from making direct, shallow copies of the instance which I cannot count, and I cannot recognize the use of `new()` in a void context, so even though I do not store another reference to the instance, `new()` thinks I did and increments `$reference_count`:

{% highlight perl %}
my $count = Counter->new();

# we do not know this happened
my $count2 = $count;

# new() thinks I stored the return value
Counter->new();
{% endhighlight %}

I can improve this technique with a little black magic. Perl already counts the number of references to data.  Perl's reference count will take into account lexical variables going out of scope and void contexts, and it will do it without my intervention.  If I can look at this reference count then I do not have to count the references myself.

I can use the `SvREFCNT` function from [Devel::Peek](https://www.metacpan.org/pod/Devel::Peek) which gives me the number of references to its arguments, although a lot of people think that [Devel::Peek](https://www.metacpan.org/pod/Devel::Peek) is an unreasonable prerequisite for production code, and I agree.  `Devel::*` modules are for development, in my opinion, but I can use it to get where I need to be, and I would not show this to you if I did not have something even better to replace it. So, if I decide to use [Devel::Peek](https://www.metacpan.org/pod/Devel::Peek), the beginning of my Counter module looks like:

{% highlight perl %}
package Counter;

use Devel::Peek qw(SvREFCNT);

my $singleton;

sub new
    {
    my( $class ) = @_;

    if( defined $singleton and SvREFCNT($singleton) > 1 )
        {
        return $singleton;
        }

    my $self = 0;

    $singleton = bless \$self, $class;

    return $singleton;
    }
{% endhighlight %}

I can get rid of anything that deals with `$reference_count` since Perl keeps track of that for me. After I check to see if `$singleton` is defined, I also check to see how many references to it exist. Remembering that `$singleton` itself counts for one reference, I test to see if there is more than one.  If so, there is another reference somewhere in the program.

If I were really ambitious, I could even implement the reference count code myself in XS code as part of my module and avoid [Devel::Peek](https://www.metacpan.org/pod/Devel::Peek) entirely.

{% highlight text %}
int
ref_count(sv)
   SV* sv;

   CODE:

      RETVAL = SvREFCNT(sv);

   OUTPUT: RETVAL
{% endhighlight %}

Some of you might be thinking why I do not use the `WeakRef` module, since it makes all of this stuff much easier and I do not have to use the [Devel::Peek](https://www.metacpan.org/pod/Devel::Peek) or XS.  The author, Tuomas J. Lukka,  has marked `WeakRef` as experimental. Interestingly, it was originally written so that the author could avoid all of the reference counting mess I just went through since it allows Perl to ignore that fact that `$singleton` counts as one reference and `DESTROY` it when nothing else references it.

If I want to use `WeakRef`, the only thing I have to do is weaken `$singleton`, which signals to  perl that `$singleton` will not count its existence in the reference count. When all of the other, "strong" references to `$singleton` disappear through Perl's normal behavior, perl destroys `$singleton` and I can use `DESTROY` to do anything that I need to do. Afterwards, `$singleton` will be undefined and the next time I try to get an instance I will get a completely new one.

{% highlight perl linenos %}
package Counter;

use WeakRef;

my $singleton = undef;

sub new {
    my( $class, $count ) = @_;

    if( defined $singleton ) {
        return $singleton;
        }

    my $self = 0;

    $singleton = bless \$self, $class;

    weaken $singleton;

    return $singleton;
    }
{% endhighlight %}

In code listing <a class="internal_link" href="#weaken">weaken</a> I weaken `$singleton` in line 20 with the `weaken()` function from `WeakRef` which tells perl not to count the existence of `$singleton` in the reference count to the data which it represents.  Other references to that data, like the reference that I get back from `new()`, do count.  When all of those references disappear, perl destroys `$singleton`.

## Memoized (Modified) Singleton

A memoized singleton returns the same instance for the same arguments to the constructor.  Previously, any call to my constructors returned the same instance no matter the argument list, but this is inadequate for many situations.  I may consider using this modified form of the singleton pattern if I need different instances depending on the argument list, but still want the benefits of the singleton.

### A simple example

Once I have read and parsed a configuration file, I should not have to do it again, although if I need to use it in different parts of the program, I should not have to do too much work to do that.  It looks like I should use a singleton to represent the configuration file.  If I used a pure singleton in which the class can only have one instance, then I can only have one configuration file.  What if I need to look at multiple files, like <code class="filename">.profile</code> and <code class="filename">.bash_profile</code> when I login to a bash shell, or <code class="filename">httpd.conf</code>, <code class="filename">access.conf</code>, and <code class="filename">srm.conf</code> from apache?  A pure singleton will not allow me to represent each of these at the same time from the same class, although they represent the same concept.

I need only one instance for each configuration file so that if I have already parsed the file, I skip all of that work and simply access the information.  To do this, I need to remember which files I have already seen. I can modify my previous singleton examples to use a hash instead of a scalar to remember my instances. The keys of the hash will be the names of the configuration file, and its value will be the configuration file instance that goes with it.

I override the `new()` method from [ConfigReader::Simple](https://www.metacpan.org/pod/ConfigReader::Simple) in code listing <a class="internal_link" href="#config">config</a>.  In code listing <a class="internal_link" href="#config-singleton">Config::Singleton</a>, my memoized version of `new()` turns [ConfigReader::Simple](https://www.metacpan.org/pod/ConfigReader::Simple) into a modified singleton class.

<a class="ref_name" name="config-singleton">Config::Singleton</a>

{% highlight perl linenos %}
package Config::Singleton;

use base qw(ConfigReader::Simple);

my %Configs = ();

sub new {
    my( $class, $file, @args ) = @_;

    return $Configs{$file} if exists $Configs{$file};

    my $object = $class->SUPER::new( $file, @args );
    return $object unless ref $object;

    $Configs{$file} = $object
    }
{% endhighlight %}

In line 5, I declare the hash `%Configs` which I use to store the instances I create in `new()`&mdash;one instance per configuration file with the filename as the key and its instance as the value.  Inside `new()`, at line 11, I check to see if the filename key exists in `%Configs` and if it does, return its value which is the [ConfigReader::Simple](https://www.metacpan.org/pod/ConfigReader::Simple) instance. Otherwise, I continue with `new()` to create a new instance and store it in `%Configs`.

For anything more complex, I have to do more work. How do I recognize that two argument lists are the same?  I cannot use a list of the key for a hash. I could serialize the list so that I end up with a string, perhaps with something like:

{% highlight perl %}
my $key = join "\0", @_;
{% endhighlight %}

But what if the character `"\0"` is a valid within the data?  It is improbable that I will experience a collision with this technique, but it is certainly possible.  How would I differentiate between the list `( "a\0", "b" )` and `( "a", "\0b" )`?

For most of the cases in which I would use a memoized singleton, the [Memoize](https://www.metacpan.org/pod/Memoize) module available on the [Comprehensive Perl Archive Network (CPAN)](http://search.cpan.org)will do all of the hard work.  It digests the argument list and stores the return values for each.  I simply tell [Memoize](https://www.metacpan.org/pod/Memoize) which methods to affect, then move on to the next programming problem.  In this case I only have to memoize the constructor. In code listing <a class="internal_link" href="#config-singleton">Config::Singleton</a> I use [Memoize](https://www.metacpan.org/pod/Memoize) to store the return values of `new()`; this improves code listing <a class="internal_link" href="#config-singleton-memo">Config::Singleton memoized</a> which only used the filename as a key, ignoring any other arguments.

<a class="ref_name" name="config-singleton-memo">Config::Singleton memoized</a>

{% highlight perl linenos %}
package Config::Singleton;

use base qw(ConfigReader::Simple);
use ConfigReader::Simple;

use Memoize;

memoize( qw(new) );

sub new
    {
    my( $class, $file, @args ) = @_;

    my $object = $class->SUPER::new( $file, @args );
    return $object unless ref $object;
    }

1;
{% endhighlight %}

In line 6, I use [Memoize](https://www.metacpan.org/pod/Memoize), and then in line 8, I use the `memoize()` function to perform the magic on `new()`.  I can ensure that [Memoize](https://www.metacpan.org/pod/Memoize) does the right thing by testing [Config::Singleton](https://www.metacpan.org/pod/Config::Singleton) the same way I tested `Counter.pm` in <a class="internal_link" href="#counter.pl">Counter.pl</a>:

{% highlight perl linenos %}
#!/usr/bin/perl

use lib qw(.);

use Config::Singleton;

my $ref1 = Config::Singleton->new( '.profile' );
my $ref2 = Config::Singleton->new( '.bash_profile' );
my $ref3 = Config::Singleton->new( '.profile' );

print $ref1 eq $ref3 ? "Match (Good)!" : "Not Match (Bad)!", "\n";
print $ref1 ne $ref2 ? "Match (Bad)!"  : "Not Match (Good)!", "\n";
{% endhighlight %}

{% highlight text %}
Match (Good)!
Not Match (Good)!
{% endhighlight %}

### Connecting to multiple databases

In my pure singleton example in code listing <a class="internal_link" href="#db_singleton">DB singleton</a> I shared a single database connection. The first time that the program asked to connect to the database my `connect()` method passed the argument list on to the [DBI](https://www.metacpan.org/pod/DBI)'s `connect()` method, then saved the returned database handle if the `connect()` succeed. Each subsequent time I tried to connect I got a reference to the same database connection even if I had asked to connect to a different database.  I had simply ignored the arguments altogether. However, it is completely reasonable  to connect to multiple databases, or the same database multiply, in certain situations.  I have frequently kept two database handles active as I read from one to write to the other.

I need to modify my `connect()` method in the DBI::Singleton package from code listing <a class="internal_link" href="#db_singleton">DB singleton</a> and I have to modify my `$Dbh` to store multiple database handles. I can do the same thing that I did in code listing <a class="internal_link" href="#config-singleton">Config::Singleton</a>.

The `mod_perl` folks solved that problem with [Apache::DBI](https://www.metacpan.org/pod/Apache::DBI), which is an example of a memoized singleton.

Before `mod_perl`, one of the problems with web databases was that each CGI script used its own connection to the database server, and setting up that connection could be the major bottleneck in the program, making the web site seem slow.  The `mod_perl` extension to Apache solved many of the performance problems with CGI scripts, but you still had to connect to the database.  Since `mod_perl` processes stayed in memory between web requests, everything that needed a database connection maintained its own connection, causing resource use problems.

[Apache::DBI](https://www.metacpan.org/pod/Apache::DBI) stores one database connection that all parts of the process can share.  It even pings the database server and re-establishes the connection if need be.  You might already use [Apache::DBI](https://www.metacpan.org/pod/Apache::DBI) without knowing it since [DBI](https://www.metacpan.org/pod/DBI) looks for it when it is loaded with Apache, and will forward connection requests to [Apache::DBI](https://www.metacpan.org/pod/Apache::DBI) if apache has already loaded it. You can inspect the `Apache::DBI::connect()` source code to see how the authors implemented their singleton.

## Conclusion

The Singleton design pattern structures code so that different parts of a program can share a resource without having to work out the details of the sharing. I showed several ways to implement this pattern, but the importance of the pattern is in the structure of the code rather than in its implementation, and different situations may need different implementations.

## References

You can get all modules discussed in this article from the [Comprehensive Perl Archive Network (CPAN)](http://search.cpan.org)

* [CGI](https://www.metacpan.org/pod/CGI)
* [Win32::TieRegistry](https://www.metacpan.org/pod/Win32::TieRegistry)
* [ConfigReader::Simple](https://www.metacpan.org/pod/ConfigReader::Simple)
* [DBI](https://www.metacpan.org/pod/DBI)
* [Apache::DBI](https://www.metacpan.org/pod/Apache::DBI)
* [Memoize](https://www.metacpan.org/pod/Memoize)

You can read more about design patterns in:

* [% te.book( 'Design Patterns', '0201633612' ) %], by
Erich Gamma, Richard Helm, Ralph Johnson, Jon Vlissides; Addison
Wesley, 1995.

