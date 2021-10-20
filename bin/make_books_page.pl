#!perl

use v5.20;
use Mojo::JSON qw(decode_json);

my $file = 'books.json';
open my $fh, '<:raw', $file or die "Could not open $file: $!";
my $json_octets = do { local $/; <$fh> };

my $perl = decode_json( $json_octets );

output_top();
foreach my $book ( $perl->@* ) {

	my $authors = do {
		if( $book->{authors}->@* == 1 ) { $book->{authors}->@[0] }
		elsif( $book->{authors}->@* == 2 ) { join ' and ', $book->{authors}->@* }
		else { $book->{authors}->@[-1] = 'and ' . $book->{authors}->@[-1];
			join ', ', $book->{authors}->@*;
			}
		};

	my( $link ) = grep { defined } map { $book->{$_} } qw(amazon leanpub);
	my $website = do {
		my $web_link = $book->{website} // $link;
		if( $web_link ) { qq(\n\t\t\t<span class="website"><a href="$web_link">$web_link</a></span>\n) }
		else { '' }
		};

	say <<~"HERE"
	<div class="row" id="$book->{id}">
		<div class="column left book_cover">
			<a href="$link"><img class="book_cover" src="$book->{cover}" height="" width="" alt="" /></a>
		</div>
		<div class="column right book_details">
			<span class="book_list_title">$book->{title}</span><br/>
			<span class="publisher">$book->{publisher}</span>, <span class="pubdate">$book->{date}</span><br/>
			<span class="book_list_authors">$authors</span><br/>$website
		</div>
	</div>
	HERE

	}
output_bottom();


sub output_top {
say <<~"HERE";
---
layout: default
title: Books
permalink: /books/
generated-by: $0
---

HERE
}

sub output_bottom {
1;
}

__END__
