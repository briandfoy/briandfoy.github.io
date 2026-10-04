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
	map_file my $map, $item;

	my($type) = $map =~ /^status: \h+ (\S+)/xm;

	say "[$type] $item";

	my $dir = $root->child($type);
	$dir->make_path;

	$dir->child($item->basename)->spew($map);
	}
