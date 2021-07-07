use utf8;
use v5.18;

package ArticleUtil;
use experimental qw(signatures);

sub metadata_in ( $file ) {
	open my $fh, '<:encoding(UTF-8)', $file or do {
		warn "Could not open <$file>: $!";
		return {};
		};

	while( <$fh> ) { last if /\A---$/ }

	my %hash;
	$hash{file} = $file;

	while( <$fh> ) {
		next unless /\S+/;
		last if /\A---$/;
		chomp;
        my( $key, $value ) = split /\s*:\s*/, $_, 2;

        $hash{$key} = $value;
		}

	my @keys = qw( categories tags stopwords );
	foreach my $key ( @keys ) {
		$hash{$key} = [ split /\s+/, $hash{$key} ];
		}

	\%hash;
	}

sub check_metadata ( $hash ) {
	state @required = qw(
		layout title tags
		);
	state %allowed = map { $_, 1 } ( @required , qw(
		categories last_modified original_url
		) );

	my %errors;

	$errors{extra}        = [ grep { ! exists $allowed{$_} } keys %allowed ];
	$errors{missing_keys} = [ grep { ! exists $hash->{$_}  } @required ];

	foreach my $key ( keys %errors ) {
		delete $errors{$key} if 0 == $errors{$key}->@*;
		}

	return \%errors;
	}


1;

__END__
---
layout: post
title: Another sign of the coming Dark Ages
categories:
tags: opinion
stopwords: Bittman's Curation QAnon's curation href nerded nerf pre img
last_modified:
original_url:
---
