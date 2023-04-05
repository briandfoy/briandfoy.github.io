---
layout: post
title: Encrypting secrets for GitHub's API with Perl and libsodium
categories: perl programming github
tags: libsodium
stopwords:
last_modified:
original_url:
---

The [GitHub API for
Secrets](https://docs.github.com/en/rest/actions/secrets) uses
[libsodium](https://doc.libsodium.org) to exchange the secret. I
request the public key for my repository, I encrypt my secret with my
repository's public key, and I send it back to GitHub. My repository
can then decode it with its secret key (which I don't know).

The API docs have examples in Node, Python, Ruby, and C#. I worked out
an example in Perl which takes the Base64 encoded public key as
provided by the API and returns the Base64 encoded secret I need to
send back.

<!--more-->

{% highlight perl %}
sub _nacl_encrypt ($plain, $public_key_base64) {
	state $rc =	require Sodium::FFI;
	my $key_bin = Sodium::FFI::sodium_base642bin($public_key_base64);
	my $crypted = Sodium::FFI::crypto_box_seal( $plain, $key_bin );
	return Sodium::FFI::sodium_bin2base64($crypted);
	}
{% endhighlight %}

This requires a [pull request I created for Sodium::FFI](https://github.com/genio/sodium-ffi/pull/3) to add
`crypto_box_seal`, although you could do a lot more work to use `crypto_box_easy`.

## A bonus treat

While testing this, I wanted a way to look at the secret in GitHub Actions
so I knew that I had uploaded what I intended. However, GitHub masks
anything it thinks is a secret by replacing the secret's text with `***`.

Inside the action, I output the secret's text with spaces between every
character:

{% highlight yaml %}
jobs:
    update-ranges:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v3
            - name: Show secret
              run: |
                echo ${{secrets.TEST_SECRET}} | sed 's/./& /g'
{% endhighlight %}

As an aside, it's pretty easy to discover secrets this way. I simply
output enough text until I find text that GitHub Actions decides it should
mask. For things like personal access tokens, that's a lot of combinations.
But for other things,
