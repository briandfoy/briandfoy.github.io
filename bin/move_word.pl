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

__END__

=pod

=encoding utf8

=head1 NAME

move_word.pl - move a word between front matter fields in Jekyll articles

=head1 SYNOPSIS

	% cd _articles
	% ../bin/move_word.pl WORD FROM_FIELD TO_FIELD FILE...

	# make perl a tag instead of a category
	% ../bin/move_word.pl perl categories tags *.md

	# make rescued-content a category instead of a tag
	% ../bin/move_word.pl rescued-content tags categories *.md

=head1 DESCRIPTION

This program moves a single word from one front matter field to another,
such as from C<categories:> to C<tags:>. It expects each field to be a
single line of space-separated words:

	---
	title: Some title
	categories: perl programming
	tags: cpan
	---

After C<move_word.pl perl categories tags>, that becomes:

	---
	title: Some title
	categories: programming
	tags: cpan perl
	---

For each file, it:

=over 4

=item * looks only at the front matter, the block between the first two
C<---> lines. The rest of the file is untouched.

=item * skips the file unless WORD appears as a whole word in FROM_FIELD.
Partial matches don't count, so C<perl> does not match C<perl-mongers>.

=item * removes WORD from FROM_FIELD. If that empties the field, the line
stays as C<FROM_FIELD:> with nothing after it.

=item * appends WORD to TO_FIELD unless it is already there. If the file
has no TO_FIELD line, it adds one just before the FROM_FIELD line.

=item * collapses the extra whitespace on the two lines it changed.

=back

It rewrites only the files it changes, then reports how many that was.
Since it skips files that don't need a change, you can safely give it
every article.

=head1 ARGUMENTS

=over 4

=item WORD

The exact word to move, such as C<perl> or C<rescued-content>.

=item FROM_FIELD

The front matter field to remove WORD from, without the colon, such as
C<categories>.

=item TO_FIELD

The front matter field to add WORD to, without the colon, such as
C<tags>.

=item FILE...

One or more files to process.

=back

=head1 DIAGNOSTICS

=over 4

=item no front matter: FILE

The file doesn't start with a C<---> block, so it was skipped.

=back

=head1 CAVEATS

This edits files in place and makes no backups, so run it on files
that are tracked in git where you can review the changes with
C<git diff>.

Fields written as multi-line YAML lists are not handled.

=head1 SEE ALSO

F<bin/sort_articles.pl>, which copies articles from F<_articles> into
F<_posts> or F<_drafts>.

=head1 AUTHOR

Claude (Anthropic), using the Claude Opus 5.5 model (claude-opus-5-5),
written for brian d foy.

=cut
