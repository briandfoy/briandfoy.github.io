---
layout: post
title: python-s-weird-ssl-issues
categories:
tags:
stopwords:
last_modified:
---

<!--more-->

brian@macpro ~ [3028]$ bin/speedtest-cron
Cannot retrieve speedtest configuration
ERROR: <urlopen error [SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed: unable to get local issuer certificate (_ssl.c:1108)>
^C


http://www.cdotson.com/2017/01/sslerror-with-python-3-6-x-on-macos-sierra/

Python has own bundle

https://stackoverflow.com/a/42107877/2766176

https://github.com/sivel/speedtest-cli

https://stackoverflow.com/questions/3160909/how-do-i-deal-with-certificates-using-curl-while-trying-to-access-an-https-url


https://gist.githubusercontent.com/briandfoy/ba285633dc01ea1b2cfc63adea5032b1/raw/69a24fa3f9da82facd2b035430733cde677073a4/speedtest-cron

