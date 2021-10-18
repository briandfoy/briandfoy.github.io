---
layout: post
title: Quake's Fast Inverse Square Algorithm
categories:
tags:
stopwords:
last_modified:
original_url:
usemathjax: true
---

Quake III has a super-optimized, good-enough [inverse square algorithm](https://en.wikipedia.org/wiki/Fast_inverse_square_root). As
a graphical game, they need millions and millions of these operations so
it better be fast.

$$
f(x) = \frac{1}{\sqrt{x}}
$$

The first pass in code is easy. Take the square root and divide one
by it:

{% highlight cpp %}
y = 1 / sqrt(x);
{% endhighlight %}

But, that `sqrt(x)` is not that fast, or, more properly, not fast enough
for Quake's purposes (because "fast" only matters when you have an expectation).
Division isn't a speedy operation either. The developers had to come up with something faster.

Here's the code from Quake:

{% highlight cpp %}
float Q_rsqrt( float number )
{
	long i;
	float x2, y;
	const float threehalfs = 1.5F;

	x2 = number * 0.5F;
	y  = number;
	i  = * ( long * ) &y;                       // evil floating point bit level hacking
	i  = 0x5f3759df - ( i >> 1 );               // what the fuck?
	y  = * ( float * ) &i;
	y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration
//	y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration, this can be removed

	return y;
}
{% endhighlight %}

Here's a discussion of it on YouTube, and mostly what I'm about to write. Wikipedia
explains it, for I found it's discussion very dense and convoluted. I think this
YouTube video does a much better job, but there were times he asks the
viewer to work it out for themselves. So, that's what I'm here to do.

<div class="youtube">
<iframe width="560" height="315" src="https://www.youtube.com/embed/p8u_k2LIZyo" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

The algorithm plays various clever, deep-magic tricks with bits to make everything
work out.

First, notice that `i` is a long and that `y` is float. Each is 32 bits,
but the computer uses those bits differently. Notice that the code puts
the value in `number` in `y`, a `float`, but then translate it to a
`long`.

The rest of the magic comes from knowing things about the bit patterns
and messing with those. Reading [What Every Computer Scientist Should Know About Floating-Point Arithmetic](https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html)
may be helpful here, but it's far more than you need. Here's what a IEEE 754
float looks like:

    sign   exponent (E) mantissa (M)
    0      00000000     00000000000000000000000

The exponent is signed to give us values from -127 to 128, and the mantissa
is a value between 1 and 2 (because, in binary exponential notation, the leading
one is assumed: it's the only possible non-zero value).

For some value, the bit pattern is $2^{23}E$ (to shift the exponent into
the right place) added to whatever is in $M$. That's $2^{23}E+M$. That's just to make the right
sequence of bits appear, manually, without something else constructing that
for us.

The actual number works out to be:

$$
(1+\frac{M}{2^{23}}) 2^{E-127}
$$

The $\frac{M}{2^{23}}$ gives the mantissa the right magnitude and the $1 +$ shifts
it to be between 1 and 2. The $E-127$ gives us the right exponent from the
signed bit pattern (*e.g.* an exponent of 4 would actually be the bit pattern
for 131):

$$
\begin{align*}
log_2( (1+\frac{M}{2^{23}}) 2^{E-127} )          \\
log_2( 1+\frac{M}{2^{23}} ) + log_2( 2^{E-127} ) \\
log_2( 1+\frac{M}{2^{23}} ) + E - 127
\end{align*}
$$

Henceforth, all logarithms are $log_2$.

But, math people know a trick. For $x$ close to 1, the logarithm is just $x$
and a small fudge factor (0.0430 minimizes the average deviation between 0
and 1):

$$
log( 1 + x ) \approx x + \mu
$$

With some replacement and rearrangement of terms, this yields the bit representation, $M + 2^{23} E $,
scaled ($\frac{1}{2^{23}}$) and shifted ($\mu - 127$):

$$
\begin{align*}
log( 1 + \frac{M}{2^{23}} ) + E - 127         \\
\frac{M}{2^{23}} + \mu + E - 127              \\
\frac{M}{2^{23}} + E + \mu - 127              \\
\frac{1}{2^{23}} ( M + 2^{23} E ) + \mu - 127
\end{align*}
$$

That is, we have the bit representation we started with ($M + 2^{23} E$) even though we
took the logarithm.

Now the bit magic happens. First, you can't do
bit operations on floats, but you can on longs. So treat the bit pattern in
`y` as a long (`i  = * ( long * ) &y`) by telling C to treat the 32 bits
starting at address `&y` as a `long`. So, `i` had the value of $log(y)$ (still
without scaling and shifting).

Consider what we are trying to get, noticing that working in logarithms
has some big wins. The value we want is minus one half of the logarithm of the
input number. And, we know what the log of that input number is already:

$$
log( \frac{1}{\sqrt{y}} ) = log( y^{-\frac{1}{2}} ) = -\frac{1}{2} log(y) = -\frac{1}{2} i
$$

The next part takes the bit pattern in `i` and shifts it to the right 1 place.
That's the same thing as dividing by 2. In code, $-\frac{1}{2} log(y)$ is `- ( i >> 1 )`.
That's one of the terms we see in the WTF line.

The other term is more mysterious, but represents that scale and shift we
have so far ignored. Suppose that $\Gamma$ is the answer that we want, and
send that through everything we know so far:

$$
\begin{align*}
\Gamma        &= \frac{1}{\sqrt{y}}        \\
log( \Gamma ) &= log( \frac{1}{\sqrt{y}} ) \\
log( \Gamma ) &= -\frac{1}{2} log(y) \\
\frac{1}{2^{23}} (M_{\Gamma} + 2^{23} E_{\Gamma}) + \mu - 127 &= - \frac{1}{2} ( \frac{1}{2^{23}} (M_{y} + 2^{23} E_{y}) + \mu - 127 ) \\
(M_{\Gamma} + 2^{23} E_{\Gamma}) &=  \frac{3}{2} (2^{23}(127-\mu)) - \frac{1}{2} (M_{y} + 2^{23} E_{y}) \\
(M_{\Gamma} + 2^{23} E_{\Gamma}) &= 0x5f3759df - \frac{1}{2} (M_{y} + 2^{23} E_{y}) \\
(M_{\Gamma} + 2^{23} E_{\Gamma}) &= 0x5f3759df - ( i >> 1 ) \\
\end{align*}
$$

That magic `0x5f3759df` comes from trial and error and decades of fooling
around with this algorithm.

To get back to the floating point value, reverse the bit magic by reading
23 bits from the address `i` and treating it as a `float`: `y = * ( float * ) &i`.
That's almost the answer. It's not exact, but we can send it through
a single iteration of Newton's Method:

$$
y_1 = y_0 - \frac{f(y_0)}{f'(y_0)}
$$

Rearrange everything to get a function in terms of $y$:

$$
\begin{align*}
y                 &= \frac{1}{\sqrt{n}}  \\
y^2               &= \frac{1}{n}         \\
\frac{1}{y^2}     &= n                   \\
\frac{1}{y^2} - n &= 0                   \\
\end{align*}
$$

So, $f(y) = \frac{1}{y^2} - n = 0$. The derivative of that is $f'(y) = -\frac{2}{y^3}$.

$$
\begin{align*}
y_1 &= y_0 - \frac{f(y_0)}{f'(y_0)}               \\
y_1 &= y_0 - \frac{(\frac{1}{y_0^2} - n)}{(-\frac{2}{y_0^3})}         \\
y_1 &= y_0 + \frac{y_0^3 (\frac{1}{y_0^2} - n)}{2}            \\
y_1 &= y_0 + \frac{( y_0 - y_0^2 n )}{2}                \\
y_1 &= \frac{3}{2} y_0 + \frac{( y_0^2 n )}{2}          \\
y_1 &= y_0 \frac{( 3 - y_0^2 n )}{2}              \\
y_1 &= y_0 ( \frac{3}{2} - \frac{n}{2} y_0 y_0 )
\end{align*}
$$

That last line looks like the expression `y = y * ( threehalfs - ( x2 * y * y ) )`
since `x2 = number * 0.5F`.

That line is repeated (but commented) because one iteration of Newton's
Method is close enough. And, notice that even though it looks like there
are divisions, there are no divisions. Those are constants that we've
previously set up.


