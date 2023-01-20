---
layout: post
title: A format for RPSL
categories:
tags: perl programming
stopwords: perlform printf reselect
last_modified:
original_url:
---

The [Routing Policy Specification Language](https://www.rfc-editor.org/rfc/rfc2622) is a pain in the ass, but at least it's not XML. A RPSL object is a bunch of key-value pairs, with possible multiline values and comments (for example, [RIPE's files](https://ftp.ripe.net/ripe/dbase/)). Here's a simple example for format (but not validity):

<!--more-->

{% highlight text %}
route:      1.2.3.4/32
origin:     AS64512
admin-c:    FOO
tech-c:     FOO
remarks:    This is the first line
            This is a continuation line
            This is another remark line
source:     SomeIRR
{% endhighlight %}

The first thorn is the colon after the field name. Your first thought might be like mine: a `printf` with two format specifiers:

{% highlight perl %}
printf "%s: %s\n", $field, $value;
{% endhighlight %}

This simple format loses the column alignment, and doesn't add the beginning whitespace RPSL needs for the continuation lines:

{% highlight text %}
route: 1.2.3.4/32
origin: AS64512
admin-c: FOO
tech-c: FOO
remarks: This is the first line
This is a continuation line
This is another remark line
source: SomeIRR
{% endhighlight %}

Just make the field format a fixed width to get that alignment:

{% highlight perl %}
printf "%-12s: %s\n", $field, $value;
{% endhighlight %}

The field names are shorter than the field width so the placeholder is padded, which moves the colon away from the shorter names:

{% highlight text %}
route       : 1.2.3.4/32
{% endhighlight %}

I fixed this by moving the colon from the template to the value so it would be at the end of the field name and

{% highlight perl %}
printf "%-13s %s\n", "$field:", $value;
{% endhighlight %}

With a little tortured logic, I can get this same template to work for continuation lines too since the first placeholder can be empty.

## How about formats?

Sometimes we follow these paths further than we should and don't consider other alternatives. A co-worker half-jokingly suggested Perl's formats might work, but neither of us followed up on that because we weren't going to do that in production anyway. Still, the task gnawed at me and I had to give it a try just so I could stop thinking about it. Here's a RPSL formatter using `format`:

{% highlight perl %}
use v5.36;
use vars qw($k $v);

format RPSL =
^<<<<<<<<<<<    ^*
$k,             $v
~~              ^*
                $v
.

my %hash = (
    _class_key => 'route',  # this key needs to be first
    route      => '1.2.3.4/12',
    origin     => 'AS237',
    remarks    => "first line\nsecond line\nthird line\n",
    address    => "1234 Main St\nAnytown, MI 12345",
    'admin-c'  => 'MAINT-AS237',
    );

# just do the first line, which is the class key
my $field = delete $hash{_class_key};
do_field( $field, delete $hash{$field} );

# the rest of the fields
foreach my $key ( keys %hash ) {
    do_field( $key, $hash{$key} );
    }

# Add the rest of the fields
sub do_field ( $field, $value ) {
    my $old_handle = select(STDOUT);
    local $~ = "RPSL";  # name of format to use for current filehandle
    local $k = "$field:";
    local $v = $value;
    write STDOUT;
    select $old_handle;
    }
{% endhighlight %}

This gets me the nicely formatted object where the multiline address and remarks value are nicely aligned:

{% highlight text %}
route:          1.2.3.4/12
address:        1234 Main St
                Anytown, MI 12345
origin:         AS237
admin-c:        MAINT-AS237
remarks:        first line
                second line
                third line
{% endhighlight %}

Since this is a pre-v5 feature, it doesn't work with the things that Perl 5 gave us: lexical filehandles and variables. I have to work with the Perl 4 bareword filehandles and package variables.

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/vQA5aLctA0I" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
</div>


Perl's `format` has some implicit knobs and dials, and most of them are at least distasteful in today's world. When I call `write STDOUT`, it looks for a format of the same name as the bareword filehandle. Or, more correctly, it looks in the `$~` per-filehandle variable that specifies the format name, which is the same as the filehandle name by default.  Since I've named my format `RPSL`, I have to set the per-filehandle variable `$~` to the name of the format I want to use. To do that properly, I need to first `select` the filehandle I want in case it's not currently the default, change the value of `$~` to the one I want, and at the end, reselect the previous default filehandle to undo my mess. I can't do this just once because someone else may have changed the defaults for their own purposes. It's essentially global variable hell.

I also have to set the package variables `$k` and `$v` since those are the package variables I use in the format. It's the global variable problem again, so I liberally use `local` to restore their previous values at the end of the scope.

Sure, it's ugly, but I've also compartmentalized it in the `do_field` subroutine. I'll come back to that in a moment because I'm still in the land of formats. Just know that all the ugliness is in one place.

The template itself isn't that tricky, although I did read through the [original formats chapter from the first edition of Learning Perl](https://www.learning-perl.com/2014/07/formats/) and check the [perlform docs](https://perldoc.perl.org/perlform). I used to use formats a lot (mostly for paginated output I'd have to print on dead trees), but I haven't touched them for years. I knew what I wanted to do and that formats could do it, but I'd forgotten it's tricky syntax.

Here's just the format again:

{% highlight perl %}
format RPSL =
^<<<<<<<<<<<    ^*
$k,             $v
~~              ^*
                $v
.
{% endhighlight %}

The basic setup is easy. There's the first `format` line that specifies the name, and the `.` line that ends it. Between those two lines are couplets of a template line and a variables line.

The first template line is simple: there's a fixed-width field and a variable width field. No big whoop. At least, it's no big whoop until `$v` has multiple lines (so, embedded newlines). The first template line only formats that first embedded line in `$v` and defers on the rest of the lines in `$v`.

It's the second couplet that is the one that makes `format` an interesting feature for RPSL objects. The `~~`, line tells the format to only use this part of the template as long as there are data the variables that it hasn't yet formatted; this handles the continuation lines in the RPSL values. If Perl has completely used up the value in `$v`, it doesn't process the `~~` line. Otherwise, it takes the next line from `$v` and uses that to fill in the template. After it fills in this template, it looks at `$v` again to see if it still has data to format, and if so, the `~~` does its work again. It keeps doing this until `$v` is exhausted.

The only ugly thing about that is the bareword filehandles. And the per-filehandle settings. The two things that are ugly are the bareword filehandles, per-filehandle settings, and the global variables. I did have to know the format, including the field width ahead of time, but that's not such a big deal.

## Perl6::Form

Generally I try to use built-in features if I can get them to work, but there are various modules, such as [Perl6::Form](https://metacpan.org/pod/Perl6::Form), that get away from the built-in `format` problems. Here's `do_field` reimplemented for that (with no other code changes):

{% highlight perl %}
sub do_field ( $field, $value ) {
    state $rc = require Perl6::Form;
    print form {layout=>"tabular"},
     '{[[[[[[[[[[}    {[[[[[[[[[[}',
      "$field:",      $value;
    }
{% endhighlight %}

That's certainly simpler in the code I typed out, but it also requires another dependency to get to the same place I was before. How much that matters is a personal decision though.

I basically lifted that example out of the [Perl6::Form](https://metacpan.org/pod/Perl6::Form) docs and it worked. But, that module has its own problems. Damian Conway solves tricky problems in amazing ways that cover lots of cases, but those amazing ways have their own knobs and dials. This example came from the multiline section that noted that I needed to set the `layout` type to get it to work correctly.




