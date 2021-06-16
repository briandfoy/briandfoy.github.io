---
layout: post
title: FAILing Perl's regexes
categories:
tags:
stopwords:
last_modified:
original_url:
---

The article goes here

#!/Users/brian/bin/perls/perl5.28.0
use v5.26;
use utf8;
use strict;
use warnings;

$_ = 250;

say "<$_> Matched!" if /
      	^ (\d+) \z
      	(?(?{ ! (0 < $1 and $1 < 256) })(*FAIL))
    /x;

say '-' x 70;

"123" =~ / \A (\d+) (?(1)
	(?{ say "Number <$1>!" })
	  |
	(?{ say "Not a Number!" })
	) /x;

say '-' x 70;

"OneTwoThree" =~ / \A (\d+) (?(1)
	(?{ say "Number <$1>!" })
	  |
	(?{ say "Not a Number!" })
	) /x;

__END__

https://stackoverflow.com/questions/14091965/conditional-regular-expression-with-perl

(a)?b(?(1)c|d)

https://www.regular-expressions.info/conditional.html
