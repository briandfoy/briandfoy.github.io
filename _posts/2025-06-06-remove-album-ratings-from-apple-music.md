---
layout: post
title: Remove album ratings from Apple Music
categories: apple applescript programming
tags: music ratings
stopwords:
last_modified:
original_url:
---

Apple's iTunes, a long time ago, had a ratings feature for albums from back in its SoundJam MP days, which turned into predictive album ratings. Where track ratings are shown as red stars, the album ratings are show as black stars (and predictive ratings as grey stars).

This is normally not a problem, but the album rating is somehow lumped into the song rating for smart playlists. And, there's no longer a way to make or remove album ratings. Yet, those ancient data are still tracked and there's a listing column for album ratings.

The trick is to set the album rating to something that is the same as zero stars. The album rating is actually a number between 1 and 100 that is mapped onto five stars. Give it something that maps to zero stars; `1` is good:

<!--more-->

{% highlight plain %}
tell application "Music"
	repeat with theTrack in selection
		set album rating of theTrack to 1
	end repeat
end tell
{% endhighlight %}
