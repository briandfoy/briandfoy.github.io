---
layout: post
title: brian's guide to solving any perl problem
categories: programming
tags: rescued-content guide
stopwords:
last_modified:
---

https://www.perlmonks.org/?node_id=376075

Somebody reminded me that I had this guide sitting around.  I updated s/girlfriend/wife/, and post it here so I remember where to find it.  (I should just check my web page :)

<p>
<b>UPDATE:</b> I've fixed or modified various things based on people's suggestions and responses.  To see the list of changes just read the thread.  Thanks everyone. :)
</p>

<p><a name="__index__"></a></p>
<!-- INDEX BEGIN -->

<ul>

	<li><a href="#name">NAME</a></li>
	<li><a href="#synopsis">SYNOPSIS</a></li>
	<li><a href="#description">DESCRIPTION</a></li>
	<ul>

		<li><a href="#my_philosophy_of_debugging">My Philosophy of Debugging</a></li>
		<li><a href="#my_method">My Method</a></li>
	</ul>

</ul>
<!-- INDEX END -->

<hr />
<p>
</p>
<h1><a name="name">NAME</a></h1>
<p>brian's Guide to Solving Any Perl Problem</p>
<p>
</p>
<hr />
<h1><a name="synopsis">SYNOPSIS</a></h1>
<p>Follow this guide and save your sanity</p>
<p>
</p>
<readmore>
<hr />
<h1><a name="description">DESCRIPTION</a></h1>
<p>
</p>
<h2><a name="my_philosophy_of_debugging">My Philosophy of Debugging</a></h2>
<p>I believe in three things:</p>
<dl>
<dt><strong><a name="item_it_is_not_personal">It is not personal</a></strong><br />
</dt>
<dd>
Forget about code ownership.  You may think yourself an artist, but
even the old Masters produced a lot of crap.  Everybody's code is
crap, which means my code is crap and your code is crap.  Learn to
love that.  When you have a problem, your first thought should be
``Something is wrong with my crappy code''.  That means you do not get
to blame perl.  It is not personal.
</dd>
<dd>
<p>Forget about how <strong>you</strong> do things.  If the way you did things worked,
you would not be reading this.  That is not a bad thing.  It is just
time to evolve.  We have all been there.</p>
</dd>
<p></p>
<dt><strong><a name="item_personal_responsibility">Personal responsibility</a></strong><br />
</dt>
<dd>
If you have a problem with your script it is just that---your problem.
You should do as much to solve it by yourself as you can.  Remember,
everyone else has their own scripts, which means they have their own
problems.  Do your homework and give it your best shot before you
bother someone else with your problems.  If you honestly try
everything in this guide and still cannot solve the problem, you have
given it your best shot and it is time to bother someone else.
</dd>
<p></p>
<dt><strong><a name="item_change_how_you_do_things">Change how you do things</a></strong><br />
</dt>
<dd>
Fix things so you do not have the same problem again.  The problem is
probably <strong>how</strong> you code, not <strong>what</strong> you code.  Change the way you do
things to make your life easier.  Do not make Perl adapt to you
because it will not.  Adapt to Perl.  It is just a language, not a way
of life.
</dd>
<p></p></dl>
<p>
</p>
<h2><a name="my_method">My Method</a></h2>
<dl>
<dt><strong><a name="item_does_your_script_compile_with_strictures%3f">Does your script compile with strictures?</a></strong><br />
</dt>
<dd>
If you are not already using strictures, turn it on.  Perl gurus are
gurus because they use strict which leaves them more time to solve
other problems, learn new things, and upload working modules to CPAN.
</dd>
<dd>
<p>You can turn on strictures within the code with the strict pragma.</p>
</dd>
<dd>
<pre>
        use strict;</pre>
</dd>
<dd>
<p>You can turn on strictures from the command line with perl's -M
switch.</p>
</dd>
<dd>
<pre>
        perl -Mstrict script.pl</pre>
</dd>
<dd>
<p>You may be annoyed at strictures, but after a couple of weeks of
programming with them turned on, you will write better code, spend
less time chasing simple errors, and probably will not need this
guide.</p>
</dd>
<p></p>
<dt><strong><a name="item_what_is_the_warning%3f">What is the warning?</a></strong><br />
</dt>
<dd>
Perl will warn you about a lot of questionable constructs. Turn on
warnings and help Perl help you.
</dd>
<dd>
<p>You can use perl's -w switch in the shebang line.</p>
</dd>
<dd>
<pre>
        #!/usr/bin/perl -w</pre>
</dd>
<dd>
<p>You can turn on warnings from the command line.</p>
</dd>
<dd>
<pre>
        perl -w script.pl</pre>
