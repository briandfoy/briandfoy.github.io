---
layout: post
title: Force feeding Unicode to LaTeX's listing package
categories:
tags: latex
stopwords:
last_modified:
original_url:
---

I've had a long history with LaTeX, but I'm not really a fan. Thirty years ago it was amazing. I used it in my former life as a scientist and I used it to start *The Perl Review*, a magazine I formerly published. I'm once again exploring it to composite and typeset my book [Mojolicious Web Clients](https://leanpub.com/mojo_web_clients).

Today TeX just clunky and it's Unicode support is the best demonstration of that. It's former glory came from a world where any
solution might have seemed state of the art. Producing output for any device—a major breakthrough at the time—diminishes in the face of HTML, CSS, and "responsive design". The world is so much different now that TeX would not have been invented if didn't already exist.

Before I go on, though, there are two main things that TeX and friends have going for it that make it worth my time to sort out these problems: I can automate it, and it's free. I can also automate Antenna House, but I don't want to pay $3,000 a year for it. I can automate InDesign, but don't want to buy an Adobe subscription for it. I have not looked into automating [Affinity Publisher](https://affinity.serif.com/en-us/publisher/#top), which I have purchased for a reasonable, one-time fee. I want to publish  [Mojolicious Web Clients](https://leanpub.com/mojo_web_clients) often. I should be able to fix a typo and quickly generate all forms of the new version (ePub, Mobi, PDF, and HTML).

It's not really TeX's fault though. Knuth created it in 1978, and Pike and Thompson didn't come up with UTF-8 until the end of 1992. You'll find similar clunkiness in Unicode in systems designed before 1992 when they committed to the idea that the encoding would be fixed. That's why some things force UCS-2 or UTF-16 on you.

Along with that, it's not TeX's fault that some very popular packages don't handle Unicode well. In particular, the [listings package](https://ctan.math.illinois.edu/macros/latex/contrib/listings/listings.pdf), first released in 1996, has a particularly tough time with this. UTF-8 didn't immediately dominate the world.

Alternate processors, such as XeTeX and LuaLaTeX, claim to handle UTF-8, but that's a bit deceiving for the casual user. Sure, they can read UTF-8 files, but that doesn't mean they make the output you want. This failure is partly due to its silent, non-failing method of simply ignoring characters for which the current font has no glyph. Since the spirit of TeX wants you to not think about fonts, it doesn't do much to help you think about them. The Computer Modern fonts are now quite
quaint (much in the way anything Modern is).

