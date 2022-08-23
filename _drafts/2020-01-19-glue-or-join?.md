---
layout: post
title: Glue or Join?
tags: python
stopwords:
---

<!--more-->

$ python3
Python 3.6.9 (default, Nov  7 2019, 10:44:02)
[GCC 8.3.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import sys
>>> print '\n'.join(sys.path)
  File "<stdin>", line 1
    print '\n'.join(sys.path)
             ^
SyntaxError: invalid syntax
>>> print '\n', join(sys.path)
  File "<stdin>", line 1
    print '\n', join(sys.path)
             ^
SyntaxError: invalid syntax
>>> print( "\n".join(sys.path) )

/usr/lib/python36.zip
/usr/lib/python3.6
/usr/lib/python3.6/lib-dynload
/home/brian/.local/lib/python3.6/site-packages
/usr/local/lib/python3.6/dist-packages
/usr/lib/python3/dist-packages
