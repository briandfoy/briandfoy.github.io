---
layout: post
title: ffmpeg cheatsheet
categories: programming
tags: cheatsheet ffmpeg
stopwords:
last_modified:
original_url:
---

I use cheatsheets to remember commands I use frequently.

Convert formats:

    ffmpeg -i input.mkv output.mp4

Extract audio:

    ffmpeg -i input.mp4 -vn audio_only.m4a

Change size:

    ffmpeg -i input.mp4 -s 1280x720 -c:a copy resized.mp4

Add postal image to audio:

    ffmpeg -loop 1 -i inputimage.jpg -i inputaudio.mp3 -c:v libx264 -c:a aac -strict experimental -b:a 192k -shortest output.mp4

Join video files:

    ffmpeg -f concat -i join.txt -c copy output.mp4

Extract a portion:

    ffmpeg -ss 00:00:05 -i input.mp4 -t 00:00:03 -c:v copy -c:a copy excerpt.mp4

Trim a video:

    ffmpeg -ss [start] -i in.mp4 -t [duration] -c copy out.mp4

Burn subtitles:

    ffmpeg -i sub.srt sub.ass
    ffmpeg -i in.mp4 -vf ass=sub.ass out.mp4

Rotate a video:

	ffmpeg -i in.mov -vf "transpose=1" out.mov

	0 = 90 CounterCLockwise and Vertical Flip (default)
	1 = 90 Clockwise
	2 = 90 CounterClockwise
	3 = 90 Clockwise and Vertical Flip

Download transport stream:

    ffmpeg -protocol_whitelist "file,http,https,tcp,tls" -i "path_to_playlist.m3u8" -c copy -bsf:a aac_adtstoasc out.mp4
