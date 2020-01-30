---
layout: post
title: The av2000 passthrough powerline extender
categories: nyc-mesh
tags: tplink nyc-mesh
stopwords:
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
model for the very ungeeky reason is that 2000 is higher than the other
device numbers and the slightly more geeky reason that it has a pass-through
electrical socket.

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="//ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ac&ref=qf_sp_asin_til&ad_type=product_link&tracking_id=hashbang09-20&marketplace=amazon&region=US&placement=B01H74VKZU&asins=B01H74VKZU&linkId=0753b2eff187b5308ee9d9ed3b511732&show_border=false&link_opens_in_new_window=false&price_color=333333&title_color=0066c0&bg_color=ffffff">
    </iframe>

I put one at the back of the apartment and one where Spectrum's cable
modem use to plug in. I connected the back one the NYC Mesh router and
plugged in another wireless hostspot to the front one (these are not
wireless extenders).

Only a few devices were grumpy because they weren't getting the right
nameserver from their DHCP lease. The NYC Mesh router chose
*192.168/16* as its private network while I had previously used
*10.1/16*. I wanted Cloudflare's *1.1.1.1* nameserver but some things
were fixed on the old *10.1.0.1*. Curiously, the CBS All Access app on
Apple TV did not have a problem while Prime Video and YouTube did.
