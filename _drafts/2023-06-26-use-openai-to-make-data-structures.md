---
layout: post
title: Use OpenAI to make data structures
categories:
tags:
stopwords:
last_modified:
original_url:
---

I'm skeptical that something like ChatGPT can write code that I'd want to commit; experienced programmers don't need the help, and those who don't need the help won't recognize the mistakes.

Still, my friend David Farrell asked me to play with a Bash script he wrote to interact with OpenAI (and which he hasn't made public). I found one area in programming that it might be useful: it can create data structures in some cases where I'd have to do a bit of work to pull things together.

<!--more-->

First, I start with a question that will enumerate the colors in the rainbow.

{% highlight text %}
$ ./ch n 'What are the colors in the rainbow'
The colors in the rainbow are red, orange, yellow, green, blue, indigo, and violet.
{% endhighlight %}

But now I want it as a JSON array. This time, the response has a bunch of extraneous information but ends with a correct data structure:

{% highlight text %}
$ ./ch n 'What are the colors in the rainbow? Present the output as a JSON array'
As an AI language model, I do not have a sensory function to see the colors in the rainbow; however, the common knowledge is that the colors in the rainbow are:
- Red
- Orange
- Yellow
- Green
- Blue
- Indigo
- Violet

Here is the output of the requested JSON array:

["Red", "Orange", "Yellow", "Green", "Blue", "Indigo", "Violet"]
{% endhighlight %}

How about an object? I'll ask for the values to be their wavelengths:

{% highlight text %}
$ ./ch n 'What are the colors in the rainbow? Present the output as a JSON object with the color as the key and the wavelength as the value'
{
  "red": "700-635 nm",
  "orange": "635-590 nm",
  "yellow": "590-560 nm",
  "green": "560-520 nm",
  "blue": "520-490 nm",
  "indigo": "490-450 nm",
  "violet": "450-400 nm"
}
{% endhighlight %}

This is pretty close to something useful, so I adjust that:

{% highlight text %}
$ ./ch n 'What are the colors in the rainbow? Present the output as a JSON object with the color as the key and the wavelength as the value as an array'
{
  "red": [620, 750],
  "orange": [590, 620],
  "yellow": [570, 590],
  "green": [495, 570],
  "blue": [450, 495],
  "indigo": [420, 450],
  "violet": [380, 420]
}
{% endhighlight %}

And now as a Perl data structure:

$ ./ch n 'What are the colors in the rainbow? Present the output as a Perl hash with the color in french as the key and the wavelength as the value as an array'
{
  "rouge" => [620, 750],
  "orange" => [590, 620],
  "jaune" => [570, 590],
  "vert" => [495, 570],
  "bleu" => [450, 495],
  "indigo" => [420, 450],
  "violet" => [380, 420]
}

Bump it up a notch.

$ ./ch n 'Produce a JSON object where the keys are countries and the values are an array of the colors in their flag'
{
  "Argentina": ["blue", "white"],
  "Australia": ["blue", "white", "red"],
  "Brazil": ["green", "yellow", "blue"],
  "Canada": ["red", "white"],
  "China": ["red", "yellow"],
  "France": ["blue", "white", "red"],
  "Germany": ["black", "red", "gold"],
  "India": ["orange", "white", "green"],
  "Italy": ["green", "white", "red"],
  "Japan": ["white", "red"],
  "Mexico": ["green", "white", "red"],
  "Nigeria": ["green", "white"],
  "Russia": ["white", "blue", "red"],
  "South Africa": ["red", "blue", "green", "yellow", "black", "white"],
  "Spain": ["yellow", "red"],
  "United Kingdom": ["blue", "white", "red"],
  "United States": ["red", "white", "blue"]
}

This looks like OpenAI did something amazing, but it's not complete. The flags of Argentina, Brazil, India, Mexico, and Spain are missing some colors. The major colors are there, sure, but incomplete might as well be wrong. And, this is the problem: you can't trust the results but people seem to cut and paste directly into their work without taking the time to verify and adjust it.
