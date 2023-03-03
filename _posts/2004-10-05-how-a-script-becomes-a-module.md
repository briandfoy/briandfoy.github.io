---
layout: post
title: How a script becomes a module
categories: perl programming
tags: rescued-content perlmonks
stopwords: MLDBM Flintstone's arounds crypto proto
last_modified:
original_url: https://www.perlmonks.org/?node_id=396759
---

*I originally published this on Perlmonks as [How a script becomes a module](https://www.perlmonks.org/?node_id=396759)*

First, the House of Representatives proposes... wait a minute, that's "How a bill becomes a law", and although it got its own Schoolhouse Rock song, it's not what I'm talking about.

<!--more-->

Lately my scripts have been turning into modules. This doesn't happen by itself, or even all at once. These scripts just sort of evolve, and pretty soon they are modules. The script doesn't necessarily get any better (maybe it gets worse), and they aren't even the best looking modules. They aren't a product of top-down design where I know everything that I want and have a nice specification. They aren't bottom-up design either, really, because I don't even start as a module. I call this sort of programming "side over" design, mostly because the extra work gets you no immediate benefit. It doesn't add functionality, and it doesn't necessarily save computer or human time. I could probably also call it "quality time with the keyboard" or "divorce maker".

I'm going to make up a script for this (real cases are too long to think about) and follow it from its simple beginning as it evolves into a modulino and finally a full-blown module. The example is contrived, but it illustrates what actually happens. If you want a real life example, you can look back at the history of my release(1) utility (it's on CPAN) and track its evolution to Module::Release which Ken Williams created out of it (and Andy Lester maintained for a while, and which I am re-designing).

But, back to a contrived example. Keep in mind this is not the way you should do things, just the way I have done things in the past. I'm making the opposite claim, probably. Just watch the action for the train-wreck thrill of it. Don't try to copy the process, because it's not going to show up in any best practices books.

## A simple report

Let's say I want to keep track of some bowling scores for Fred Flintstone's bowling team. No problem. I already have the data structure as a DBM::Deep file because the bowling alley puts it on their website each week, and I just want to write a report. At the end of this article I've included a script to set up the DBM::Deep file. Each player has a database entry which is an anonymous array of game scores, in the order they played the games, but I just want the last score for each player along with the high score for the last game.

{% highlight perl %}
#!/usr/bin/perl

use DBM::Deep;

my $scores = DBM::Deep->new( 'scores' );

foreach my $player ( sort keys %$scores )
	{
	$high_score = $scores->{$player}[-1]
		if $scores->{$player}[-1] > $high_score;
	print "$player has $scores->{$player}[-1]\n";
	}

print "The high score was $high_score\n";
{% endhighlight %}

There it is: a little report generator. It's a simple, little script, and it does what I want. When I run it, I see more output than I need though:

{% highlight text %}
Barney has 195
Betty has 210
Dino has 30
Fred has 205
Mr. Slate has 120
Wilma has 240
The high score was 240
{% endhighlight %}

## Okay, it wasn't so simple

How did Dino and Mr. Slate get in the output? Well, the bowling alley keeps track of all players, even if they only played once (like Dino did). Although I don't mind knowing how everyone else is doing, I really just want to make a report for Fred's team. So I add some a lookup hash. I skip players that don't bowl for Fred's team.

{% highlight perl %}
#!/usr/bin/perl

use DBM::Deep;

my $scores = DBM::Deep->new( 'scores' );

my %hash = map { $_, 1 } qw( Fred Barney );

foreach my $player ( sort keys %$scores )
	{
	$high_score = $scores->{$player}[-1]
		if $scores->{$player}[-1] > $high_score;
	next unless exists $hash{$player};
	print "$player has $scores->{$player}[-1]\n";
	}

print "The high score was $high_score\n";
{% endhighlight %}

Then I decide that I want to see the average score for a player too.

{% highlight perl %}
#!/usr/bin/perl

use DBM::Deep;

my $scores = DBM::Deep->new( 'scores' );

