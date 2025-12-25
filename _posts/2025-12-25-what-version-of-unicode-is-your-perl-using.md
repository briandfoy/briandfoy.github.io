---
layout: post
title: What version of Unicode is your Perl using?
categories: perl unicode
tags:
stopwords:
last_modified:
original_url:
---

Most versions of Perl (v5.38, v5.40, and so on) updates the Unicode Character Database (UCD), and each version of the UCD has new features, often new blocks, characters, or adjustments to property settings. But, which version do you have?

I tried this task a long time ago, in some place I don't remember, looking at the presence of properties and other things, but I don't want to create a long chain of things to query to rule out versions. That's just too much work if I can cheat.

<!--more-->

First, the Unicode data files are embedded in the Perl distribution. Look for them in the *lib/<VERSION>/unicore/* directory inside the perl installation, for example, *lib/5.42.0/unicore/*.

The version is in *lib/<VERSION>/unicore/version*, but you don't need to look in that file and it's a bit annoying to construct the path. There is a module in that directory, but you can't use `perldoc -l` to get its path since it contains no pod:

{{% highlight "text" %}}
$ perldoc -l unicore::Name
No documentation found for "unicore::Name".
{{% endhighlight %}}

Getting the right path is a bit weird because the path might be a symlink, so I need to get the final path:

{{% highlight "text" %}}
$ which perl
/Users/brian/bin/perl
$ readlink -f $(which perl)
/usr/local/perls/perl-5.42.0/bin/perl5.42.0
$ $ readlink -f $(which perl) | xargs perl -e '$ARGV[0] =~ s|bin/perl([^/]+)\z|lib/$1/unicore/version|; print scalar <<>>'
16.0.0
{{% endhighlight %}}

That works, but is a bit annoying. There's another way that took me a minute to discover; buried in [Unicode::UCD](https://metacpan.org/pod/Unicode::UCD) is the `UnicodeVersion` function, all the way back to v5.8:

{{% highlight "text" %}}
$ perl -MUnicode::UCD -E 'say Unicode::UCD::UnicodeVersion()'
16.0.0
$ perl5.8.9 -MUnicode::UCD -e 'print Unicode::UCD::UnicodeVersion()'
5.1.0
{{% endhighlight %}}

Finally, if you screw around with the stuff in *unicore/*, perhaps in an attempt to upgrade the UCD version in a perl installation, that's on you. Don't do that.

## Further reading

* [tchrist's answer to "How to identify programmatically in Java which Unicode version supported?"](https://stackoverflow.com/a/6942982/2766176)
