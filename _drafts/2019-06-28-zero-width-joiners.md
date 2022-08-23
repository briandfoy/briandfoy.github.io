---
layout: post
title: Zero-width joiners
categories:
tags:
stopwords:
last_modified:
original_url:
---

<!--more-->

$ perl -le 'print join "\x{200D}", "\N{BLACK CIRCLE}"


https://emojipedia.org/variation-selector-16/

$ perl5.30.0 -C -le 'print "\N{HEAVY BLACK HEART}\N{VARIATION SELECTOR-16}"'
❤️

🔥 U+1F525


U+20E COMBINING ENCLOSING KEYCAP
1 U+31
️ U+FE0F
⃣ U+20E3

$ perl5.30.0 -C -le 'print "1\x{FE0F}\x{20E3}"'
1️⃣
brian@otter mojolicious.io  (master)[3279]
$ perl5.30.0 -C -le 'print "1\x{FE0F}"'
1️
brian@otter mojolicious.io  (master)[3280]
$ perl5.30.0 -C -le 'print "1"'
1



https://www.bram.us/2018/03/19/emoji-compositions/
https://blog.emojipedia.org/fun-emoji-hacks/

http://unicode.org/faq/vs.html

<222A, FE00>,

http://www.unicode.org/Public/emoji/5.0/emoji-variation-sequences.txt
https://stackoverflow.com/questions/42679712/why-does-the-red-heart-emoji-require-two-code-points-but-the-other-colored-hear
https://stackoverflow.com/questions/38100329/some-emojis-e-g-have-two-unicode-u-u2601-and-u-u2601-ufe0f-what-does

1F3FB - EMOJI MODIFIER FITZPATRICK

U+FE0E	VARIATION SELECTOR-15	text style
U+FE0F	VARIATION SELECTOR-16	emoji style

http://www.unicode-symbol.com/u/200D.html


https://unicode.org/emoji/charts/emoji-variants.html
https://www.unicode.org/versions/Unicode11.0.0/ch23.pdf#page=19

http://unicode.org/Public/UCD/latest/ucd/StandardizedVariants.txt
0030 FE00; short diagonal stroke form; # DIGIT ZERO
2205 FE00; zero with long diagonal stroke overlay form; # EMPTY SET
2229 FE00; with serifs; # INTERSECTION
222A FE00; with serifs; # UNION
2268 FE00; with vertical stroke; # LESS-THAN BUT NOT EQUAL TO
2269 FE00; with vertical stroke; # GREATER-THAN BUT NOT EQUAL TO
2272 FE00; following the slant of the lower leg; # LESS-THAN OR EQUIVALENT TO
2273 FE00; following the slant of the lower leg; # GREATER-THAN OR EQUIVALENT TO
# The following two entries were originally defined for Unicode 3.2
# but were determined to be in error and were removed from the list
# of standardized variation sequences. The entries are left commented out
# in the file for the historical record of changes made to the data.
#2278 FE00; with vertical stroke; # NEITHER LESS-THAN NOR GREATER-THAN
#2279 FE00; with vertical stroke; # NEITHER GREATER-THAN NOR LESS-THAN
228A FE00; with stroke through bottom members; # SUBSET OF WITH NOT EQUAL TO
228B FE00; with stroke through bottom members; # SUPERSET OF WITH NOT EQUAL TO
2293 FE00; with serifs; # SQUARE CAP
2294 FE00; with serifs; # SQUARE CUP
2295 FE00; with white rim; # CIRCLED PLUS
2297 FE00; with white rim; # CIRCLED TIMES
229C FE00; with equal sign touching the circle; # CIRCLED EQUALS
22DA FE00; with slanted equal; # LESS-THAN EQUAL TO OR GREATER-THAN
22DB FE00; with slanted equal; # GREATER-THAN EQUAL TO OR LESS-THAN
2A3C FE00; tall variant with narrow foot; # INTERIOR PRODUCT
2A3D FE00; tall variant with narrow foot; # RIGHTHAND INTERIOR PRODUCT
2A9D FE00; with similar following the slant of the upper leg; # SIMILAR OR LESS-THAN
2A9E FE00; with similar following the slant of the upper leg; # SIMILAR OR GREATER-THAN
2AAC FE00; with slanted equal; # SMALLER THAN OR EQUAL TO
2AAD FE00; with slanted equal; # LARGER THAN OR EQUAL TO
2ACB FE00; with stroke through bottom members; # SUBSET OF ABOVE NOT EQUAL TO
2ACC FE00; with stroke through bottom members; # SUPERSET OF ABOVE NOT EQUAL TO
FF10 FE00; short diagonal stroke form; # FULLWIDTH DIGIT ZERO
