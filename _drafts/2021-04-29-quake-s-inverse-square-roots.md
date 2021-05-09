---
layout: post
title: Quake's Inverse Square Roots
categories:
tags:
stopwords:
last_modified:
original_url:
---

The article goes here

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/p8u_k2LIZyo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

 long i = 0x5F3759DF;
    float* fp = (float*)&i;
    printf("(2^127)^(1/2) = %f\n", *fp);
    //Output
    //(2^127)^(1/2) = 13211836172961054720.000000



## Further reading


* [Fast inverse square root - Wikipedia](https://en.wikipedia.org/wiki/Fast_inverse_square_root)
* https://www.beyond3d.com/content/articles/8/
* https://www.beyond3d.com/content/articles/15/
* http://www.lomont.org/papers/2003/InvSqrt.pdf
* https://stackoverflow.com/questions/1349542/john-carmacks-unusual-fast-inverse-square-root-quake-iii
