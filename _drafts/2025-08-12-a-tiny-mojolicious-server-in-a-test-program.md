---
layout: post
title: A tiny Mojolicious server in a test program
categories: programming perl
tags: mojolicious
stopwords:
last_modified:
original_url: https://www.reddit.com/user/briandfoy/comments/1modg3c/a_tiny_mojo_server_in_a_test_program/
---

<i>I originally wrote this quickly to see about posting to my reddit profile: [the post](https://www.reddit.com/user/briandfoy/comments/1modg3c/a_tiny_mojo_server_in_a_test_program/)</i>

Sometimes I need a simple web server to do something in a test. Most often this web server needs to simulate some error condition, such as a timeout or other server error.

<!--more-->

In this test program I fork. In the child, I start a Mojolicious server where the `/` path has a 10 second delay. This will be longer than the time-out I set for the user-agent in the parent. The magic is the `Mojo::IOLoop->start that keeps the server going at the end of the program.

In the parent I do whatever I want to test, which is usually something much more complicated. When I'm done, I shut down the server and get on in life.

{% hightlight perl %}
#!perl
use v5.40;

use Mojolicious::Lite;
use Mojo::Server::Daemon;
use Mojo::UserAgent;

my $port = 3000;

my $pid = fork;

if( $pid == 0 ) {
	local $SIG{INT} = sub {exit};
	local $SIG{TERM} = sub {exit};
	local $SIG{__WARN__} = sub {1};

	get '/' => sub ($c) {
	  sleep 10;
	  $c->render(text => 'Hello from inside the program!');
	};

	local *STDOUT;
	open STDOUT, '>>', '/dev/null';
	my $app = app->log( Mojo::Log->new(path => '/dev/null') );
	my $daemon = Mojo::Server::Daemon->new(app => $app, listen => ["http://127.0.0.1:$port"]);
	$daemon->start;
	Mojo::IOLoop->start;
	}
else {
	sleep 2; # let server start
	my $ua = Mojo::UserAgent->new->inactivity_timeout(3);
	my $tx = $ua->get( "http://127.0.0.1:$port/" );

	if( eval {$tx->result} ) {
		say "BODY: " . $tx->res->body;
		}
	else {
		say "ERROR: $@";
		}

	kill 9, $pid;
	waitpid $pid, 0;
	}
{% endhighlight %}

Previously, I also used [HTTP::Daemon](https://github.com/libwww-perl/HTTP-Daemon), which was fine too, but I often am dealing with Mojolicious so it's already there.
