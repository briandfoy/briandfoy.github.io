---
layout: post
title: Why is that even there?
categories:
tags:
stopwords:
last_modified:
original_url:
---

During code reviews, I often run into weird code organization, and I'm about to show you one example from code that I wrote this week.

These things often have reason, even if they aren't good reasons. There was something that the programmer was thinking about or had done previously that isn't apparent anymore. Maybe there was a constraint or feature in place, but neither of those matter now. Perhaps the programmer thought there was some constraint, or that there would be some constraint, but it didn't turn out to be true.

I have my own example from this week. Looking at it fresh, the decision doesn't make sense. Source control doesn't even help because I hadn't committed the original since I wasn't done with the feature yet.

A long time ago, I wrote the Perl module [HTTP::Cookies::Chrome](https://metacpan.org/pod/HTTP::Cookies::Chrome). It's been broken for years because Chrome 80+ encrypts cookies. It's not a big deal, but there are some platform difference to the decryption. I handled that in a subroutine:

{% highlight perl %}
sub _platform_settings {
	state $settings = {
		darwin => {
			iterations => 1003,
			},
		linux => {
			iterations => 1,
			},
		MSWin32 => {
			},
		};

	$settings->{$^O};
	}
{% endhighlight %}


But, that's a pretty weird subroutine. There's no tricky syntax there, but it's a bit wordy and spread out. The iterations is the number of rounds needed to produce the decryption key. I might have written it like this:

{% highlight perl %}
sub _platform_settings {
	state $settings = {
		darwin  => { iterations => 1003, },
		linux   => { iterations =>    1, },
		MSWin32 => { },
		};

	$settings->{$^O};
	}
{% endhighlight %}

But why didn't I? You can't see the reason in the repo or even in the code itself, but here's what I originally wrote:

{% highlight perl %}
sub _platform_settings {
	state $settings = {
		darwin => {
			iterations => 1003,
			profile    => 'Default',
			path       => "$ENV{HOME}/Library/Application Support/Chrome/Default/Cookies",
			chrome_safe_storage => do { my $c = `...`; chomp $c; $c },
			},
		linux => {
			iterations => 1,
			profile    => 'Default',
			path       => "$ENV{HOME}/.config/ google-chrome/Default/Cookies",
			chrome_safe_storage => do { my $c = `...`; chomp $c; $c },
			},
		MSWin32 => {
			iterations => undef,
			profile    => 'Default',
			path       => '$ENV{HOME}\',
			chrome_safe_storage => undef,
			},
		};

	$settings->{$^O};
	}
{% endhighlight %}

Originally I wanted to get the Chrome Safe Storage password. That's a secret that Chrome generates on its own and is available to the logged in user. Each platform has a different method for storing secrets, so they each have their own way to access them. I thought that I could handle all those details for the user.

The more I got into it, the more complicated I got. On Ubuntu, I had to install extra tools. And then, I realized that not all Linux distros would do this the same. I had no idea how to do it on Windows, and the .NET code I saw didn't really help. Maybe there's a quick Powershell command that can get it for me. Thinking about this delayed what I really wanted to do: decrypt some cookies. Rather than get into various complicated situations, I punted on the idea. I wouldn't do any of this work. I'll force the user to get the Chrome Safe Storage password and path on their own. Maybe I'll change that later or provide some convenience functions.

So, I removed all that stuff, ending up with something that doesn't quite make sense on its own. It's shaped by a bunch of ideas and decisions that were later removed. Since I never committed those ideas, there's nothing about them in the docs.

{% highlight perl %}
sub _platform_settings {
	state $settings = {
		darwin => {
			iterations => 1003,
			},
		linux => {
			iterations => 1,
			},
		MSWin32 => {
			},
		};

	$settings->{$^O};
	}
{% endhighlight %}
