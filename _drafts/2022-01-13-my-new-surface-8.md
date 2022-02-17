---
layout: post
title: My new Surface 8
categories:
tags:
stopwords:
last_modified:
original_url:
---

/images/tom-brady-surface.gif

https://www.cnet.com/news/microsoft-red-hat-argue-open-source/

## Delivery

First, shipping is horrible. That's not MS's fault, but UPS updated
the delivery to today at about 9pm yesterday then delivered it at
10:30pm. Someone in my building must have taken it because i saw the
email notice that it was delivered and then it was leaning against my
front door.

## Unboxing

So it's been an interesting night, but so far I'm happily surprised
about Windows 10.

## First Impressions

"Who designed this shit?" is my first impression. My next impression
is "I can't use this for an hour?".

I wanted to plug in my new Surface. I hadn't really thought about it,
but I wasn't expecting a chunky, tradition transformer cable with a
knock-off MagSafe connector. I guess I expected that I'd be able to
use USB-C, but I hadn't really thought about it. And, it turns out that I can although I had to research
that as I wrote this. It's a really odd choice for a company without an overwhelming
investment in Lightning Cables considering that the EU is moving towards
a charging standard.


The Surface Pro 8 is [15 volts at 4 amps](https://support.microsoft.com/en-us/surface/surface-power-supplies-and-charging-requirements-0d9d51d4-594b-464d-9086-c90f35b80c01
), for 60 watts. My charger for
my MacBook Pro works just fine, and in a pinch I can slowly charge
with a 5 watt connection. I already have that setup in the places I
tend to work.

And, if it were charged only by USB-C, I wouldn't have such a hard time
finding the power port. What I thought was an SD-Card slot was the MagSafe
knockoff port.

## Configuring OpenSSL

Windows 10 comes with an OpenSSH client, and it's easy to install
the OpenSSH server.

https://superuser.com/questions/1501402/how-to-change-ssh-port-on-windows-10/1597490

https://www.hanselman.com/blog/how-to-ssh-into-a-windows-10-machine-from-linux-or-windows-or-anywhere

## Configuring TightVNC

## Installing Ubuntu

https://docs.microsoft.com/en-us/learn/modules/get-started-with-windows-subsystem-for-linux/

You may know a lot of this, but some highlights:

* Updating the network name was painful to find, but otherwise fine.
* Unboxing was painful. First, the external packaging was all beat up
because they used cheap cardboard. The product boxes were fine.
* The mouse takes two AAA batteries. Is this 1985?
* The surface has a chunky charger. WTF? I was hoping for USB-C
charging because I could share charges with my mac. And, it took me
forever to find the charging port because i thought it was an SD card
slot. Very unhappy about the charging thing.
* It was an hour before I could do anything because it had to update
and reboot twice. Seriously?
* Everything is set up to collect and sell information. Windows now
has ads. WTF?
* Everything is a subscription now. Even the stupid 7z extractor they
push on you is $30 a year. I'd pay $30 once, but not every year.
* The keyboard cover is weird—folding it behind to use it as a tablet
leaves the keyboard exposed. The iPad keyboard cover I have folds so
that the keyboard is hidden.
* Tightvnc is free and works with normal VNC. Thank good. So many
other products required software on both sides.
* It's much easier for Windows and Macs to discover each other on the
local network with whatever Bonjour is now called. So much has changed
in 10 years.
* Windows comes with an ssh client ready to go, and it was a simple
matter of some powershell to enable the server. Still need to figure
out how to change the port.
* Holy shit, ssh-ing into Powershell is a godsend.
* The WSL looks interesting, although I'm not particularly interested
in using it for anything. Still fun.


## Privacy

* turning off so many things, including ads on the lock screen
\	* https://nerdschalk.com/how-to-stop-pop-ups-on-windows-11/
	* https://www.digitalcitizen.life/disable-ads-iwindows-11/
	* turn off IrisService - `reg delete HKCU \ SOFTWARE \ Microsoft \ Windows \ CurrentVersion \ IrisService /f && shutdown -r -t 0` https://www.ctrl.blog/entry/windows11-empty-taskbar.html
* changing to duckduckgo
* installing /etc/hosts to C:\Windows\System32\drivers\etc\hosts


