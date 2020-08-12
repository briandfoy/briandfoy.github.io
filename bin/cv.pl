#!perl
use v5.10;

use Mojo::File;
use Mojo::JSON qw(decode_json);
use Mojo::Util qw(dumper);

my $cvjson = 'cv.json';
my $data = decode_json( Mojo::File->new($cvjson)->slurp );

say dumper( $data );
