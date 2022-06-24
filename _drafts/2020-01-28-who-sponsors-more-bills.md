---
layout: post
title: Who sponsors more bills?
categories:
tags:
stopwords:
last_modified:
original_url:
---
Hillary Clinton said of Bernie Sanders that "nobody wants to work
with him".

<!--more-->

Okay, fine. But is that true? I don't know who "nobody" is or what
"work" means, or even "want" means.

But, [Congress.gov](https://www.congress.gov) tracks bills online. Anyone can see any
bill, its text, status, sponsors, cosponsors, and much more.
I'm not aware of any mainstream news source that ever links
into the site, but then they tend to often neglect to include
bill's number or title too.

Can public meta data about the bill say something to anwser
"nobody" and "work"? Maybe.

But, before I go on, let's admit some things. First, I can't prove
or disprove the original statement because I don't know what
the words refer to. Even if I can assume the group and the
work, I can't measure "want". You either sponsor or co-sponsor a
bill. You don't declare to the world why you are doing it, if
you actaully want to do it ,or even that you genuinely want the
bill to pass. It also cannot show support or effort that the data
do not quantify. This is the realm of politics. Data does not peek
behind the curtain to ascertain the true thoughts.

So, the rest of this means nothing. Still, I wondered if I could
see something interesting in the data. I recognize that Sanders
is somewhere on the far left, whatever that means, and has a
reputation as an unconventional, outspoken senator. That's the
sort of person who nobody might want to work with.

So, what would the interesting questions be?

* How many bills has a senator introduced?
* How many original cosponsors were there?
* Who has the most diverse group of cosponsors?
* What's the split in parties among the cosponsors?
* Where does Senator Sanders stand in relation to the rest of the Senate?
* How does this look over time?

To start, I'll look at the 116th Congress (the current one). I need to
get the data for all bills. I'm specifically ignoring resolutions and
amendments.

Some parts of Congress.org provide XML representations, but not the
"All info" view of bills. Or, if you know how to get that, let me
know. Instead, I can download the HTML and use CSS selectors to get
most of the info I want:

* Bill number and title
* Originating senator and party
* List of cosponsors and parties

So, let's grab the HTML. Here's a simple-minded Mojolicious program to
do that. I increment a number and access the next URL:

{% highlight perl %}
#!perl
use v5.30;
use warnings;

use feature qw(signatures);
no warnings qw(experimental::signatures);

use File::Path qw(make_path);
use File::Spec::Functions;
use Mojo::UserAgent;

my $ua = Mojo::UserAgent->new;

my $house    = $ARGV[0] // 'senate';
my $congress = $ARGV[1] // 116;

my $ordinal = make_ordinal( $congress );
my $url_template = sprintf
	'https://www.congress.gov/bill/%s-congress/%s-bill/%%d/all-info',
	$ordinal, $house;

# Bills are numbers sequentially so just go up until they run
# out of bills. Skip the ones we already have.
my $count = 0;
while( 1 ) {
	state $dir = do {
		my $d = catfile( 'bills', $house, $congress );
		make_path $d;
		$d;
		};

	my $url = sprintf $url_template, ++$count;
	my $file = catfile( $dir, "$count.html" );
	next if -e $file;

	my $tx = $ua->get( $url );
	last if $tx->res->code != 200;

	$tx->result->save_to( $file );
	}

sub make_ordinal ( $n ) {
	$n . do {
		local $_ = $n;
		   if( /(?<!1)1$/ ) { 'st' }
		elsif( /(?<!1)2$/ ) { 'nd' }
		elsif( /(?<!1)3$/ ) { 'rd' }
		else                { 'th' }
		};
	}
{% endhighlight %}

Now I have the corpus locally, and I can turn it into something
I can use. I like the Unix philosophy: small programs to do discrete jobs.
Downloading the data and processing get their own steps rather than
one big program.

The rest is a mess of CSS selectors to create a JSON file of all the data.


{% highlight perl %}
#!perl
use v5.30;
use warnings;

use File::Basename;
use File::Spec::Functions;
use Mojo::DOM;
use Mojo::JSON qw(encode_json);
use Mojo::Util qw(dumper);

my $dir = 'senate_bills';
opendir my($dh), $dir or die "Could not open <$dir>: $!\n";

my %bills;
$|++;
while( my $file = readdir $dh ) {
	state $count = 0;
	next unless $file =~ /\AS(\d+)\.html\z/;
	my $b = $bills{$1} = {};
	$b->{link} = sprintf
		'https://www.congress.gov/bill/116th-congress/senate-bill/%d/all-info',
		$1;
	my $path = catfile( $dir, $file );
	open my $fh, '<:utf8', $path;

	my $data = do { local $/; <$fh> };
	my $dom = Mojo::DOM->new( $data );

	my $sponsor = $dom
		->at( 'div.overview_wrapper table.standard01 td:first-of-type a' );
	my $sponsor_href = $sponsor->attr( 'href' );
	my $sponsor_text = $sponsor->text;
	my( $sponsor_party ) = $sponsor_text =~ m/\[([RDI])-/;

	$b->{sponsor} = {
		link =>	"https://www.congress.gov$sponsor_href",
		member => basename( $sponsor_href ),
		text   => $sponsor_text,
		party  => $sponsor_party,
		};

	$b->{title} = $dom
		->at( 'head meta[name=dc.title]' )
		->attr( 'content' ) =~ s/.*?:\s+//r;

	$b->{cosponsors} = $dom
		->find( 'div#cosponsors-content a' )
		->map( sub {
			my $h = {
				link => $_->attr( 'href' ),
				text => $_->text,
				};
			($h->{member}) = $h->{link} =~ m|/([^/]+)\z|;
			$h->{original} = $h->{text} =~ s/&#42//;
			$h->{original} = \ !! $h->{original};
			( $h->{party} ) = $h->{text} =~ m/\[([RDI])-/;
			$h;
			} )
		->to_array;

	$b->{status} = $dom
		->at( 'div.overview_billprogress p.hide_fromsighted' )
		->text =~ s/.*status\s+//r;

	$count++;
	print '.' unless $count % 10;
	print "\n" unless $count % 500;
	}

open my $out, '>:raw', 'senate_bills.json';
say { $out } encode_json( \%bills );
close $out;
{% endhighlight %}
