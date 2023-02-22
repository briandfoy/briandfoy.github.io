---
layout: post
title: The problems with types
categories:
tags:
stopwords:
last_modified:
original_url:
---

Some programmers obsess over types, and see the main point of programming as the categorization of information. If you can categorize everything correctly, you should end up with correct programs.

They might be right, and there might be people who are able to create these correctly typed programs. I have yet to encounter that programmer or those programs, though I've hardly tried to cross paths with them.

<!--more-->

More often, in which I mean always, I see programmers work hard to include type features but then completely ignore correctly specified types.

I'll show one example.

Suppose a task requires whole numbers, and for now that's all I'll specify. Many programmers will specify this as an `Int`, or the equivalent of whatever their programming language supplies.

But, is an `Int` really the type? Or, is any machine, database, or language type that's likely to correctly specify a logical type?

First, consider that very few language's types are logically correct because they are limited by physics. An `Int` may be four bytes, and you have to give up one of those bits for the sign. The physical type doesn't represent the actual set of integers. A mathematician would call that actual set ℤ. Some languages, however, take care of that for you because they don't tie themselves to hardware.

Second, very few logical types have such expansive ranges. This is where many programmers go wrong, either because they don't know they are wrong or they think they'll come back to fix it later.

Take, for example, the number of finger you have on your right hand. It won't be a negative number.  A programming might use an unsigned integer (`uInt`). That might work.

But what if it might be a fractional number depending on how you want to count amputations or deformities. You don't want a `uInt`. You want something different. But maybe you don't want a floating point number. Perhaps you only want to count by halves, or maybe thirds. You need to come up with some way to represent that and restrict values to it.

A diligent programmer may have already aliased this type to `NumberOfHandsOnFinger`, but I don't see that very often. If that diligent programmer had already done that, they could easily change its definition. But then, they also need to massage the input appropriately. Where you might have accepted 1 and 3 as valid before, now you might want 1½ or 2⅓ or something. That may be different that 1.5 or 1.3333333. Maybe the number is a whole number of thirds, so I have 15 thirds of a finger on my right hand.

Third, a `uInt` is still inappropriate because its range is unbounded. Some people have more than five fingers on a hand, so limiting it to five is inappropriate on the high side. And if each whole number represents something less than whole finger, that number can be much higher. Limiting it to 1 on the low side is also inappropriate because some people have lost all of their fingers (or never had them). Zero is a hard lower bound.

Fourth, a single number might be inappropriate. How would you distinguish four whole fingers and one missing finger to three whole fingers and two half fingers? Now you might represent the fingers on the hand as a list of numbers where each number represents on finger or part of a finger. But how many numbers should you use? The highest recorded number of fingers is 7 (and 10 for toes), so maybe you make that your maximum.

And this can go on and on, and this is a simple type.

If you aren't going to do this level of analysis, perhaps you don't want to use types as much as you think you do.



