---
layout: post
title: Module::Signatures was doomed from the start
categories:
tags:
stopwords:
last_modified:
original_url:
---

Module::Signatures never had a hope of working.

<!--more-->

# loaded path attack

The cpansign command depends on the right Module::Signature


[Module::Signature]() was never going to work. It's a casual speedbump that may deter casual shenanigans, it's

First, verifying a signature requires that everything is trusted, and it excludes loading modules from certain paths by filtering `@INC`:

    local @INC = grep { File::Spec->file_name_is_absolute($_) } @INC;

This would exclude the dot `.` for the current directory and `blib/lib` from build tools. But, this is easily bypassed. Me


my $which_gpg;
sub _which_gpg {
    # Cache it so we don't need to keep checking.
    return $which_gpg if $which_gpg;

    for my $gpg_bin ('gpg', 'gpg2', 'gnupg', 'gnupg2') {
        my $version = `$gpg_bin --version 2>&1`;
        if( $version && $version =~ /GnuPG/ ) {
            $which_gpg = $gpg_bin;
            return $which_gpg;
        }
    }
}



https://bugzilla.redhat.com/show_bug.cgi?id=2035273

https://www.tenable.com/plugins/nessus/84495


https://caremad.io/posts/2013/07/packaging-signing-not-holy-grail/