</dd>
<dd>
<p>You can use lexical warnings with all sorts of interesting features.
See <em>warnings</em> for the details.</p>
</dd>
<dd>
<pre>
        use warnings;</pre>
</dd>
<dd>
<p>If you do not understand a warning, you can look up a verbose version
of the warning in <em>perldiag</em> or you can use the diagnostics pragma in
your code.</p>
</dd>
<dd>
<pre>
        use diagnostics;</pre>
</dd>
<p></p>
<dt><strong><a name="item_solve_the_first_problem_first%21">Solve the first problem first!</a></strong><br />
</dt>
<dd>
After you get error or warning messages from perl, fix the first
message then see if the perl still issues the other messages.  Those
extra messages may be artifacts of the first problem.
</dd>
<p></p>
<dt><strong><a name="item_look_at_the_code_before_the_line_number_in_the_err">Look at the code before the line number in the error message!</a></strong><br />
</dt>
<dd>
Perl gives you warning messages when it gets worried and not before.
By the time perl gets worried the problem has already occurred and the
line number perl is on is actually <strong>after</strong> the problem.  Look at the
couple of expressions before the line number in the warning.
</dd>
<p></p>
<dt><strong><a name="item_is_the_value_what_you_think_it_is%3f">Is the value what you think it is?</a></strong><br />
</dt>
<dd>
Do not guess!  Actually examine the value right before you want to use
it in an expression.  The best debugger in the universe is print.
</dd>
<dd>
<pre>
        print STDERR &quot;The value is ]$value]\n&quot;;</pre>
</dd>
<dd>
<p>I enclose $value in braces so I can see any leading or trailing
whitespace or newlines.</p>
</dd>
<dd>
<p>If I have anything other than a scalar, I use Data::Dumper to print
the data structures.
</p>
</dd>
<dd>
<pre>

        require Data::Dumper;</pre>
</dd>
<dd>
<pre>
        print STDERR &quot;The hash is &quot;, Data::Dumper::Dumper( \%hash ), &quot;\n&quot;;
</pre>

If the value is not what you think it is, back up a few steps and try
again!  Do this until you find the point at which the value stops
being what you think it should be!
</dd>
<dd>
<p>You can also use the built-in perl debugger with perl's -d switch. See
<em>perldebug</em> for details.</p>
</dd>
<dd>
<pre>
        perl -d script.pl</pre>
</dd>
<dd>
<p>You can also use other debuggers or development environments, like a
ptkdb (a graphical debugger based on Tk), Komodo (ActiveState's Perl
IDE based on Mozilla), of Affrus on MacOS X.</p>
</dd>
<p></p>
<dt><strong><a name="item_are_you_using_the_function_correctly%3f">Are you using the function correctly?</a></strong><br />
</dt>
<dd>
I have been programming Perl for quite a long time and I still look at
<em>perlfunc</em> almost every day.  Some things I just cannot keep
straight, and sometimes I am so sleep-deprived that I take leave of
all of my senses and wonder why <code>sprintf()</code> does not print to the
screen.
</dd>
<dd>
<p>You can look up a particular function with the perldoc command and its
-f switch.</p>
</dd>
<dd>
<pre>
        perldoc -f function_name</pre>
</dd>
<dd>
<p>If you are using a module, check the documentation to make sure you
are using it in the right way.  You can check the documentation for
the module using perldoc.</p>
</dd>
<dd>
<pre>
        perldoc Module::Name
</pre>
<dt><strong>Are you using the right special variable?</strong></dt>
</dd>
<dd>
<p>Again, I constantly refer to <em>perlvar</em>.  Well, not really since I
find <em>The Perl Pocket Reference</em> much easier to use.</p>
</dd>
<p></p>
<dt><strong><a name="item_do_you_have_the_right_version_of_the_module%3f">Do you have the right version of the module?</a></strong><br />
</dt>
<dd>
Some modules change behavior between versions.  Do you have the
version of the module that you think you have?  You can check
the module version with a simple perl one-liner.
</dd>
<dd>
<pre>
        perl -MModule::Name -le 'print Module::Name-&gt;VERSION';</pre>
