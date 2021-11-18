---
layout: post
title: Rescuing Future Folk from my iPhone
categories: programming
tags: apple music dropbox iphone
stopwords: peasy Dalrymple's
last_modified:
original_url:
---

I think Dropbox has corrupted a bunch of my files. I don't care enough to verify the culprit, but this only happened under _~/Dropbox_ and not under my iCloud, Google Drive, or local directories. I went to investigate, restore from backup, and otherwise replace. But, I find some of my favorite music is borked.

My first hint of a problem, months ago, was many corrupted PDFs or images. They looked normal and had the expected file size, but the contents were all null bytes. Most of these weren't a problem because I could get them from backups, email, or their original source. I figured it was a fluke.

As an aside, I've noticed that a couple of my banks no longer have the complete history of statements. I don't really need my statements from 2003, but when did they stop giving me complete records? And, since they won't email the statements or give me an API to download them, I'm not going to check every month. I guess I'll do it all at tax time. Get the previous 12 months so Dropbox has more to corrupt.

If I discovered this within 30 days of Dropbox having the good version, I could restore it. I haven't looked at some of these files for years, though.

Tonight I had some time to survey the damage. I'll go through all the files and look for those of non-zero size that have something other than a null byte. I'll use memory-mapping so I don't need to read most of the file—most of the files are going to fail this test and I want them to fail fast. Otherwise, I'll output the names that are all nulls:

{% highlight perl %}
use v5.10;

use File::Find qw(find);
use File::Map qw(map_file);

my $count = 0;
my $wanted = sub {
	return unless -f $File::Find::name;
	return if -z $File::Find::name;
	next if $File::Find::name =~ /\.git/;
	map_file my $map, $File::Find::name;
	return if $map =~ /[^\0]/;
	say $File::Find::name;
	$count++;
	};

find( $wanted, @ARGV );

warn "Corrupted files: $count\n";
{% endhighlight %}

And, after about 10 minutes and lots of output:

{% highlight plain %}
... list of files ...
Corrupted files: 3920
{% endhighlight %}

The list isn't just PDFs or images. Several git repos are corrupted, often because _.git/config_ is corrupted. Many of those I have [stored all over the place](/use-several-git-services-at-once/), including their origin, GitHub (usually origin though), Bitbucket, and GitLab all at once. Those I simply delete locally or re-clone.

I was able to recover some files from another machine connected to the same Dropbox account. That's odd too; why are they good on one machine but not another? That wasn't universally true though. Many files were missing on the other machine.

But, the really painful piece of the problem was the disappearance of my [Future Folk](https://futurefolk.com) music.

{% highlight plain %}
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/01 Future Folk Theme Song.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/07 Canines Came from Cosmic Space.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/05 Over the Moon.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/08 Pirate Krong.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/02 Impossible Dream.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/03 Space Worms.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/06 Fuzzy Claw.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/09 Chromosome Z.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/04 Universe Within.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/10 I Can Not Breathe in Your Atmosphere.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk, Vol. 1/11 Moons of Hondo (Bonus Demo Track).m4a
/Users/brian/Dropbox/iTunes/Future Folk/Hondo - Single/01 Hondo.m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk Live On Earth/06 Pirate Krong (Live).m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk Live On Earth/07 Intro to Impossible Dream (Live).m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk Live On Earth/02 Space Worms (Live).m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk Live On Earth/01 Hondonian Band (Live).m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk Live On Earth/05 Intro to Pirate Krong (Live).m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk Live On Earth/03 Intro to Chromosome Z (Live).m4a
/Users/brian/Dropbox/iTunes/Future Folk/Future Folk Live On Earth/09 intro to sting theory (live).m4a
/Users/brian/Dropbox/iTunes/Future Folk/Rocket Tow Truck - Single/01 Rocket Tow Truck.m4a
{% endhighlight %}

They sell only one album on Amazon, but they sell both on Apple Music. I thought about buying CDs, then realized that I don't have a CD player to I could re-rip the songs (do kids today even know "ripping"?) I'm not sure when these files were corrupted, but I listen to these guys while cleaning the kitchen (and how is that possible if they are corrupted files)?

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/fZrDALCsKwI" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

I was momentarily relieved when I realized this some of the rare music I download from the cloud. There's that little icon next to the album and songs:

![](/images/future-folk/listing.png)

But, true to Apple Music's track record, I can't re-download it all. I get one of two error messages:

![](/images/future-folk/problem.png)

![](/images/future-folk/unavailable.png)

I tried Apple Match when it debuted, but it was a disaster. It mislabeled large parts of my library—all the Led Zeppelin songs were moved to different albums. See Jim Dalrymple's [Apple Music is a nightmare and I’m done with it](https://www.loopinsight.com/2015/07/22/apple-music-is-a-nightmare-and-im-done-with-it/) for the basic idea. I unfucked this in fits and starts over several years, but only after I stopped using Apple Match.

All of this was messed up on my laptop. What about on my phone? I check; the music is fine there! That raises the question that how is this syncing if the source is corrupt, but I also think that's part of the problem. The files have their meta-data and size preserved. It's just bad data of the same expected size. Who knows?

The trick is to get it off my phone, and I found an app for that. [iExplorer](https://macroplant.com/iexplorer). It can mount my phone so that I can get to the files stored there. Easy peasy. I can transfer files from my phone to my laptop. (I have also tried [ifuse](https://github.com/libimobiledevice/ifuse/wiki) to varying degrees of success, but it was such a painful process that I avoid that).

![](/images/future-folk/iexplorer.png)

I extracted the _.m4a_ files I needed, and they weren't protected. I don't recall if they ever were. I decided to convert them to _.mp3_ just in case. It's a short shell loop to batch mode the `ffmpeg` conversion. That `${f%.*}` is a nifty bit of [shell expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Expansions) to modify the filename:

{% highlight plain %}
% for f in *.m4a; ffmpeg -i "${f}" "${f%.*}.mp3"; done
{% endhighlight %}

Now I have non-Apple protected versions of the music I think that Dropbox corrupted and Apple Music wouldn't download.
