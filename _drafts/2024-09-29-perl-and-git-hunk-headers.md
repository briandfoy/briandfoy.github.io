---
layout: post
title: Perl and Git hunk headers
categories: git
tags: git
stopwords:
last_modified:
original_url:
---

<!--more-->

I'm procrastinating by going through my huge folder of things I meant to look at again a week later, and Ævar Arnfjörð Bjarmason's post [Let's add Git userdiff defaults for Perl and Perl 6](https://blogs.perl.org/users/aevar_arnfjor_bjarmason/2010/08/lets-add-git-userdiff-defaults-for-perl-and-perl-6.html) from over decade ago seemed like something suitable. Rob Hoelz had a similar article in [How Does Git Know What Functions Look Like?](https://hoelz.ro/blog/how-does-git-know-what-functions-look-like).

Back in the day, git didn't have Perl patterns for its hunk headers, which is why Ævar used the git diff driver settings to create a regex for Perl. Now git has [perl patterns in userdiff.c](https://github.com/git/git/blob/3857aae53f3633b7de63ad640737c657387ae0c6/userdiff.c#L271).

But, I found a few other things while investigating this that weren't immediately apparent.

Git figures out how to handle files based on their filename and some default settings. If I don't like how it categorizes a file, I can give it hints in the repo's *.gitattributes* file.

But, I want my settings to apply to all of my projects. Instead of making changes in (or even adding the) *.gitatttributes* file for every repo, I want global (git's term for user, instead of system) settings. This affects the setting in my global (user) *.gitconfig* file (so *~/.gitconfig):

{% highlight plain %}
 %  git config --global core.attributesfile /Users/brian/.gitattributes
{% endhighlight %}

In whatever *.gitattributes* I set up, I tell git which file extensions I want to use the `perl` diff driver:

{% highlight plain %}
*.pl diff=perl
*.pm diff=perl
{% endhighlight %}

Here are the patterns

{% highlight plain %}
PATTERNS("perl",
	 "^package .*\n"
	 "^sub [[:alnum:]_':]+[ \t]*"
		"(\\([^)]*\\)[ \t]*)?" /* prototype */
		/*
		 * Attributes.  A regex can't count nested parentheses,
		 * so just slurp up whatever we see, taking care not
		 * to accept lines like "sub foo; # defined elsewhere".
		 *
		 * An attribute could contain a semicolon, but at that
		 * point it seems reasonable enough to give up.
		 */
		"(:[^;#]*)?"
		"(\\{[ \t]*)?" /* brace can come here or on the next line */
		"(#.*)?$\n" /* comment */
	 "^(BEGIN|END|INIT|CHECK|UNITCHECK|AUTOLOAD|DESTROY)[ \t]*"
		"(\\{[ \t]*)?" /* brace can come here or on the next line */
		"(#.*)?$\n"
	 "^=head[0-9] .*",	/* POD */
	 /* -- */
	 "[[:alpha:]_'][[:alnum:]_']*"
	 "|0[xb]?[0-9a-fA-F_]*"
	 /* taking care not to interpret 3..5 as (3.)(.5) */
	 "|[0-9a-fA-F_]+(\\.[0-9a-fA-F_]+)?([eE][-+]?[0-9_]+)?"
	 "|=>|-[rwxoRWXOezsfdlpSugkbctTBMAC>]|~~|::"
	 "|&&=|\\|\\|=|//=|\\*\\*="
	 "|&&|\\|\\||//|\\+\\+|--|\\*\\*|\\.\\.\\.?"
	 "|[-+*/%.^&<>=!|]="
	 "|=~|!~"
	 "|<<|<>|<=>|>>"),
{% endhighlight %}

Those patterns only match against lines that aren't shown in the hunk. For example, if you change the first line after the line that has `sub`, the  line shows up as part of the hunk context and is not searched for hunk header pattern.

That threw me for a bit, but I guess it makes sense when. you can see the subroutine in the context. Things would be much more complicated if git tried to do this in some other way than line-oriented matching on stuff before the context.

Let's start with this file, which has a mix of the things that the Perl patterns will match:

{% highlight perl %}
use v5.40;

=head1 NAME

hunk-header-demo.pl - some some git diffs

=head1 SYNOPSIS

	% hunk-header-demo.pl

=cut

package Local::HunkHeader;

my $string <<~'HERE';
	first line
	second line
	third line
	last line
	HERE

sub first_foo {
	# this is a comment
	say "First";
	}

sub second_bar {
	# this is a comment
	say "First";
	}

1;
{% endhighlight %}

Commit this, then add a line after the `package` line. Run `git diff`:

{% highlight plain %}
$ git diff
diff --git a/hunk-header-demo.pl b/hunk-header-demo.pl
index 0859b04..996bced 100644
--- a/hunk-header-demo.pl
+++ b/hunk-header-demo.pl
@@ -12,6 +12,8 @@ =head1 SYNOPSIS

 package Local::HunkHeader;

+my $foo = "Hello";
+
 my $string <<~'HERE';
        first line
        second line
{% endhighlight %}

The hunk header is the line that starts with `@@`:

{% highlight plain %}
@@ -12,6 +12,8 @@ =head1 SYNOPSIS
{% endhighlight %}

But that's not the immediate section of the code that that change is in! The problem is that `package Local::HunkHeader;` is in the context of the hunk, so it's lines aren't matched against the patterns. The closest pattern that matches is for the Pod `=head` line, and that's the line it chooses for the hunk header.

Discard those changes and make a different change. Add a line immediately after the `sub first_foo {` line and diff again. Now the pattern picks up the `package` line even  though the change is inside a subroutine. Again, the `sub` line shows up in the context:

{% highlight plain %}
$ git diff
diff --git a/hunk-header-demo.pl b/hunk-header-demo.pl
index 0859b04..2d923bb 100644
--- a/hunk-header-demo.pl
+++ b/hunk-header-demo.pl
@@ -20,6 +20,7 @@ package Local::HunkHeader;
        HERE

 sub first_foo {
+       my $foo = "Hello";
        # this is a comment
        say "First";
        }
{% endhighlight %}

Discard the changes again and move that line between the subroutines (so it's not in the subroutines):

{% highlight plain %}
$ git diff
diff --git a/hunk-header-demo.pl b/hunk-header-demo.pl
index 0859b04..12bb07a 100644
--- a/hunk-header-demo.pl
+++ b/hunk-header-demo.pl
@@ -24,6 +24,8 @@ sub first_foo {
        say "First";
        }

+my $foo = "Hello";
+
 sub second_bar {
        # this is a comment
        say "First";
{% endhighlight %}

Now the hunk header has the `sub first_foo` line, even though the line is not in that subroutine. Git isn't trying to figure out which syntactical structure contains the change, but the last pattern it matched that determines the opening of a structure. When that pattern matches a line outside the context of the hunk, Git notes that something started and that's what it will use in the hunk header. It doesn't think about when a structure ends; it merely detects line that matches a pattern. When something else starts, that previous thing must have closed.

Discard those changes. Now put the package name on a different line from the `package` keyword (a trick to hide an unauthorized or secret package from the PAUSE indexer):


{% highlight perl %}
package
	Local::HunkHeader;
{% endhighlight %}

Commit that change, then change part of `$string`:

{% highlight perl %}
my $string <<~'HERE';
	first line
	second line
	3rd line
	last line
	HERE
{% endhighlight %}

Now the patterns skip over the `pqackage` line for the hunk header:

{% highlight text %}
$ git diff
diff --git a/hunk-header-demo.pl b/hunk-header-demo.pl
index b4bc84e..1697477 100644
--- a/hunk-header-demo.pl
+++ b/hunk-header-demo.pl
@@ -16,7 +16,7 @@ =head1 SYNOPSIS
 my $string <<~'HERE';
        first line
        second line
-       third line
+       3rd line
        last line
        HERE
{% endhighlight %}

This picks up `=head1` for the hunk header since that was the last pattern to match, and those patterns won't match across lines.

Try something different. Add a lexical subroutine to `first_foo` and commit the result.

{% highlight perl %}
sub first_foo {
	# this is a comment
	say "First";

	my sub baz {
		# this is a comment
		say "First in baz";
		my $n = 1 + 2;
		say "last in baz";
		}
	}
{% endhighlight %}

The patterns don't pick up the `my sub`. The closest pattern is `^sub [[:alnum:]_':]+[ \t]*`, but that matches at the start of a line:

{% highlight perl %}
$ git diff
diff --git a/hunk-header-demo.pl b/hunk-header-demo.pl
index b994f50..29cd064 100644
--- a/hunk-header-demo.pl
+++ b/hunk-header-demo.pl
@@ -26,7 +26,7 @@ sub first_foo {
        my sub baz {
                # this is a comment
                say "First in baz";
-               my $n = 1 + 2;
+               my $n = 2 + 5;
                say "last in baz";
                }
        }
{% endhighlight %}

I can try to fix this with my own pattern in