</dd>
<dd>
<p>If you read most of your documentation off of the local machine,
like at <a href="http://www.perldoc.com">http://www.perldoc.com</a> or <a href="http://search.cpan.org,">http://search.cpan.org,</a> then
you are more likely to encounter version differences in documentation.</p>
</dd>
<p></p>
<dt><strong><a name="item_have_you_made_a_small_test_case%3f">Have you made a small test case?</a></strong><br />
</dt>
<dd>
If you are trying something new, or think a particular piece of
code is acting funny, write the shortest possible program to do
just that piece.  This removes most of the other factors from
consideration.  If the small test program does what it thinks it
does, the problem probably is not in that code.  If the program
does not do what you think it does, then perhaps you have found
your problem.
</dd>
<p></p>
<dt><strong><a name="item_did_you_check_the_environment%3f">Did you check the environment?</a></strong><br />
</dt>
<dd>
Some things depend on environment variables.  Are you sure that
they are set to the right thing?  Is your environment the same
that the program will see when it runs?  Remember that programs
intended for CGI programs or cron jobs may see different environments
than those in your interactive shell, especially on different
machines.
</dd>
<dd>
<p>Perl stores the environment in %ENV.  If you need one of those
variables, be ready to supply a default value if it does not
exist, even if only for testing.</p>
</dd>
<dd>
<p>If you still have trouble, inspect the environment.</p>
</dd>
<dd>
<pre>
        require Data::Dumper;
        print STDERR Data::Dumper::Dumper( \%ENV );</pre>
</dd>
<p></p>
<dt><strong><a name="item_have_you_checked_google%3f">Have you checked Google?</a></strong><br />
</dt>
<dd>
If you have a problem, somebody else has probably had that problem.
See if one of those other people posted something to the usenet group
comp.lang.perl.misc by searching Google Groups
(http://groups.google.com). The difference between people who ask
questions on usenet and those who answer them is the ability to use
Google Groups effectively.
</dd>
<p></p>
<dt><strong><a name="item_have_you_profiled_the_application%3f">Have you profiled the application?</a></strong><br />
</dt>
<dd>
If you want to track down the slow parts of the program, have you
profiled it?  Let Devel::SmallProf do the heavy lifting for you.  It
counts the times perl executes a line of code as well as how long it
takes and prints a nice report.
</dd>
<p></p>
<dt><strong><a name="item_which_test_fails%3f">Which test fails?</a></strong><br />
</dt>
<dd>
If you have a test suite, which test fails?  You should be able to
track down the error very quickly since each test will only exercise a
little bit of code.
</dd>
<dd>
<p>If you don't have a test suite, why not make one?  If you have a
really small script, or this is a one-off script, then I will not make
you write a couple of tests.  Anything other than that could really
benefit from some test scripts.  Test::Harness makes this so simple
that you really have no excuse not to do it. If you do not have the
time, perhaps you are wasting too much time debugging scripts without
tests.  MakeMaker is just not for modules after all.</p>
</dd>
<p></p>
<dt><strong><a name="item_did_you_talk_to_the_bear%3f">Did you talk to the bear?</a></strong><br />
</dt>
<dd>
Explain your problem aloud.  Actually say the words.
</dd>
<dd>
<p>For a couple of years I had the pleasure of working with a really good
programmer who could solve almost anything.  When I got really stuck I
would walk over to his desk and start to explain my problem.  Usually
I didn't make it past the third sentence without saying ``Never
mind---I got it''. He almost never missed either.</p>
</dd>
<dd>
<p>Since you will probably need to do this so much, I recommend some sort
of plush toy to act as your Perl therapist so you do not annoy your
colleagues.  I have a small bear that sits on my desk and I explain
problems to him.  My wife does not even pay attention when I
talk to myself anymore.</p>
</dd>
<p></p>
<dt><strong><a name="item_does_the_problem_look_different_on_paper%3f">Does the problem look different on paper?</a></strong><br />
</dt>
<dd>
You have been staring at the computer screen, so maybe a different
medium will let you look at things in a new way.  Try looking at
a print-out of your program.
</dd>
<p></p>
<dt><strong><a name="item_have_you_watched_the_daily_show_with_jon_stewart%3">Have you watched The Daily Show with Jon Stewart?</a></strong><br />
</dt>
<dd>
Seriously.  Perhaps you do not like Jon Stewart, so choose something
else.  Take a break.  Stop thinking about the problem for a bit and
let your mind relax.  Come back to the problem later and the fix may
become immediately apparent.

</dd>
<p></p>
<dt><strong><a name="item_have_you_packed_your_ego%3f">Have you packed your ego?</a></strong><br />
</dt>
<dd>
If you still have not made it this far, the problem may be
psychological. You might be emotionally attached to a certain part of
the code, so you do not change it.  You might also think that everyone
else is wrong but you.  When you do that, you do not seriously
consider the most likely source of bugs---yourself.  Do not ignore
anything.  Verify everything.
</dd>
</dl>

</readmore>

<!-- Node text goes above. Div tags should contain sig only -->
<div class="pmsig"><div class="pmsig-366986">
-- <br />
brian d foy <bdfoy@cpan.org>
</div></div>
