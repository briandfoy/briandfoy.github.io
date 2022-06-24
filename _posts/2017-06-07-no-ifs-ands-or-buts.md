---
layout: post
title: No ifs, ands, or buts
categories: programming
tags: object-orientation perl smalltalk ruby
stopwords: Pharo's ifFalse ifTrue
last_modified:
original_url:
---

Sometimes I force myself to not use a feature. What if I couldn't use `if`? Were that true, I'd have to do something else. Here's an example from Smalltalk, where there's no special syntax for `if`. Instead, there's a `Boolean` receiver with `ifTrue:` and `ifFalse:` methods:

<!--more-->

{% highlight text %}
( ... )
	ifTrue: [...]
	ifFalse: [...].
{% endhighlight %}

That's easy enough to do in Perl too, and this is almost the same implementation as Smalltalk (at least Pharo's, but I haven't checked any others). The object knows what to do because it knows what it is rather than what it contains. Different classes have the same methods but act differently only based on their identity:

{% highlight perl %}
use v5.20;

package Boolean {
	use experimental qw(signatures);
	sub new ( $class, $boolean ) {
		state @o = ( Boolean::False->new, Boolean::True->new );
		$o[ !! $boolean ]
		}
	}

package Boolean::True {
	use experimental qw(signatures);
	sub new ( $class ) { bless {}, $class }
	sub if_true  ( $self, $sub ) { $sub->(); $self }
	sub if_false ( $self, $sub ) { $self }
	}

package Boolean::False {
	use experimental qw(signatures);
	sub new ( $class ) { bless {}, $class }
	sub if_true  ( $self, $sub ) { $self }
	sub if_false ( $self, $sub ) { $sub->(); $self }
	}

Boolean->new( 5 < 3 )
	->if_true( sub { say "Less Than" } )
	->if_false( sub { say "Greater Than" } );

Boolean->new( 0 )
	->if_true( sub { say "True" } )
	->if_false( sub { say "False" } );

Boolean->new( 37 )
	->if_true( sub { say "True" } )
	->if_false( sub { say "False" } );
{% endhighlight %}

The Ruby version looks a bit closer to Smalltalk because Ruby syntax knows about bare blocks and I don't need parens to call another method right after the block. I cheat a bit in Ruby because I define my own `#new`:

{% highlight perl %}
#!ruby
class Boolean
	def self.new( b )
	 !!b ? Boolean::True.new : Boolean::False.new
	end

	class True
		def initialize; end
		def if_false(&block);             self; end
		def if_true(&block);  block.call; self; end
	end

	class False
		def initialize; end
		def if_false(&block); block.call; self; end
		def if_true(&block);              self; end
	end
end


Boolean.new( 2 < 3 )
	.if_true  { puts "True"  }
	.if_false { puts "False" };
{% endhighlight %}

This works for more than just Booleans. Here's a four state version that does FizzBin. Once I see people solve the problem in a job interview, I ask them to do it again with no `if` statements. I don't expect them to come up with this, and I do use `and` here so I'm cheating a bit:

{% highlight perl %}
use v5.20;

package Number {
	use experimental qw(signatures);
	sub new ( $class, $n ) {
        my( $subclass ) = grep { $_ } (
			( !($n % 3) and !($n % 5) and 'ThreeFive' ),
			( !($n % 3) and 'Three' ),
			( !($n % 5) and 'Five' ),
			'Neither'
			);
		$subclass->new;
		}
	}

package None {
	sub new        { bless {}, $_[0] }
	sub if_three   { $_[0] }
	sub if_five    { $_[0] }
	sub if_neither { $_[0] }
	}

package Neither {
	use parent qw(-norequire None);
	sub if_neither { $_[1]->(); $_[0] }
	}

package Three {
	use parent qw(-norequire None);
	sub if_three { $_[1]->(); $_[0] }
	}
package Five {
	use parent qw(-norequire None);
	sub if_five { $_[1]->(); $_[0] }
	}
package ThreeFive {
	use parent qw(-norequire None);
	sub if_three { $_[1]->(); $_[0] }
	sub if_five  { $_[1]->(); $_[0] }
	}

foreach my $n ( 1 .. 20 ) {
	Number->new( $n )
		->if_three(   sub { print 'Fizz' } )
		->if_five(    sub { print 'Bin'  } )
		->if_neither( sub { print $n     } );
	print "\n";
	}
{% endhighlight %}