To cap all of this, most people who answer questions on [tex.stackexchange.com](https://tex.stackexchange.com) are merely cargo-culting things that worked for them. You'll often read people asking for or talking about an "MWE" (Minimal working example), but they provide something less than that because they do not specify how they compile it. They have limited requirements, such as presenting a particular accented character correctly, so they come up with preplexing hacks that only work for them in their situation and don't help someone else. Their last line of defense is their elevation of speed over correctness.

Sometimes things just work




![]()

I mentioned the **listings** package before. Many people have problems
with Latin-1 characters or national codeset characters. Consider the advice in [Listings in Latex with UTF-8 (or at least german umlauts)](https://stackoverflow.com/q/1116266/2766176). Most answers are long lists of language-specific alphabetic mappings to TeX sequences:

{% highlight tex %}
\lstset{literate=%
{Ö}{{\"O}}1
{Ä}{{\"A}}1
{Ü}{{\"U}}1
{ß}{{\ss}}2
{ü}{{\"u}}1
{ä}{{\"a}}1
{ö}{{\"o}}1
}
{% endhighlight %}

If you can't represent the character as a combination of things that TeX already knows about, you're still stuck. Not only that, the advice only seems to work.


Some advice naïvely suggest that you replace **listings** with [listingsutf8](https://ctan.org/pkg/listingsutf8?lang=en). From the name you'd think that would understand Unicode. However, it merely maps some UTF-8 characters into single-octet 8-bit characters. It can still only handle 255 characters. It's basically the same advice with fewer steps. Curiously, the CJK world seems to have an easier time with it because they are already so different that they needed [completely different solutions](https://tex.stackexchange.com/q/17143/130987).


Consider this small document with has some body text and some literal text. Both use literal characters for copyright (U+00A9) and snowflake (U+2744). The first is within the 8-bit, single-octet region and has its own TeX sequence (`\copyright`). The other has three octets in UTF-8:

{% highlight tex %}
\documentclass[b5paper,12pt]{book}

\usepackage{fontspec}
\setmainfont{DejaVuSans}
\setmonofont{DejaVuSansMono}

\usepackage{listings}

\begin{document}

Some text with a copyright sign © and a snowflake ❄.

\lstset{aboveskip=1em}
\begin{lstlisting}
copyright sign © and a snowflake❄
\end{lstlisting}

\end{document}
{% endhighlight %}

It works.

![Snowflake and Copyright](/images/arrow-snowflake-body.png)

But it doesn't really work. Change the listing to remove the space before the snowflake; imagine this is computer code where these characters appear next to other non-space characters:

{% highlight tex %}
\begin{lstlisting}
copyright sign © and a snowflake❄
\end{lstlisting}
{% endhighlight %}

Now it doesn't work. The snowflake character shows up before the word snowflake:

![Snowflake in incorrect position](/images/snowflake-before.png)

The answer in [Listings in Latex with UTF-8 (or at least german umlauts)](https://stackoverflow.com/q/1116266/2766176) solved this problem by translating the UTF-8 character into a national encoding then using that character. It solved the problem by eliminating it. You can't just wish characters into the cornfield.

Then I ran into [Typesetting UTF8 APL code with the LaTeX lstlisting package](https://analyzethedatanotthedrivel.org/2011/08/15/typesetting-utf8-apl-code-with-the-latex-lstlisting-package/) where Jon Baker has this problem typesetting APL, an early programming language that had it's own keyboard for its wacky mathematical symbols. He referenced [The 'listings' package and UTF-8](https://tex.stackexchange.com/a/25396/130987) that hacked the character table for **listings** to add the codepoints it should understand.

The first block of codepoints is for the the upper half of the 8-bit range (0x80 to 0xff). I can then add a four digit hex code (lowercase!) for other characters. If I add the snowflake's codepoint, it works out:

{% highlight tex %}
\documentclass[b5paper,12pt]{book}

\usepackage{fontspec}
\setmainfont{DejaVuSans}
\setmonofont{DejaVuSansMono}

\usepackage{listings}
\makeatletter
\lst@InputCatcodes
\def\lst@DefEC{%
 \lst@CCECUse \lst@ProcessLetter
  ^^80^^81^^82^^83^^84^^85^^86^^87^^88^^89^^8a^^8b^^8c^^8d^^8e^^8f%
  ^^90^^91^^92^^93^^94^^95^^96^^97^^98^^99^^9a^^9b^^9c^^9d^^9e^^9f%
  ^^a0^^a1^^a2^^a3^^a4^^a5^^a6^^a7^^a8^^a9^^aa^^ab^^ac^^ad^^ae^^af%
  ^^b0^^b1^^b2^^b3^^b4^^b5^^b6^^b7^^b8^^b9^^ba^^bb^^bc^^bd^^be^^bf%
  ^^c0^^c1^^c2^^c3^^c4^^c5^^c6^^c7^^c8^^c9^^ca^^cb^^cc^^cd^^ce^^cf%
  ^^d0^^d1^^d2^^d3^^d4^^d5^^d6^^d7^^d8^^d9^^da^^db^^dc^^dd^^de^^df%
  ^^e0^^e1^^e2^^e3^^e4^^e5^^e6^^e7^^e8^^e9^^ea^^eb^^ec^^ed^^ee^^ef%
  ^^f0^^f1^^f2^^f3^^f4^^f5^^f6^^f7^^f8^^f9^^fa^^fb^^fc^^fd^^fe^^ff%
  ^^^^2744%
  ^^00}
\lst@RestoreCatcodes
\makeatother

\begin{document}

Some text with a copyright sign © and a snowflake ❄.

\lstset{aboveskip=1em}
\begin{lstlisting}
copyright sign © and a snowflake ❄
\end{lstlisting}

\end{document}
{% endhighlight %}

![Snowflake in correct position](/images/snowflake-after.png)

So, solved, right? What about combining characters? Can I make a dotless ı (U+0131) with a combining diaeresis (U+0308)?

{% highlight tex %}
\makeatletter
\lst@InputCatcodes
\def\lst@DefEC{%
 \lst@CCECUse \lst@ProcessLetter
  ^^80^^81^^82^^83^^84^^85^^86^^87^^88^^89^^8a^^8b^^8c^^8d^^8e^^8f%
  ^^90^^91^^92^^93^^94^^95^^96^^97^^98^^99^^9a^^9b^^9c^^9d^^9e^^9f%
  ^^a0^^a1^^a2^^a3^^a4^^a5^^a6^^a7^^a8^^a9^^aa^^ab^^ac^^ad^^ae^^af%
  ^^b0^^b1^^b2^^b3^^b4^^b5^^b6^^b7^^b8^^b9^^ba^^bb^^bc^^bd^^be^^bf%
  ^^c0^^c1^^c2^^c3^^c4^^c5^^c6^^c7^^c8^^c9^^ca^^cb^^cc^^cd^^ce^^cf%
  ^^d0^^d1^^d2^^d3^^d4^^d5^^d6^^d7^^d8^^d9^^da^^db^^dc^^dd^^de^^df%
  ^^e0^^e1^^e2^^e3^^e4^^e5^^e6^^e7^^e8^^e9^^ea^^eb^^ec^^ed^^ee^^ef%
  ^^f0^^f1^^f2^^f3^^f4^^f5^^f6^^f7^^f8^^f9^^fa^^fb^^fc^^fd^^fe^^ff%
  ^^^^2744^^^^0308^^^^0131%
  ^^00}
\lst@RestoreCatcodes
\makeatother

...

\begin{lstlisting}
copyright sign © and a snowflake❄ ı̈.
\end{lstlisting}
{% endhighlight %}

The layout is a bit weird, but it's close:

![dotless i and umlaut](/images/dotless.png)

Get a little bit weirder. How can I make an emoji work? Now that I know this mapping trick, I figure that a five digit codepoint might take five carets. That doesn't work in LuaLaTeX though. [listings package rearranges (Emoji) characters](https://tex.stackexchange.com/q/413452/130987) explains it. Additionally, since I don't have a monospaced font that has the  XXX

{% highlight tex %}
\makeatletter
\lst@InputCatcodes
\def\lst@DefEC{%
 \lst@CCECUse \lst@ProcessLetter
  ^^80^^81^^82^^83^^84^^85^^86^^87^^88^^89^^8a^^8b^^8c^^8d^^8e^^8f%
  ^^90^^91^^92^^93^^94^^95^^96^^97^^98^^99^^9a^^9b^^9c^^9d^^9e^^9f%
  ^^a0^^a1^^a2^^a3^^a4^^a5^^a6^^a7^^a8^^a9^^aa^^ab^^ac^^ad^^ae^^af%
  ^^b0^^b1^^b2^^b3^^b4^^b5^^b6^^b7^^b8^^b9^^ba^^bb^^bc^^bd^^be^^bf%
  ^^c0^^c1^^c2^^c3^^c4^^c5^^c6^^c7^^c8^^c9^^ca^^cb^^cc^^cd^^ce^^cf%
  ^^d0^^d1^^d2^^d3^^d4^^d5^^d6^^d7^^d8^^d9^^da^^db^^dc^^dd^^de^^df%
  ^^e0^^e1^^e2^^e3^^e4^^e5^^e6^^e7^^e8^^e9^^ea^^eb^^ec^^ed^^ee^^ef%
  ^^f0^^f1^^f2^^f3^^f4^^f5^^f6^^f7^^f8^^f9^^fa^^fb^^fc^^fd^^fe^^ff%
  ^^^^2744^^^^0308^^^^0131%
% ^^^^^1F308
  🌈%
  ^^00}
\lst@RestoreCatcodes
\makeatother

...

\begin{lstlisting}
copyright sign © and a snowflake ❄ (* {\emojifont 🌈} *)
\end{lstlisting}
{% endhighlight %}

And this is the real problem with LaTeX. Eventually you get to an 80% solution that you convinces you to keep going until you get stuck again and work hard to another 80% solution. It knows when you've reached your limit and reveals something satisfying enough to keep you around.
