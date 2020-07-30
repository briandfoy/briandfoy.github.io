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
	say <<~"HERE"
	<div class="row">
		<div class="column left book_cover">
			<img class="book_cover" src="$book->{cover}" height="" width="" alt="" />
		</div>
		<div class="column right book_details">
			<span class="book_list_title">$book->{title}</span><br/>
			<span class="publisher">$book->{publisher}</span>, <span class="pubdate">$book->{date}</span><br/>
			<span class="book_list_authors">$authors</span><br/>
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
---

HERE
}

sub output_bottom {
1;
}

__END__
