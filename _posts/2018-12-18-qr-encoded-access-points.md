---
layout: post
title: QR-encoded Access Points
tags: qr-code wifi ruby ubuntu
stopwords: QR
---

I give my visitors the password for my guest WiFi, usually by writing
it down because dictating it is too hard. Was it the 53rd or 54th character
that they messed up? Or which character did I write down incorrectly?

Now I have that encoded in QR:

![WiFi QR code](/images/wifi-qr-code.png)

Point your iOS camera ([iOS 11 and up](https://developer.apple.com/videos/play/tech-talks/206/)) at this and it fills in the network details. Don't have
an iPhone? I hope you aren't expecting any messages. Well, [Android users](https://android.gadgethacks.com/how-to/easily-share-your-wi-fi-password-with-qr-code-your-android-phone-0183483/)
can go into their network settings and scan the code or whatever they do.

There are websites that will do this for you, but the Ruby [qrencoder](https://rubygems.org/gems/qrencoder/versions/1.4.1)
gem provides the a *qrencoder* program

{% highlight text %}
$ sudo apt-get install qrencode libqrencode-dev ruby ruby-dev
$ sudo brew install qrencoder
{% endhighlight %}

Give *qrencode* the [ZXing-style auth string](https://github.com/zxing/zxing/wiki/Barcode-Contents#wifi-network-config-android):

{% highlight text %}
$ qrencode -o wifi.png "WIFI:T:WPA;S:SomeSSID;P:NotThePassword;;"
{% endhighlight %}
