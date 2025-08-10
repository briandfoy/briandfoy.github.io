---
layout: post
title: Not remembering how to convert F to C
categories: teaching
tags: temperature
stopwords:
last_modified:
original_url:
---

I can never remember the formula for the conversion between degrees Celcius and degrees Fahrenheit, but that's not a problem because I know something better. You likely know it too, so each time you need the formula, simply derive it again based on things you know.

<!--more-->

This process is handy when your chemistry practical exam is the construction and gradation of a thermometer.

Temperature scales are linear and if you know two points on the line, you can get the other ones, even if they are far away:

* The boiling point of water (at standard pressure) is 212℉ or 100℃.
* The freezing point of water is 32℉ or 0℃.
* A less useful fact is that -40℉ and -40℃ are the same temperature.

So, the conversion must take a temperature in Celcius and bump it up to Fahrenheit, which has smaller units. That is, I know a small number in Celcius makes a larger one in Fahrenheit.

I know the formula is something like this, where I start with Celcius, convert that number based on the ratio (*r*) in units between the two scales, then shift it for an offset, *o*:

    F = r C + o

Since I know that one of the points in has 0℃, I immediately know *o*:

    32℉ = r*0℃ + o

    32℉ = o

That leaves me to figure out *r*. I

    F = r C + 32

    212℉ = r 100℃ + 32℉

    r = 180℉ / 100℃

    r =  9℉/5℃

This makes the entire formula:

    F = 9℉/5℃ C + 32℉

To get this far, I didn't have to remember any more that I should already know. With basic physical properties, I can work my way back to the conversions.

As an aside, why are the Fahrenheit numbers 32 and 212? It's easy to understand the Celcius number because they are based off the properties of water. But, Celsius is a latecomer since it wasn't until around the 1740s that they figured out the melting point of ice and boiling point of water were invariable under certain conditions.

The Fahrenheit scale, from the 1720s, is different but chooses similar numbers for different reasons. The point for 100 was the human body temperature, but that's not a constant. It's not reproducible across people are even the same person across time. The 0 was a different story: the fable goes that Fahrenheit chose the coldest temperature he could measure with this invention, the mercury thermometer. What that coldest thing was I don't know, but once notched on the thermometer, you know when it is that cold again. Now divide that coldest thing and Fahrenheit's own body temperature (probably) into exactly one hundred equally spaced units. Put that in ice (fresh) water and you get 32. Extend the scale and we get 212 for the boiling point of water.

## Lord, Kelvin!

But then there is the Kelvin scale, which based its idea on the energy in a fixed quantity of gas. In statistical thermodynamics with *N* gas particles, you have something familiar:

    PV = kNT

    k = PV / NT

Work out the numbers and you get -273℃, roughly, as the point where everything stops moving. That number is closer to -273.16℃, and that's one of life's magic numbers that you should just know. I need just one more fact: The unit size is the same as the Celcius scale; if I know the Celcius temperature, I just shift up 273.16.
