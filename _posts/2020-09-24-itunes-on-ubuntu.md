---
layout: post
title: iTunes on Ubuntu
categories:
tags: ubuntu itunes wine
stopwords:
last_modified:
original_url:
---

So I was helping a friend with a Windows computer whose disk was so full that it couldn't do anything. I mean, it only had 2GB free! The horrors!

I couldn't run the Control Panel thingy so I could look up the serial number to make a restore CD from Lenovo. Why Windows makes this so hard is another rant. I understand why they do it, but I question how big a deal it is.

I cleaned up Windows, which I thought removed a 4GB Windows Update file, but apparently not. No advice worked, so I punted to Linux. I flashed a drive (now it has to be larger than 2GB, so I had to hunt for one of those) on my Mac using the *.iso* I downloaded from Ubuntu and [balenaEtcher](https://www.balena.io/etcher/). No big whoop, although it took about four hours.

Booting to the flash drive was no big deal, although I needed Fn-10 on this laptop apparently. Ubuntu installed just fine.

Now the fun begins. My friend wants iTunes. Fair enough. Install [WINE](https://www.winehq.org) to run Windows programs. I get the latest [Windows iTunes](https://www.apple.com/itunes/), run the installer, and launch iTunes. I get a [black screen](https://askubuntu.com/questions/1155189/itunes-in-wine-black-screen-on-ubuntu-18-04). The advice is to get [an older iTunes](https://support.apple.com/downloads/itunes) (or, alternate advice is to [be Windows XP instead](_https://askubuntu.com/questions/635456/wine-black-window-issue/1063692#1063692)). I get 12.1.3. That works.

But, that doesn't recognize that there's an iPhone plugged in. That's not a big deal. We only need to get photos off this thing anyway.


We need something to pair with the iPhone and to mount it as a filesystem. The first part can use [libimobiledevice](https://libimobiledevice.org) and the second part can use [ifuse](https://github.com/libimobiledevice/ifuse)

{% highlight text %}
$ sudo apt install libimobiledevice6 libimobiledevice-utils ifuse
{% endhighlight %}

There's also a very complicated set of steps in [How can I mount my iPhone 6s on Ubuntu 16.04?](https://askubuntu.com/q/812006/912156). Some of my problems might be that I installed packages instead of compiling the source myself.

We can connect the iPhone and pair easily enough with a couple of steps to get the passcode and have the iPhone trust the computer ([iOS 7 Locked Bug via Ubuntu 13.10](https://askubuntu.com/q/371711/912156) and [iOS 7 Compatibility / Trust Dialog handling](https://github.com/libimobiledevice/libimobiledevice/issues/20) for weird historical details. And, [How to access and mount iPhone 6 in Linux - Tutorial](https://www.dedoimedo.com/computers/linux-iphone-6.html)).

{% highlight text %}
$ idevicepair pair
ERROR: Could not validate with device ... because a passcode is set. Please enter the passcode on the device and retry.$ idevicepair pair
$ idevicepair pair
ERROR: Please accept the trust dialog on the screen of device ..., then attempt to pair again.
$ idevicepair pair
SUCCESS: Paired with device ...
{% endhighlight %}

But, the iPhone doesn't remember this trust. Every time we connect the phone we have the two step process of unlocking it and responding to the prompt. Blech.

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/0udlgkKGRYs" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

Once connected, we can use `ifuse` to mount the thing.

The iPhone does eventually mount, but it's a pain. I try to write a quick shell script to run this, but my friend was a bit impatient and doesn't want to stick around to figure out why `mkdir -p` returns 1 when the directory exists (seriously, wtf?). They also want to be a programmer, so I say "This is programming. Welcome to hell.".
