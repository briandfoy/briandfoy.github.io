---
layout: post
title: On Readability
categories:
tags:
stopwords:
last_modified:
original_url: https://www.perlmonks.org/?node_id=592616
---

*I just finished writing a chapter for an upcoming O'Reilly book about what makes code beautiful. I did a bit of research on what people have to say about readability and ultimately used none of it because I decided it was a dumb way to measure code beauty and it was flame-bait anyway. I don't want to waste all that effort though, so I'll add it to the monastery. Maybe others can expand on what I started.*

Start a language war, and no matter what side you're really on, you'll probably try to claim that your language is more readable. Is Python really easier to read than Perl, or Java easier to read than Python? Anyone voting for APL or LISP? If you're Damian Conway it doesn't really matter because you turn any language into what you want anyway and it is more readable as long as you forget which language it started as.

Worse than that is the intra-language readability wars. Everyone thinks that their code is readable and almost everyone thinks that nobody else's code is even decipherable. Do you use K&R or ANSI kung-fu style? Two or four spaces? Or tabs? Do you even use whitespace (I'm looking at you, Monks-Who-Posts-In-Obfuscation). I, like everyone else, have my own ideas about where things should go in code.

Maybe you get three people to agree on the right style. Now which built-in functions do you get to use? You get two of the three to agree not to use `goto`, but nobody can agree on `unless` except for a moment before someone asks "You mean just in statement modifiers" and the other person sucker punches him.

