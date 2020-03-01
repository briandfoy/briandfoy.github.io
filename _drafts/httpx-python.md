Python has a new web user agent library, [HTTPx](https://www.python-httpx.org). It adds some features,
but since it's still the old [requests API](https://2.python-requests.org//en/v2.7.0/),
it's similarly hampered.

Here's a basic program. It's not different from what you've seen before:

	#!python
	import httpx

	response = httpx.get( 'http://httpbin.org/headers' )
	print( response.text );

There are some new features to add HTTP/2, concurrency, and WSGI/ASGI support,
but it still lacks the first thing I look for in any user agent library:
how do I see the request without making it? ["Printing and debugging Python HTTP requests"](https://danielkvist.net/code/printing-and-debugging-python-http-requests)
solves this by formatting the request object with new code, but that's
not the actual request. Several other layers get a chance to put their fingers
into this pot.

Here's where `requests` fails architecturally for me. It stores everything that you
need to make a request but it doesn't know how to format one. It leaves
that job to a dispatcher. That architecture is more sophisticated so it can plug
in different dispatchers (that's how if can integrate with WSGI or something else).

But, in the basic case it's still [urllib3](https://github.com/urllib3/urllib3/blob/master/src/urllib3/request.py):

{% highlight python %}
def send_single_request(self, request: Request, timeout: Timeout,) -> Response:
	"""
	Sends a single request, without handling any redirections.
	"""

	dispatcher = self.dispatcher_for_url(request.url)

	try:
		response = dispatcher.send(request, timeout=timeout)
	except HTTPError as exc:
		# Add the original request to any HTTPError unless
		# there'a already a request attached in the case of
		# a ProxyError.
		if exc.request is None:
			exc.request = request
		raise

	self.cookies.extract_cookies(response)

	status = f"{response.status_code} {response.reason_phrase}"
	response_line = f"{response.http_version} {status}"
	logger.debug(f'HTTP Request: {request.method} {request.url} "{response_line}"')

	return response
{% endhighlight %}

In [requests3](https://github.com/kennethreitz/requests3) (*requests3/core/__init__.py*),
there's `blocking_request`:

{% highlight python %}
def blocking_request(
    method,
    url,
    timeout,
    *,
    data=None,
    headers=None,
    stream=False,
    client=None,
    **kwargs
):
    """Returns a Response object."""
    if not client:
        client = http3.Client()
    with client as http:
        r = http.request(
            method=method,
            url=url,
            headers=headers,
            stream=stream,
            data=data,
            **kwargs
        )
        return r
{% endhighlight %}


https://danielkvist.net/code/printing-and-debugging-python-http-requests
