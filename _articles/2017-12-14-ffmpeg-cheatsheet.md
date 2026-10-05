---
layout: post
status: _posts
title: ffmpeg cheatsheet
categories: cheatsheet
tags: ffmpeg
stopwords: stdin
last_modified:
original_url:
---

I use cheatsheets to remember commands I use frequently.

<!--more-->

Batch convert:

{% highlight console %}
$ for i in *.avi; do ffmpeg -i "$i" "${i%.*}.mp4"; done
{% endhighlight %}

Convert formats:

{% highlight console %}
$ ffmpeg -i input.mkv output.mp4
{% endhighlight %}

Extract audio:

{% highlight console %}
$ ffmpeg -i input.mp4 -vn audio_only.m4a
{% endhighlight %}

Remove audio:

{% highlight console %}
$ ffmpeg -i input.mp4 -c copy -an input-nosound.mp4
{% endhighlight %}

Be quiet:

{% highlight console %}
$ ffmpeg -hide_banner -loglevel warning
{% endhighlight %}

Fire and forget (redirect stdin):

{% highlight console %}
$ nohup ffmpeg ... </dev/null &
{% endhighlight %}

Find the size:

{% highlight console %}
$ ffprobe -v error -show_entries stream=width,height \
	-select_streams v:0 -of json  input.mp4 \
	| jq '.streams[0]|.width,.height' | paste - -
{% endhighlight %}

Change size:

{% highlight console %}
$ ffmpeg -i input.mp4 -s 1280x720 -c:a copy resized.mp4
{% endhighlight %}

Add postal image to audio:

{% highlight console %}
$ ffmpeg -loop 1 -i inputimage.jpg -i inputaudio.mp3 -c:v libx264 -c:a aac -strict experimental -b:a 192k -shortest output.mp4
{% endhighlight %}

Join video files:

{% highlight console %}
$ ffmpeg -f concat -i join.txt -c copy output.mp4
{% endhighlight %}

Extract a portion:

{% highlight console %}
$ ffmpeg -ss 00:00:05 -i input.mp4 -t 00:00:03 -c:v copy -c:a copy excerpt.mp4
{% endhighlight %}

Trim a video:

{% highlight console %}
$ ffmpeg -ss [start] -i in.mp4 -t [duration] -c copy out.mp4
{% endhighlight %}

Burn subtitles:

{% highlight console %}
$ ffmpeg -i sub.srt sub.ass
$ ffmpeg -i in.mp4 -vf ass=sub.ass out.mp4
{% endhighlight %}

Rotate a video:

{% highlight console %}
$ ffmpeg -i in.mov -vf "transpose=1" out.mov

0 = 90 CounterCLockwise and Vertical Flip (default)
1 = 90 Clockwise
2 = 90 CounterClockwise
3 = 90 Clockwise and Vertical Flip
{% endhighlight %}

Download transport stream:

{% highlight console %}
$ ffmpeg -protocol_whitelist "file,http,https,tcp,tls" -i "path_to_playlist.m3u8" -c copy -bsf:a aac_adtstoasc out.mp4
{% endhighlight %}

Also:

* [FFmpeg For Beginners](https://github.com/jdriselvato/FFmpeg-For-Beginners-Ebook)
