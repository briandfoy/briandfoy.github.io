---
layout: post
title: The AV2000 passthrough powerline extender
categories: nyc-mesh
tags: tplink nyc-mesh
stopwords: ungeeky
last_modified:
---

My NYC Mesh came into the back of my apartment, where I spend very
little time. The wireless router plugs into a cable hung from the roof
of the building and doesn't use the cabling already in place and
hooked up to Spectrum. This presents a problem getting signal to the
front of my apartment.

Rather than run cables, I decided to try a powerline extender. These
work by sending signals through the copper power lines. You need at least
two, and one of them connects via Cat-5 to a router.

My main concern was that many things said that they had to be on the
same "circuit". I figured that might mean they have to come out of the
same breaker from my main panel. A secondary but close concern was how
noisy my copper is. Having worked with electronics in my nuclear
physics days, I knew that some lines are be really noisy to the point
of uselessness. Indeed, the advice online is to not have powerline
extenders near things with motors, such as the compressors for air
conditioners and refrigerators.

I settled on [TP-Link's AV2000 2-port Gigabit](https://www.tp-link.com/us/home-networking/powerline/tl-pa9020p-kit/)
([Amazon.com](https://www.amazon.com/gp/product/B01H74VKZU/ref=as_li_tl?ie=UTF8&amp;camp=1789&amp;creative=9325&amp;creativeASIN=B01H74VKZU&amp;linkCode=as2&amp;tag=hashbang09-20&amp;linkId=0c9d02ee0a53d6fc080a777a725307a4))
model for the very ungeeky reason is that 2000 is higher than the other
device numbers and the slightly more geeky reason that it has a pass-through
electrical socket.

<a target="_blank" href="https://www.amazon.com/gp/product/B01H74VKZU/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B01H74VKZU&linkCode=as2&tag=hashbang09-20&linkId=0c9d02ee0a53d6fc080a777a725307a4"><img class="center" border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B01H74VKZU&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=hashbang09-20" ></a><img src="//ir-na.amazon-adsystem.com/e/ir?t=hashbang09-20&l=am2&o=1&a=B01H74VKZU" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

I put one at the back of the apartment and one where Spectrum's cable
modem use to plug in. These are on different breakers from my I connected the back one the NYC Mesh router and
plugged in another wireless hotspot to the front one (these are not
wireless extenders).

Only a few devices were grumpy because they weren't getting the right
nameserver from their DHCP lease. The NYC Mesh router chose
*192.168/16* as its private network while I had previously used
*10.1/16*. I wanted [Cloudflare's 1.1.1.1 DNS server](https://blog.cloudflare.com/announcing-1111/) but some things
were fixed on the old *10.1.0.1*. Curiously, the CBS All Access app on
Apple TV did not have a problem while Prime Video and YouTube did.

I added a pigtail ([Amazon.com](https://www.amazon.com/gp/product/B07F2H1Q9F/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B07F2H1Q9F&linkCode=as2&tag=hashbang09-20&linkId=ec4b245ed044761c91a9b8d3adf00119)) between the wall and the device because the plug is
too bulky. I think it was designed for the much larger European plugs
and retrofitted with the small US plug. It's big enough to block the second outlet:

<a target="_blank"  href="https://www.amazon.com/gp/product/B07F2H1Q9F/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B07F2H1Q9F&linkCode=as2&tag=hashbang09-20&linkId=ec4b245ed044761c91a9b8d3adf00119"><img class="center" border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=B07F2H1Q9F&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=hashbang09-20" ></a><img src="//ir-na.amazon-adsystem.com/e/ir?t=hashbang09-20&l=am2&o=1&a=B07F2H1Q9F" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

So far so good, although the bad reviews on Amazon said they work fine
for a couple of months then die. But, I also suspect those people were using
them in the bathtub or something.
