---
layout: post
title: Make a daemon
categories:
tags:
stopwords:
last_modified:
original_url:
---

exit(0) if( fork or fork );

close all the standard filehandles


use Fcntl qw(LOCK_EX LOCK_NB);
    die "Another instance is already running" unless flock DATA, LOCK_EX|LOCK_NB;

https://unix.stackexchange.com/questions/41252/how-to-start-a-perl-webserver-with-systemd

sub daemonize {

  # Fork and kill parent
  die "Can't fork: $!" unless defined(my $pid = fork);
  exit 0 if $pid;
  POSIX::setsid or die "Can't start a new session: $!";

  # Close filehandles
  open STDIN,  '<',  '/dev/null';
  open STDOUT, '>',  '/dev/null';
  open STDERR, '>&', STDOUT;
}


