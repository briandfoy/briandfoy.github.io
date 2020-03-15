---
layout: post
title: Battling AhrefsBot
categories: sysadmin
tags: ahrefsbot bots cloudflare apache
stopwords: ahrefs ahrefsbot IPs txt conf errordoc multilang
last_modified:
---

I noticed that one of my sites was getting an abnormally high amount
of traffic, but I had just added some new content. Maybe it got onto
Hacker News. Nope. The cache was missing about 40% of the time on a
fairly long expiry time, so nefarious things were afoot.
[AhrefsBot](+http://ahrefs.com/robot/) was going to town on my server.
Or, at least it was something claiming to be this bot. Eventually I'll
put a stop to this, but first, what's up?

Here's a typical log line, which explains the cache misses:

{% highlight text %}
108.162.219.178 - - [30/Jan/2020:12:42:50 -0500] "GET
/search/%E3%80%8C%EC%B6%A9%EC%B2%AD%EB%82%A8%EB%8F%84
%EC%BD%9C%EA%B1%B8%E3%80%8D%E2%86%98%EC%98%88%EC%95%BD
%E2%99%AA%EC%B6%9C%EC%9E%A5%EC%95%88%EB%A7%88%EC%95%BC
%ED%95%9C%EA%B3%B3%E2%98%BC%E3%80%88%EC%B9%B4%ED%86%A1
%3A+hwp63%E3%80%89.%E3%80%90%D0%BF%D1%82%D0%BA455.%D1
%81%D0%BE%D0%BC%E3%80%91%E2%96%BCSG2019-02-26-06-59%5B
%5D%EB%AA%A8%ED%85%94%EC%B6%9C%EC%9E%A5%EB%A7%88%EC%82
%AC%EC%A7%80%EC%83%B5%EC%B6%A9%EC%B2%AD%EB%82%A8%EB%8F
%84%E2%95%99%EB%A7%8C%EB%82%A8%E2%99%A9%E2%99%AA%5B%5D
%EB%AA%A8%ED%85%94%EC%B6%9C%EC%9E%A5%5B%5D0dS%E2%94%8A
%5B%5D%EC%BD%9C%EA%B1%B8%EC%B6%9C%EC%9E%A5%EC%95%88%EB
%A7%88%5B%5D%EC%B6%A9%EC%B2%AD%EB%82%A8%EB%8F%84/feed/
rss2/ HTTP/1.1" 200 - "-" "Mozilla/5.0 (compatible;
AhrefsBot/6.1; +http://ahrefs.com/robot/)"
{% endhighlight %}

First, that percent-encoded string looks like an exploit. What is
it? An [online decoder helps](https://www.url-encode-decode.com). It's
a mix of Hangul and Cyrillic:

{% highlight text %}
「충청남도콜걸」↘예약♪출장안마야한곳☼〈카톡: hwp63〉.【птк455.сом】
▼SG2019-02-26-06-59[]모텔출장마사지샵충청남도╙만남♩♪[]모텔출장[]0dS
┊[]콜걸출장안마[]충청남도
{% endhighlight %}

Put that into Google Translate:

{% highlight text %}
"Chungcheongnam-do call girl" ↘Reservation ♪ business trip ☼
〈Katok: hwp63〉. 【Птк455.сом】
▼ SG2019-02-26-06-59 [] Motel Trip Massage ShopChungcheongnam-do
♩ Meeting ♩ ♪ [] Motel Trip [] 0dS
┊ [] Call Girl Massage [] Chungcheongnam-do
{% endhighlight %}

[Chungcheongnam](https://en.wikipedia.org/wiki/South_Chungcheong_Province) is a province in South Korea.

The Cyrillic address is curious. It looks like *.com*, but it's not
the Latin alphabet. This is the sort of thing you do to fake someone
into going to a site that in a different top-level domain because the
characters look similar. Punycode turns that into
`http://xn--455-bedys.xn--l1adi`. It wasn't accepting connections.

## Stopping the Ahrefsbot

I can't block this by IP address or subnet because the IP addresses are
all over the place. Maybe it's a bot net. There were about three requests
every ten seconds, so not enough of an attack to shut me down. It's annoying
at best.

First, I looked [at the link in the user agent](http://ahrefs.com/robot/)
and it said I could stop it with an entry in _robots.txt_. So I made that.

{% highlight text %}
User-agent: AhrefsBot
Disallow: /
{% endhighlight %}

They said it could take 100 requests or an hour for them to notice. They
did not notice. Fine.

I then decided to block it at the *.htaccess* level so it would get
a 403 response. Maybe that it would convince it that my server was
worthless and to stop:

{% highlight text %}
RewriteCond %{HTTP_USER_AGENT} ^.*(AhrefsBot).*$ [NC]
RewriteRule .* - [F,L]
{% endhighlight %}

That went for a couple of hours, and I'll come back to this later because
this had another problem on my side. Next, I blocked them at the
Cloudflare level with a User-Agent based firewall rule. I should have
started with this:

![Cloudflare fireawall rule](/images/ahrefsbot-firewall-rule.png)

Now none of these requests reached my server, but I could watch in them
the Cloudflare logs. The crawling went on for another hour or so
before it started to back off. Then it switched IP blocks for a couple
of checks, switched back to the original block, then switched to
another, new block. Once it figured it that I was blocking it, it
stopped trying that hard. I'd see a couple of requests an hour.

## It goes on

Even though I'd stopped "AhrefsBot", I was still getting similar traffic from
other agents (mostly coming out of the Dutch provider [AS39572](https://ipinfo.io/AS39572)):

{% highlight text %}
173.245.52.221 - - [30/Jan/2020:12:52:17 -0500] "GET /search/
%EF%B9%9D%EB%B0%94%EC%B9%B4%EB%9D%BC%EC%82%AC%EC%9D%B4%ED%8A
%B8%EF%B9%9E%E2%9C%8D-%EC%BD%94%EC%9D%B8%EC%B9%B4%EC%A7%80%EB
%85%B8-%E2%94%9B%EB%A3%A8%EB%B9%84%EB%B0%94%EB%91%91%EC%9D%B4
%E2%97%86%28%29%E2%99%90%E3%80%8Egmvcs.com%E3%80%8F%5B%5D%EB
%B0%B0%ED%84%B0%EB%A6%AC%EA%B2%8C%EC%9E%84%5B%5D%EC%9D%B8%ED%84
%B0%EB%84%B7%EB%B0%94%EC%B9%B4%EB%9D%BC%EC%82%AC%EC%9D%B4%ED%8A
%B82019-03-04-13-22%EC%9D%B8%ED%84%B0%EB%84%B7%EB%B0%94%EB%91
%91%EC%9D%B4%EA%B2%8C%EC%9E%84%EC%98%A8%EB%9D%BC%EC%9D%B8%EC%B9
%B4%EC%A7%80%EB%85%B8%5B%5D%EA%B5%AD%EB%82%B4+%EC%B9%B4%EC%A7
%80%EB%85%B8+%ED%98%84%ED%99%A9%5B%5D%EC%98%A8%EB%9D%BC%EC%9D
%B8+%EC%B9%B4%EC%A7%80%EB%85%B8+%ED%95%A9%EB%B2%95%EB%B0%94%EC
%B9%B4%EB%9D%BC+%ED%95%84%EC%8A%B9%EB%B2%95%ED%99%80%EB%8D%A4
%EB%B0%94%5B%5D/feed/rss2/ HTTP/1.1" 200 1990 "-" "Mozilla/5.0
(Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36
(KHTML, like Gecko) Chrome/41.0.2272.96 Mobile Safari/537.36
(compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
{% endhighlight %}

It's the same structure with some different characters:

{% highlight text %}
﹝바카라사이트﹞✍-코인카지노-┛루비바둑이◆()♐『gmvcs.com』[]배터리게임[]
인터넷바카라사이트2019-03-04-13-22인터넷바둑이게임온라인카지노[]국내 카지노
현황[]온라인 카지노 합법바카라 필승법홀덤바[]
{% endhighlight %}

It's another Korean advertisement:

{% highlight text %}
﹝ Baccarat site ﹞ ✍-Coin Casino-Zu Ruby Go ◆ () ♐ gmvcs.com
Online Baccarat Sites 2019-03-04-13-22
Status [] Online Casino Legal Baccarat Winning Law Hold'emba []
{% endhighlight %}

Perhaps this isn't AhrefsBot but someone just hijacking it's name.
Looking at the Cloudflare logs, I see that every IP that I'm blocking
with my User-Agent rule is a French IP address. Every one of them.
Yep, there are two providers in France that tolerate this sort of
nonsense, and it was [AS16276](https://ipinfo.io/AS16276) bothering
me. French IPs addresses claiming to be from a company located
Singapore with offices in France and with ["roots" in the
Ukraine](https://ahrefs.com/about) (a country that I already block
outright). (See also [Fighting referral spam](https://ro-che.info/articles/2018-03-25-fighting-referral-spam), about some of the same French ISPs).

I fall back to another `RewriteRule`. Since that URL doesn't map to
anything I have, I can do it with just the front part of the URL. This
didn't seem to work at first. I tracked down and disabled an
`ErrorDocument` handler *extra/httpd-multilang-errordoc.conf* to get
the right response code sent to the client. This might be why my
earlier rewrite didn't work, but I hadn't turned on logging then. For
some stupid reason, sending the `ErrorDocument` version changed the
status back to 200 (because *that* file *was* found):

{% highlight text %}
RewriteRule  ^/search/ [R=500]
{% endhighlight %}

Ten years ago this sort of thing could bring down a WordPress server
because it would overwhelm MySQL. Now, I press a button at Cloudflare
and it's stopped instantly.
