---
layout: post
title: Autoredailing and walking phone menus
categories: programming
tags: perl applescript
stopwords: cH AppleEvents
last_modified:
original_url:
---

There's a particular government service I need to interact with and they have rebuffed my messaging through their official website. I'm supposed to call them, but everyone else is calling them too. Instead of a callback service or something similar, this government office makes you walk through a two minute phone tree where several messages (all completely irrelevant to me) cannot be bypassed. After two and a half minutes, it tells you that no agents are busy and to call back later.

Many people say they spend their days calling this number, over and over. Some people say they've called it 300 times a day. Ridiculous. Some people use various redialer programs on Android, which I don't have. But what could I do with my MacBook?

## Automate the phone menu

First, the trick is to figure out how to walk the automated menu and how to send the right tones at the right time. That's just trial and error. You can dial more than the number, so I can add a bunch of stuff after the number to pretend to be me selecting things in the menus. A comma is a pause for about two seconds:

	8005551212,1,,,,,,,,,9,,2,,,,,ACCOUNTNO,,1,,PERSONALCODE

That works, although it took me about 20 calls to get the right intervals. That long pause between 1 ("for English") and 9 ("all other inquiries") simulates me listening to a long message that has nothing to do with the any of the reasons I'd call. If this were the water company, that message would be a mini-lecture on whales since they happen to live in water.

I put that number in Contacts so I can access it in the iPhone phone app. I call it, the other side answers, and the pauses and keypresses happen for me. I get to where I expect to be, which is the message telling me to call back later. I don't need to interact with it other than to initiate the process. I got this down to 1'20".

Using this on my phone is a bit tedious. I can almost do the same from the terminal with the `tel://` scheme. This opens the number in [Handoff](https://support.apple.com/en-us/HT209455):

    % open tel://...?audio=yes

I get a notification with a "Call" button, which is still annoying: because I have to interact with something after I start the process:

![Notification](/images/phone_menu_automation/notification.png)

## Automate the macOS UI

But, I can control the UI with AppleScript to press buttons for me. I found an example on Apple StackExchange's [Auto Facetime call using Applescript, without confirm
](https://apple.stackexchange.com/a/363833/26244). I wasn't motivated enough to take values from arguments or other settings because I'm using this for a simple purpose. I'll just hardcode those values:

	set number to "8885551212"
	set ACCOUNT to "..."
	set CODE to "..."
	set menu_navigation to ",1,,,,,,,,,9,,2,,,,," & ACCOUNT & ",,1,," & CODE
	set phone_num to number & menu_navigation
	do shell script "open tel://" & quoted form of phone_num
	tell application "System Events"
		repeat until (exists window 1 of application process "Notification Center")
			delay 0.1
		end repeat
		click button "Call" of window 1 of application process "Notification Center"
	end tell

I can run that right from Script Editor. It runs the program, clicks the button, and my iPhone does the rest:

![AppleScript Runner](/images/phone_menu_automation/applescript.png)

But I can also export this as an Application. Now I have a clicky thing on my Desktop. I open that and it all happens. I have to give it permission to use Accessibility (in Preferences) and AppleEvents (allow in the dialog). I can also open it from the terminal:

	% open /Users/brian/Desktop/CallStupidPhoneTree.app

## Automate the automation

But that's not enough. I still need to pay attention to that because I have to initiate each call. All that's going to happen is that the remote side goes through the process and hangs up on me. I want it to try again. And again, and so on. Eventually I think I might get a person and it won't hang up on me. No problem: I'll automate that part too by opening that application periodically:

{% highlight perl %}
#!/usr/bin/perl
use v5.10;
use strict;

use FindBin qw($Bin);
use Getopt::Long;

$SIG{INT} = sub { exit };

my $max_calls  = 60;
my $sleep_time = 140;
my $dry_run    = 0;
my( $app )     = glob( '*.app' );

GetOptions(
	"m|max_calls=i" => \$max_calls,
	"s|sleep=i"     => \$sleep_time,
	"d|dry_run"     => \$dry_run,
	"a|app=s"       => \$app,
	)
   or die("Error in command line arguments\n");

chdir $Bin or die "Could not change to $Bin: $!";

say <<~"HERE";
	App:    $app
	Sleep:  $sleep_time
	Max:    $max_calls
	Dryrun: $dry_run
	HERE

$|++;
while( 1 ) {
	state $calls = 0;
	last if ++$calls > $max_calls;
	printf "Try %3d/%3d - sleeping %3d", $calls, $max_calls, $sleep_time;
	system( '/usr/bin/open', $app ) unless $dry_run;

	my $time = time;
	while(1) {
		last if time - $time > $sleep_time;
		printf "\cH\cH\cH%3d", $sleep_time - (time - $time);
		sleep 1;
		}

	print "\r";
	}
{% endhighlight %}

The clever part of that program is my use of the carriage return (`\r`) to overwrite the same time on the next go around, and my use of the backspace (`\cH`, the control character represented by `H`) to overwrite the countdown timer.

<video class="center" width="436" height="226" autoplay>
  <source src="/images/phone_menu_automation/PhoneTree.mp4" type="video/mp4">
Your browser does not support the video tag.
</video>

But, eventually a human picks up and I'll fumble getting to my phone. Luckily I have a program to automate trying again.