Indeed, the popularity of tools such as [Perl::Tidy](https://metacpan.org/pod/Perl::Tidy) (or even [Perl::Critic](https://metacpan.org/pod/Perl::Critic)) demonstrates that not even people who agree on a language can decide.

Before I start on my own thoughts I figured I'd scour Google to see what people talk about when they mean "code readability". Here's a short list roughly in order I encountered them, phrasing the requirement in terms of enhanced readability. Curiously, the top Google hits were mostly blog entries rather than authoritative sources.

* Smaller line count
* Brace-defined blocks
* Short scopes with items declared close to their use
* Naming conventions
* Doesn't need syntax highlighting
* Consistency
* Familiar style
* Defined regions of code that goes together as a logical unit
* Lack of clever-ass tricks
* Use words instead of symbols
* Make function with good names to describe intent
* Use whitespace to separate related chunks of code

Now, before I get to my opinions, let me prepare the battlefield.

### I don't care what language it is

Before I judge the readability of a language, I should know the language. I don't fault the programmer for using something that's perfectly valid just because I don't know that part of the language. For instance, most commonly in code reviews, I find that new-comers to Perl don't particularly like the use of `map` for whatever reason. That makes the code unreadable in the same way as I have trouble reading *Le Monde* without a way to look up the french nouns I don't know. It's not about french's readability; it's just my deficient french vocabulary.

I particularly like Joel Spolsky's ["Making Wrong Code Look Wrong"](http://www.joelonsoftware.com/articles/Wrong.html) because he explains how newcomers don't even know what to look at when they first see a language. You actually have to know the language and use if for a bit before you can say anything about it.

### I need to understand the task, too

Someone can write a perfectly readble bit of device driver code and I still won't understand it. I'll probably be able to figure out the syntax and the various operations but I'll be foggy on what its doing and why it has to happen that way. That's not the fault of the code. I'm not a device driver sort of guy, and as complicated as those can be, I don't expect the code to make me understand the field.

I don't expect the documentation to explain the complete history of device drivers either. Documentation is good, but anything useful is going to assume quite a bit of basic knowledge about the domain. I've done a lot of web apps, but I don't document the cookie specification in my programs. I might note an exception that covers a particular browser bug and how the code deals with that, but I'm not writing an encyclopedia. Leaving code comments to knowledgable developers isn't the same as teaching newbies.

Going the other way, even with "unreadable" code, if I understand the task I can probably figure it out pretty easily. I already know the steps involved, so I just have to connect that to the code.

I'd bet that some people who like to carp about unreadable code in some language looked at code for something they wouldn't understand anyway or were new to the subject and didn't give themselves enough of a trial period with the new subject. There's no reason that we should instantly understand anything (although that's not license to be coy with the code I write).

### People are different

There is no measure of absolute readability just like there is no way to get people to all have the same favorite movie. Although the stereotype would like to paint this as usual nerdy deficiency to see anything other than black-or-white, it's a universal condition.

Eric Raymond likes Python because he thinks its more readable. Okay, that's fine. He can think that and not be wrong. However, I take my friend's advice on this: "Take what Roger Ebert says and think the opposite!" It's not that Roger Ebert is wrong but that she knows what he thinks about other things, what she thinks about other things, and how that affects any single thing Ebert might say and how she might agree. Apply that to Eric Raymond other ideas.

That's not really a knock on Eric, though. If you think like he does in other things, you may find that you also will find Python to be more readable than other code. If you're a fan of Larry Wall's other ideas, you'll probably find Perl as readable as he does. It's not that Python is more readable, it's more readable for Eric. Why that might be is another, but off-topic, long post best left to a pub discussion.

Even within a language different people prefer different styles, so apply this same idea at the micro level.

### High-level language source code is for people

We write in higher languages so people can understand what we're writing, as well as machine portability and encapsulating big ideas in keywords and idioms. If source code were for the computer, we'd just write it in machine language.

### Most people write for themselves

Left alone, people come up with a model of their world that makes sense to them, ranging from where to put things in the kitchen to variable names in their code. Their scheme makes perfect sense to them.

Yesterday I ran across ["Perlish Coding Style"](https://ysth.info/pcs.html), which lacks both Perlishness and style in favor of an overriding fondness for semicolons. I'll come back to this later, but here's an example:

{% highlight text %}
; sub foobar
   { my $value = shift
   ; my $c     = 0
   ; if ( ... )
      { my $a = ...
      ; my $b = $a + 5
      ; my $c = compute($a)
      }
   ; return
   }
{% endhighlight %}

That makes perfect sense to [DOMIZIO](http://search.cpan.org/author/DOMIZIO), and he even tried to explain it to everyone else. His style is a bit of an extreme example, but everyone has their little thing that makes sense to them.

## Real Readability

Readability isn't a feature of a language—that comes from my first assumption. I'm going to skip the usual bits about good variable names, commenting, and so on. Even programmers who refuse to do that stuff secretly know they are good ideas. More fundamental than those things are a few principles that I can apply to any code in any language.

Real readability isn't strict adherence to a set of guidelines. You aren't necessarily going to find it in [perlstyle](https://perldoc.perl.org/perlstyle) or [Perl Best Practices](https://amzn.to/3fbhaaq). Those certainly give you techniques that make code look nice but you need some first principles.

### The important bits stand out

No matter what I'm coding, the important part of the code should be more apparent than the fiddly bits that go around it. In the extreme example, that's where that Perlish Coding Style went wrong. It elevates the banal statement and elements separator to prime importance in every line because every line starts with them and the semicolon draws attention to itself. We read code left to right (mostly), so things on the left mean more to us. Things on the right mean less. The Perlish Coding Style is less readable in general because it makes things that shouldn't be important stand out more than they should.

Whitespace is one way to emphasize things. Indention, black lines, and linings things up in columns all work to make the structure of code more apparent. People can argue exactly how to do that, but at the end of the day it's only about what's best for that code. What's best, however, might not always be the same. Most often when people argue about whitespace, they aren't arguing about what is best for the code. They're defending their editor, how they cut-n-paste, or some other extra-code concerns.

Code hiding, *a.k.a.* subroutining, removes the banal stuff unrelated to the task but necessary to move around the data. Programs have a job to do. That's their narrative arc. To drive that plot, all sorts of little things have to happen. We want to move the little bits out of the way to clearly show the plot. The subroutine name groups the boring stuff together and describes it, all the while hiding the boring bits from view. They were just getting in the way anyway.

### It's easy to see what's related

Things that are related to each other should have some sort of connection, whether is variable name, proximity in the code base, or something else. Consider, for instance, two separate variables:

{% highlight text %}
x = 3
y = 1
{% endhighlight %}

Outside of their context, those variables don't have much meaning (although the particular use of `x` and `y` suggests, at least to scientists, a 2D point (see "Use familiar or repeated idioms", coming up next). Are they separate things or do they go together? If they go together, make them go together by creating a pair.

{% highlight text %}
point = [ 3, 1 ]
{% endhighlight %}

Most programmers have probably seen code that suffers from a lack of data structures, or at least reinvents the notion of a collection:

{% highlight text %}
x1 = 4
x2 = 6
x3 = 9
x4 = 5

first_name = 'Fred'
last_name  = 'Flinstone'
city       = 'Bedrock'
{% endhighlight %}

### Use familiar or repeated idioms

I don't really like the variable names the DBI documentation uses, but people know what `$dbh` and `$sth` are. If they read the DBI docs, for whatever reason, they'll know that the `$sth` in my code is the same sort of thing as the `$sth` in the documentation. Not only is the connection clear because they have the same name, but the reader doesn't have to remember an internal mapping of variable names and what they are. And, the network effect comes into play when everyone follows the DBI example. Look at just about any code, if DBI is involved `$sth` will probably mean something to do with DBI even if I don't see the code around it. This isn't cargo culting: you still need to understand everything.

## Interesting resources

I ran across a number of interesting links, some only indirectly related to readability.

* [Fun with Dead Languages](http://damian.conway.org/Seminars//DeadLanguages.html)
* [Reading, Writing, and Code Using Regions to Improve Code Readability](http://www.c-sharpcorner.com/Code/2003/Aug/UsingRegions.asp)
* ["Making Wrong Code Look Wrong"](http://www.joelonsoftware.com/articles/Wrong.html)
* ["Perlish Coding Style"](http://perl.4pro.net/pcs.html)