my %hash = map { $_, 1 } qw( Fred Barney );

foreach my $player ( sort keys %$scores )
	{
	$high_score = $scores->{$player}[-1]
		if $scores->{$player}[-1] > $high_score;
	next unless exists $hash{$player};
	my $sum = 0;
	$sum += $scores->{$player}[$_] foreach ( 0 .. $#{ $scores->{$player} } );
	my $average = $sum / ( $#{ $scores->{$player} } + 1 );
	print "$player has $scores->{$player}[-1] with average $average\n";
	}

print "The high score was $high_score\n";
{% endhighlight %}

## Refactoring, or, how to do a lot of work and not get anywhere

Now things are getting ugly: look at all those data structure accesses! This is just a simple script, too. Imagine this problem an order of magnitude worse with a useful script!

I decide to move some things in subroutines just to get them out of the way. I can then use the subroutine name in place of their ugly statements. I keep the subroutines short, and I avoid creating variables. These are convenience functions, so they should do their one thing and give me back a value. That seems convenient, right? Maybe I should stop sniffing the Smalltalk glue.

{% highlight perl %}
#!/usr/bin/perl

use DBM::Deep;

my $scores = DBM::Deep->new( 'scores' );

my %hash = map { $_, 1 } qw( Fred Barney );

foreach my $player ( sort keys %$scores )
	{
	$high_score = last_score( $scores, $player )
		if last_score( $scores, $player ) > $high_score;
	next unless exists $hash{$player};
	my $game_count = game_count( $scores, $player );
		print "count is $game_count\n";
	my $sum = 0;
	$sum += score_n( $scores, $player, $_ ) foreach ( 1 .. $game_count );

	my $average = $sum / $game_count;

	print "$player has " . last_score( $scores, $player ) .
		" with average $average\n";
	}

print "The high score was $high_score\n";

sub last_score { $_[0]->{$_[1]}[-1]          }
sub game_count { scalar @{ $_[0]->{$_[1]} }  }
sub score_n    { $_[0]->{$_[1]}[ $_[2] - 1 ] }
{% endhighlight %}

This really isn't that much better to look at, though. Even though it is easier to follow since I have subroutine names to signal what I am doing instead of data structure accesses, the interesting part of the script is longer. I could use shorter variable names, but I could have done that before, too. By refactoring, I did move things out of the loop and into subroutines, but they were replaced with even longer things.

## Even more running in place

I go through a couple of iterations of refactoring. I notice that I don't really care about the sum. It's just a step to the average. And, the game count is just a step toward the sum. Both of these things are taking up space in my loop, so I move those bits into a subroutine that does the sum. The loop looks a little better because it has fewer lines, but the remaining lines still look pretty gnarly. At least the subroutines are short. I use the crypto-context trick with subroutines that call other subroutines: append a `&` to the name of the sub and don't use `()`. The calling subroutine will pass on a copy of its `@_` for me. I don't have to do extra typing.

{% highlight perl %}
#!/usr/bin/perl

use DBM::Deep;

my $scores = DBM::Deep->new( 'scores' );

my %hash = map { $_, 1 } qw( Fred Barney );

foreach my $player ( sort keys %$scores )
	{
	$high_score = last_score( $scores, $player )
		if last_score( $scores, $player ) > $high_score;
	next unless exists $hash{$player};

	print "$player has " . last_score( $scores, $player ) .
		" with average " . average( $scores, $player ) . "\n";
	}

print "The high score was $high_score\n";

sub last_score { $_[0]->{$_[1]}[-1]           }
sub game_count { scalar @{ $_[0]->{$_[1]} }   }
sub score_n    { $_[0]->{$_[1]}[ $_[2] - 1 ]  }
sub average    { &sum  / &game_count          }

sub sum
	{
	my $sum = 0;
	$sum += score_n( @_, $_ ) foreach ( 1 .. game_count( @_ ) );
	$sum;
	}
{% endhighlight %}

## Patterns emerge

Earlier I had the suspicion that there was a pattern to all of this, and now it is apparent: my subroutines all need to know about the [DBM::Deep](https://metacpan.org/pod/DBM::Deep) data and the player name. Things look complicated because I have to keep specifying the same arguments to the subroutines. I don't care so much about this in the subroutines, but I don't like it in the main loop. I could just make a mega-function to do everything in one step: `last_score_and_average()`, but that's an ugly name. How about a `stats()` function that returns a hash for just one player?

{% highlight perl %}
sub stats
	{
	@{ $_[0] }{ qw(name sum average last) } =
		( $_[1], &sum, &average, &last_score );
	}
{% endhighlight %}

Now I can get rid of the function calls in my loop, and use my lookup hash to store the stats hash for each player. I'm starting to get a lot of subroutines, but I don't really want to see them. I add a line of #s to set them apart, and I throw in some blank lines for good measure. My print statement looks more friendly since I can interpolate hash values and I don't need to break up the string. If the `$hash{$player}` portion was shorter, I could get that whole string on one normal-sized line. It still bugs me that I keep seeing `$hash{$player}`. I also refactor some of the subroutines. I like short subroutines that can fit on one line, and I'm sure I can shorten `sum()` quite a bit. I'm not golfing, I just want it shorter. I also notice that `last_score()` is really a special case of `score_n()`, so it should call it instead of re-implementing it.

{% highlight perl %}
#!/usr/bin/perl

use DBM::Deep;

my $scores = DBM::Deep->new( 'scores' );

my %hash = map { $_, stats( $scores, $_ ) } qw( Fred Barney );

foreach my $player ( sort keys %$scores )
	{
	$high_score = last_score( $scores, $player )
		if last_score( $scores, $player ) > $high_score;
	next unless exists $hash{$player};

	print "$player has $hash{$player}{last} with average " .
		"$hash{$player}{average}\n";
	}

print "High score is " . $high_score . "\n";

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
sub last_score { score_n( @_, -1 )            }
sub game_count { scalar @{ $_[0]->{$_[1]} }   }
sub score_n    { $_[0]->{$_[1]}[ $_[2] - 1 ]  }
sub average    { &sum  / &game_count          }

sub sum
	{
	my $sum = 0;
	$sum += score_n( @_, $_ ) for( 1 .. &game_count );
	$sum;
	}

sub stats
	{
	my %hash;

	@hash{ qw(name sum average last) } =
		( $_[1], &sum, &average, &last_score );

	\%hash;
	}
{% endhighlight %}

## Oops, I did it again

Around this point in the real scripts I have developed, I realized I have evolved to a proto-module inside my script. Look at it: I have a bunch of subroutines that all take the same data structures as the first two argument, and I've visually set these subroutines aside with a line of pound signs. If if looks like a package and quacks like a package, it must be a package. Remember, I'm not telling you to do things this way, I'm just telling you how it turned out for a couple of my scripts.

So, I add a few more pieces. I need a package and a constructor, and some accessors for good measure, and I change the subroutines to methods. Some of them get a bit longer because I can't use the lone ampersand magic I used before. The subroutines don't change that much, though. I have to insert a call to the `db()` accessor to get the [DBM:::Deep](https://metacpan.org/pod/DBM::Deep) object which was the first argument until the new object shoved its way into the call stack. Now all the [DBM:::Deep](https://metacpan.org/pod/DBM::Deep) stuff shows up later in the `Local::Scores` package. The "script" portion has no idea what is going on behind the scenes: I could switch to MLDBM, [DBI](https://metacpan.org/pod/DBI), SQLite, or something else and the "script" wouldn't know.

Since I decide that I have a modulino, I decide to add a `high_score()` method too. This decision is perhaps the most design-shattering one of the whole lot. Once I have a way to access the high score, I don't need to keep track of that in the loop. If I don't need to keep track of that in the loop, I don't need to go through each player even though I only want results for one team. In short, my stubborn refusal to move the high score logic out of the loop locked in a bunch of crappy work-arounds, and it wasn't even that important to the original task! Now I can just loop through the team members. All the database stuff disappears into the modulino.

{% highlight perl %}
#!/usr/bin/perl

my @players = map Local::Scores->new($_), sort qw(Fred Barney);

foreach my $player ( @players )
	{
	my $name = $player->name;
	print "Sum for $name is [" . $player->sum . "]\n";
	print "Game count for $name is " . $player->game_count . "\n";

	printf "%s has last score %d with average %.1f\n",
		map { $player->$_ } qw( name last_score average );
	}

print "High score is " . Local::Scores->high_score() . "\n";

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
package Local::Scores;
use DBM::Deep;

sub new  {
	bless
		{ db => DBM::Deep->new( 'scores' ), name => $_[1] },
		$_[0]
	}

sub db         { $_[0]->{db}                             }
sub name       { $_[0]->{name}                           }

sub last_score { $_[0]->score_n( -1 )                    }
sub game_count { scalar @{ $_[0]->db->{$_[0]->name} }    }
sub score_n    { $_[0]->db->{$_[0]->name}[ $_[1] - 1 ]   }
sub average    { $_[0]->sum  / $_[0]->game_count         }

sub sum
	{
	return $_[0]->{sum} if exists $_[0]->{sum};
	$_[0]->{sum} += $_[0]->score_n( $_ ) for( 1 .. $_[0]->game_count );
	$_[0]->{sum};
	}

sub high_score { ... }
{% endhighlight %}

## Modulino to Module

I don't have to stop there though. Most of the "script" is now a module. I can make the whole script a module. I add a `run()` method which contains the rest of the script, and a line that automatically calls the `run()` method if the file was invoked as a script (so there is no caller, which there is when the module is invoked with `use()` or `require()` ).

{% highlight perl %}
package Local::Scores;
use DBM::Deep;

__PACKAGE__->run( qw( Fred Barney ) ) unless caller();

sub new  {
	bless
		{ db => DBM::Deep->new( 'scores' ), name => $_[1] },
		$_[0]
	}

sub run  {
	my $class = shift;

	my @players = map $class->new($_), sort @_;

	foreach my $player ( @players )
		{
		printf "%s has last score %d with average %.1f\n"
			map { $player->$_ } qw( name last_score average );
		}

	print "High score is " . Local::Scores->high_score() . "\n";
	}

sub db         { $_[0]->{db}                       }
sub name       { $_[0]->{name}                     }

sub last_score { $_[0]->score_n( -1 )              }
sub game_count { scalar @{ $_[0]->db->{$_[1]} }    }
sub score_n    { $_[0]->db->{$_[1]}[$_[2]]         }
sub average    { $_[0]->sum  / $_[0]->game_count   }

sub sum
	{
	return $_[0]->{sum} if exists $_[0]->{sum};
	$_[0]->{sum} = $_[0]->score_n( $_ ) for( 1 .. $_[0]->game_count );
	}

sub high_score { ... }
{% endhighlight %}

I install this module wherever I like, but for this article, I just leave it in the same directory as everything else and name is "Scores.pm".

I can call it as a script and I get the same output I got before. The `run()` statement in the third line runs because there is no caller: it's just a script running on its own.

{% highlight text %}
$ perl Score.pm
{% endhighlight %}

However, if I call it as a module, nothing happens because I never execute the `run()` statement since there is a caller.

{% highlight text %}
$ perl -MScores -e 1
{% endhighlight %}

I can use the module to run other scripts, though.

{% highlight text %}
$ perl -MScores -e "Local::Scores->run( shift )" Wilma
{% endhighlight %}

There it is. I have a script and a module, all in one.

## Aftermath and recovery

This started as a little script, and now I have this crappy module that mixes up the database and the player. I didn't plan on writing a module, but after a couple of refactoring passes, and then recognizing a pattern, I ended up with one. A really crappy one at that. It did make the interesting part of the script shorter, but it isn't the right abstraction. There should be a "Player" layer over the low-level database stuff. Right now every object is for a player, and every method has to figure out how to get to a player's data in the big database. I should memoize some of the functions.

The rest of the process is the usual module stuff. I could rewrite this to have a `Local::DB` class that has a factory for the `Local::Player` class (which is just the record for that player). I could do all the things I would do if I knew that I was going to write a module when I started this thing.

Looking back at the process, it wasn't anything by itself that drove the evolution. The refactoring helped to make it apparent, but that wouldn't have led to a module if I hadn't set up the functions to have mostly the same argument lists. I also had to move some code around in my `foreach()` loop. Once I got rid of the `$high_score variable` with the `high_score` function, the `foreach()` loop could concentrate on one task (printing the scores), so it was more malleable and easier to change. By writing short subroutines, I could see patterns easily since I could line up their code. The `score_n()` subroutine was a big win only if I used it to get every score so it became the single point of access for scores, even in the `scores()` function.

There are some trade-offs though, and some of them might not be worth it. My original task was simple: print the scores for Fred's team. I finished that pretty quickly. If that was my only task, I then wasted a bunch of time "improving" the script, although the output didn't change. That's just a fancy way of saying that the extra work resulted in no gain in productivity and a big loss in time. There is a point where further development starts diminishing returns. Also, my code probably runs slower. I started with some simple stuff and ended up with a lot of function calls. This doesn't mean much in real time: I probably won't even notice it. Still, the extra work did not improve performance. I can distribute the module so other people can use it, and that might be a net gain for everyone, although I probably have to fix and maintain it now, as well as write documentation. Lastly, the script is a lot longer. More characters are more chances for bugs and errors. I did reuse some of the code by defining and using subroutines, but I may not have made any gains there either.

I have a big gain in testability. Most things happen in small functions that I can test independently (since they do not use side effects). I didn't do into any of that here, but if this were a real project, I would certainly have a *.t* file for each of those functions.

## In which I say "economic" twice

So what is the upside to all this refactoring? Surely there must be one, or I wouldn't have done this. The most honest answer is that I feel better, and not even for any good reason. The code is more pleasing to me because it is better organized and more flexible. The short subroutines remind me of Smalltalk programming, and that's a good feeling. That's a rather irrational motive though. Economists might say I am wealthier because I am happier, but am I really? I am only more happy than when I started the script. I probably haven't gotten back to happiness I had before I started, though.

The real upside is the same one for all modules: I now can deal with new tasks very quickly. If I had to write the same script bits over and over again every time I wanted to extract some information from the database, I would end up with a lot of scripts doing a lot of the same work, but perhaps with different bugs, or all the same bug. I would also have to rewrite all of the scripts if the database format changed. This only turns out to be a benefit if I do a lot more work with the database file. Any other personal upsides are probably just justifications and rationalizations in the micro-economic perspective. From the perspective of the community, the macro-economic gain is tremendous. I may have wasted a significant portion of my time without much to show for it, but if I save a hundred people that same amount of time and they do the same for me, I end up with a lot more time than doing everything myself.

So, nothing new really. Nothing to see here. Move along, folks, move along.

## Appendix: Setting up the data file

{% highlight perl %}
#!/usr/bin/perl

use DBM::Deep;

my $modules = DBM::Deep->new( 'bowling.db' );

foreach my $elem
	(
	[ Barney      => [ 160, 200, 300, 240, 255, 195 ] ],
	[ Fred        => [ 175, 220, 230, 180, 260, 205 ] ],
	[ Dino        => [   0,   0,   0,   0,   0,  30 ] ],
	[ 'Mr. Slate' => [  95,  80,  10,  90, 100, 120 ] ],
	[ Wilma       => [ 260, 250, 240, 250, 240, 240 ] ],
	[ Betty       => [ 250, 240, 200, 140, 215, 210 ] ],
	)
	{
	$modules->{$elem->[0]} = $elem->[1];
	}
{% endhighlight %}


