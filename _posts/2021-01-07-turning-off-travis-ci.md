---
layout: post
title: Turning off Travis CI
categories: programming
tags: ci devops continuous-improvement
stopwords: GDPR
last_modified:
original_url:
---

I'm dropped all Travis CI support. Travis is already dropping Open Source, so I'm just getting there first. I had to do quite a bit to clean this, so maybe you want that list too.

![](/images/travis/travis.png)

Travis CI used to offer free continuous integration support for open source projects and they had promised to always do that. In 2019, [the company was acquired](https://blog.travis-ci.com/2019-01-23-travis-ci-joins-idera-inc) and that non-binding promise was broken. Their acquisition announcement reiterated their promise:

> Open source is at the heart of Travis CI. We will continue to maintain a free, hosted service for open source projects, and will keep building features for the open source community. Additionally, our code will stay open source and under an MIT license. This is who we are, this is what made us successful.

Many people, represented by a long thread on Hacker News ([Travis CI is no longer providing CI minutes for open source projects](https://news.ycombinator.com/item?id=25338983)), were upset that some people didn't do what they said they would do.

The new system gives a fixed amount of credits to Open Source projects, and when you run out you have to ask for more. I can't see that working out for anyone, especially the employee who'd review and approve all of that.

I'm not too bothered by that, and it was a nice ride while it lasted. Things don't last forever and I never paid for it other than lending my projects to their numbers. The founders got to cash out and I got some free services for awhile. It all seemed to work out for everyone. And, there are plenty of competitors ready to take up the slack.

So, here's what I did. Most of it is finding the different places in GitHub where I allowed Travis access. I started putting this together once I realized that I had several things to do, and you might want to go through all the steps too:

* removed the *.travis.yml* file and Travis badges from all of my projects
* turned off all repo in my Travis dashboard
* turned off Travis in the personal section of my GitHub account ("Applications")
* turned off Travis in the Third-Party Access section for all of my organizations
* removed my Travis API key from by various environment files and secrets
* emailed *data@travis-ci.com* to ask them to remove my account (per [their privacy policy](https://docs.travis-ci.com/legal/privacy-policy#vii-your-rights)), since there's no setting to do that in my account. As a German company, they are governed by the GDPR
* email to *data@travis-ci.com* bounces, so I tried *support@travis-ci.com* too

Some things I didn't need to do but you may need:

* [remove "require status checks"](https://docs.github.com/en/free-pro-team@latest/github/administering-a-repository/enabling-required-status-checks) for Travis CI passing

If you know of other things I need to do, let me know.
