---
layout: post
title: Perl's taint checking
categories:
tags:
stopwords:
last_modified:
original_url:
---

#!/Users/brian/bin/perl

use v5.10;

BEGIN {
=pod

Windows:

    $ENV{TMPDIR}
    $ENV{TEMP}
    $ENV{TMP}
    SYS:/temp
    C:\system\temp
    C:/temp
    /tmp
    /

=cut

    print <<"HERE";
    TMPDIR:  $ENV{TMPDIR}
    TEMP:    $ENV{TEMP}
    TMP:     $ENV{TMP}
HERE

    my %sysdirs = (
        unix    => [qw( /tmp )],
        MSWin32 => [qw(
            SYS:/temp
            C:\system\temp
            C:/temp
            /tmp
            /
            )],
        cygwin  => [qw(
            /tmp
            C:/temp
            )],
        );

    my %envvars = (
        MSWin32 => [qw( TMPDIR TEMP TMP )],
        cygwin  => [qw( TMPDIR )],
        unix    => [qw( TMPDIR )],
        );

    my $keys = $envvars{ exists $envvars{$^O} ? $^O : 'unix' };

    my( $candidate_key ) = grep { defined $ENV{$_} } $keys->@*;
    say "Candidate key is $candidate_key";

    if( exists $ENV{$candidate_key} ) {
        $pattern = '.+'; # a real pattern is much more complicated path matcher
        if( $ENV{$candidate_key} =~ m/($pattern)/ ) {
            my $matched = $1;
            unless( -d $matched ) {
                die "TMPDIR value <$matched> does not exist";
                }
            unless( -w $matched ) {
                die "TMPDIR value <$matched> is not writeable";
                }

            say "Untainting <$matched>";
            $ENV{$candidate_key} = $matched;
            }
        else {
            die "Could not untaint TMPDIR value: $ENV{$candidate_key}";
            }
        }
    else {
        my $sysdirs = $sysdirs{ exists $envvars{$^O} ? $^O : 'unix' };

        foreach my $dir ( $sysdirs->@* ) {
            say "Temp dir <$dir> is a writable dir? ", -d -w $dir;
            }
        }
    }

use File::Spec qw(tmpdir);

my $tmpdir = File::Spec->tmpdir();

say "Temp dir is $tmpdir";
unless( -d $tmpdir ) {
    die "<$tempdir> does not exist";
    }
unless( -w $tmpdir ) {
    die "<$tempdir> is not writeable";
    }

https://rt.cpan.org/Public/Bug/Display.html?id=60340

https://github.com/Perl-Toolchain-Gang/File-Temp/pull/10

https://www.nntp.perl.org/group/perl.cpan.workers/2015/05/msg1280.html

https://www.nntp.perl.org/group/perl.cpan.workers/2015/05/msg1281.html

https://www.nntp.perl.org/group/perl.cpan.workers/2015/05/msg1283.html

https://rt.cpan.org/Public/Bug/Display.html?id=104611

https://github.com/Perl-Toolchain-Gang/File-Temp/pull/10/commits/2ab4b4d8036eabf01ad320524db42d5911f8e267
