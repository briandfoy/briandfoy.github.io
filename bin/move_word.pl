#!perl
use v5.10;
use strict;
use warnings;

# usage: move_word.pl WORD FROM_FIELD TO_FIELD FILE...
# In the front matter only, remove WORD from FROM_FIELD and append it
# to TO_FIELD if it isn't already there.

my( $word, $from, $to, @files ) = @ARGV;
die "usage: $0 WORD FROM TO FILE...\n" unless @files;

my $changed = 0;
foreach my $file ( @files ) {
	open my $in, '<:raw', $file or die "$file: $!";
	my $text = do { local $/; <$in> };
	close $in;

	my( $fm, $rest ) = $text =~ /\A(---\n.*?\n---\n)(.*)\z/s
		or do { warn "no front matter: $file\n"; next };

	my( $src ) = $fm =~ /^\Q$from\E:[ \t]*(.*)$/m;
	next unless defined $src;
	my @src = split ' ', $src;
	next unless grep { $_ eq $word } @src;

	my( $dst ) = $fm =~ /^\Q$to\E:[ \t]*(.*)$/m;
	unless( defined $dst ) {
		$fm =~ s/^(\Q$from\E:)/$to:\n$1/m;
		$dst = '';
		}
	my @dst = split ' ', $dst;
	push @dst, $word unless grep { $_ eq $word } @dst;

	my $new_src = join ' ', grep { $_ ne $word } @src;
	my $new_dst = join ' ', @dst;
	$fm =~ s/^\Q$from\E:.*$/$from: $new_src/m;
	$fm =~ s/^\Q$from\E: $/$from:/m;
	$fm =~ s/^\Q$to\E:.*$/$to: $new_dst/m;

	open my $out, '>:raw', $file or die "$file: $!";
	print {$out} $fm, $rest;
	close $out;
	$changed++;
	}

say "changed $changed files";
