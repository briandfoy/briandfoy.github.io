---
layout: post
title: types in perl
tags:
stopwords:
---

I'm about to start writing about a bunch of stuff that will definitely show my lack of a computer science background. Unlike many of my posts, this is your chance to correct me rather than me explain things to you.

I've been reading <a href="http://www.amazon.com/gp/product/193435659X?ie=UTF8&tag=theperlreview-20&linkCode=as2&camp=1789&creative=9325&creativeASIN=193435659X">Seven Languages in Seven Weeks: A Pragmatic Guide to Learning Programming Languages</a>, which is an enjoyable book except for the parts where he starts to talk about types and, ahem, types of programming languages. It's mostly distracting, not very useful, probably misguided, it not outright wrong.

So, Ovid posts <a href="http://blogs.perl.org/users/ovid/2010/07/static-and-dynamic-typing.html">a clever summary of type arguments</a>. This reminded me of smart, educated, and quite entertaining <A href="http://perl.plover.com/yak/typing/notes.html"> "Strong Typing" talk</a> that Mark Jason Dominus gave to several Perl mongers groups. It also reminds me that no one seems to think the same things about the same terms. Also see <a href="http://groups.google.com/group/comp.lang.perl.moderated/msg/89b5f256ea7bfadb?pli=1">mjd's message in comp.lang.perl.moderated</a>.

Wikipedia's entry on <a href="http://en.wikipedia.org/wiki/Strongly_typed_programming_language">Strongly-typed Programming Languages</a> isn't any help. Indeed, the discussion page, where mjd shows up, is better than the main article (and also demonstrates the underlying weakness of Wikipedia). The article did point me toward <a href="http://books.google.com/books?id=ti6zoAC9Ph8C">Types and Programming Languages (Google Books)</a>, which Amazon is already sending to me. I like the look of that book since it goes back to the math.

The math is where it's at, and although I don't have a background in Computer Science, I have a lot of experience with abstract algebra, which defines sets, groups, and so on, and what happens when they interact with each other.

I think this is why I get confused with most people's explanations. Most of the explanations I find, come from people trying to explain a concept that they don't fully understand based on their limited experience. That is, more concretely, people think the C programming language means something when it comes to types. I like <a href="http://book.realworldhaskell.org/read/types-and-functions.html">Real World Haskell's approach</a> if only because it defines the term. They could have just as well said Haskell is a "blue language" because the particular word doesn't matter when you provide your own definition for it:

<blockquote>
When we say that Haskell has a strong type system, we mean that the type system guarantees that a program cannot contain certain kinds of errors.
</blockquote>

That provides an easy way for Haskell to compare itself to other languages. In Haskell, certain classes of errors can't occur in a valid program. In other languages, maybe those classes or errors can. The question is, does that matter to you, both personally as a matter of beauty, and economically, as a productive use of your time?

And now comes the bit where I try to do better and will fail.

There's this big mess of terms: strong, weak, loose, static, dynamic, concrete, abstract, data, variable, and so on. I like what Richard Feynman learned about bird names from his father. Dr. Feynman says:

<blockquote>
You can know the name of a bird in all the languages of the world, but when you're finished, you'll know absolutely nothing whatever about the bird... So let's look at the bird and see what it's doing -- that's what counts. I learned very early the difference between knowing the name of something and knowing something.
</blockquote>

The video is more interesting:

<div align="center">
<object width="480" height="385"><param name="movie" value="http://www.youtube.com/v/05WS0WN7zMQ?fs=1&amp;hl=en_US"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/05WS0WN7zMQ?fs=1&amp;hl=en_US" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="480" height="385"></embed></object>
</div>

Types are just a kind of thing. It doesn't matter how we define that thing or how it works. The type is not the algebra. Forget about the terms, which no one can agree on (mostly), and figure out what you what to know and why you want to know it. It doesn't really matter what you call it as long as you get what you want.

<h2>What can I put in this variable?</h2>

A lot of programmers immediately think of <code>int</code>, <code>float</code>, or <code>char</code> as types. That's fine. However, when they don't see those types, they tend to turn up their nose because they think something is type deficient. The sorts of types that you have really has nothing to do with it. Indeed, most of those types come from architecture-dependent factors, like exposing the storage and format details at the higher levels. The people that want these sorts of types are looking to define the set of data that belong in that type. However, that does not mean that larger sets are not also types.

Programmers typically want this so they have something that protects them from storing invalid values.

<h2>How soon do I find out about type errors?</h2>

Do I have to wait until I run the program or will the compiler tell me? Consider this Perl example:

<pre>
push $array, qw(a b c);
</pre>

Is that a type error? Is it a type error in Perl 5.12? What about Perl 5.14? When does Perl find out about that error in each of those versions? Is it good or bad that it does that?

<h2>Can I change the type?</h2>

Is the type fixed, or can programmers play tricks to cast or coerce the thingy to void, or Object, or whatever, from which they can then recast the thingy to whatever they want? Do you want to allow or forbid that sort of thing?

<h2>When do I know the types?</h2>

People get confused about when the compiler (or interpreter) knows what the type is. Can you check it without a compiler (as with PPI or other static analysis tools), which really means can you infer all of the information that you need about types without actually running the program?

Mostly, people want to find errors though type-checking (so, the terms "type safety" and "type security"). The earlier you know about the types, the sooner your program can report problems. Some people don't even want the program to compile if there is a type mismatch.

<h2>What is the operator?</h2>

Some languages choose the operator by type, even if you type the same literal text for the code. How does that make you feel? Would you rather see the operation explicitly so you don't have to read through several lines of code to determine the type to know the operation, or do you want to be able to look at isolated statements and know what is going on?

<h2>What type is the result?</h2>

I always hated this about FORTRAN. Dividing 10 by 3 gave back three, because, in someone's mind, a integer divided by an integer had to be an integer. Why can't some other type come out? That goes back to the algebra. Any operation in an algebra has to return another member of the group.

<h2>What ______ is _______?</h2>

There's more to this topic than I can imagine at the moment.
