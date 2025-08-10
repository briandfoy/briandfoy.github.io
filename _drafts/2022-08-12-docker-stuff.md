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

# review a failed build

https://stackoverflow.com/questions/26220957/how-can-i-inspect-the-file-system-of-a-failed-docker-build/35387446#35387446

{% highlight text %}
# Find the failed build CONTAINER ID
docker ps -a

# Commit the failed container to an image
docker commit <sha>

# Run the new image to inspect
docker run -it <img-id> bash -il
{% endhighlight %}

## Further reading

* https://thehftguy.com/2016/11/01/docker-in-production-an-history-of-failure/
* https://blog.gruntwork.io/a-crash-course-on-docker-34073b9e1833
* https://vsupalov.com/docker-image-layers/
* https://earthly.dev/blog/lxc-vs-docker/
* https://depot.dev/blog/docker-clear-cache
