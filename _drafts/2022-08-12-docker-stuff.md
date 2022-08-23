---
layout: post
title: Docker stuff
categories:
tags:
stopwords:
last_modified:
original_url:
---

<!--more-->

Create an image

	docker build --no-cache -t creator/name:version -f Dockerfile .

Create the container for the first time:

	docker container run -it --name NAME creator/name:version

Run the container once it exists but is stopped

	docker start NAME



## Further reading

* https://thehftguy.com/2016/11/01/docker-in-production-an-history-of-failure/
* https://blog.gruntwork.io/a-crash-course-on-docker-34073b9e1833
* https://vsupalov.com/docker-image-layers/
* https://earthly.dev/blog/lxc-vs-docker/
