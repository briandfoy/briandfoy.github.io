#!perl
use v5.10;
use utf8;
use open qw(:std :utf8);

use File::FindRoot;
use File::Map 'map_file';
use Mojo::File;

my $root = Mojo::File->new( File::FindRoot->dir_contains('.git') );
my $base = $root->child('_articles');

foreach my $item ( $base->list->each ) {
	next unless $item->extname eq 'md';

	map_file my $map, $item;

	my($type) = $map =~ /^status: \h+ (\S+)/xm;
#	say "[$type] $item";
	next unless length $type;

	my $dir = $root->child($type);
	$dir->make_path;

	my $draft = $root->child('_drafts', $item->basename );
	my $post  = $root->child('_posts',  $item->basename );
	if( $type eq '_posts' and -e $draft ) {
		system 'git', 'rm', '-f', $draft->to_string;
		system 'git', 'commit', '-m', 'promoted to published posts', $draft->to_string;
		unlink $draft->to_string;
		}
	elsif( $type eq '_drafts' and -e $post) {
		system 'git', 'rm', '-f', $post->to_string;
		system 'git', 'commit', '-m', 'demoted from published posts', $post->to_string;
		unlink $post->to_string;
		}

#	say "\tdir is $dir";
	$dir->child($item->basename)->spew($map);
	}
