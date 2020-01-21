---
layout: post
title: Speedtests
tags: command-line python speedtest nyc-mesh
stopwords:
---

pip install speedtest-cli


$ speedtest-cli
Retrieving speedtest.net configuration...
Testing from Spectrum (68.174.51.28)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by Natural Wireless (New York, NY) [5.93 km]: 16.386 ms
Testing download speed................................................................................
Download: 60.55 Mbit/s
Testing upload speed......................................................................................................
Upload: 11.89 Mbit/s


$ speedtest-cli --json
{"download": 62739979.93993792, "upload": 11754874.487030044, "ping": 15.015, "server": {"url": "http://nyc.speedtest.sbcglobal.net:8080/speedtest/upload.php", "lat": "40.7127", "lon": "-74.0059", "name": "New York, NY", "country": "United States", "cc": "US", "sponsor": "AT&T", "id": "5029", "host": "nyc.speedtest.sbcglobal.net:8080", "d": 5.9323532524349485, "latency": 15.015}, "timestamp": "2020-01-19T22:05:10.986822Z", "bytes_sent": 14999552, "bytes_received": 79240756, "share": null, "client": {"ip": "68.174.51.28", "lat": "40.6643", "lon": "-73.9763", "isp": "Spectrum", "isprating": "3.7", "rating": "0", "ispdlavg": "0", "ispulavg": "0", "loggedin": "0", "country": "US"}}


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
