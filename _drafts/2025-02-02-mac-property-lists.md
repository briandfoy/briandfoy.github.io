---
layout: post
title: Mac Property Lists
categories:
tags:
stopwords:
last_modified:
original_url:
---

<!--more-->


Apple's Property List format has a long history. Now Apple can handle XML, JSON, ObjC, or Swift, but back in the day it was XML. For that reason, my [Mac::PropertyList](https://www.metacpan.org/pod/Mac::PropertyList) Perl module seems really clunky.

<!--
https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/AboutInformationPropertyListFiles.html
-->

## The formats

Start with Apple's *plutil* to creaet a new plist file. I end the filename with *.plist*, but that's not a signifier for the format that will be inside the file that you might expect with something like *.xml* or *.json*..

I start with the `xml1` format, which already shows the premature optimism that XML might keep going on to version 2, 3, 17, and so on:

$ plutil -create xml1 empty.plist
$ more empty.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict/>
</plist>

The default data type at the top of the structure (one level under `<plist>`) is an empty dictionary (hash, object, whatever). I'll add data to that in the next section:

Do the same thing but with the `json` format, which is much simpler:

$ plutil -create json json.plist

$ more plist.json
{}

It doesn't matter what you choose because it's easy to convert to the other. But watch out because it replaces the file by default:

$ plutil -convert json empty.plist
$ more empty.plist
{}

Instead of replacing the file, use the `-o` switch to specify a different output file. In this example, that filename is `-`, the special name for standard output:

$ plutil -convert empty.plist -o -
{}

$ plutil -convert swift empty.plist -o -
/// Generated from plist.xml
let plist = [
    ]

$ plutil -convert objc empty.plist -o -
/// Generated from plist.xml
__attribute__((visibility("hidden")))
NSDictionary * const plist = @{
};

## Adding data

Start with an empty plist again. I'm going to keep going with XML because this will make more sense when I write about [Mac::PropertyList](https://www.metacpan.org/pod/Mac::PropertyList):

$ plutil -create xml1 new.plist

$ more new.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict/>
</plist>

Now, I'll add a simple string value.

$ plutil -insert some_string -string "first string" new.plist

$ more new.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>some_string</key>
        <string>first string</string>
</dict>
</plist>

Notice the two separate nodes under `<dict>` for `<key>` and `<value>`. Those are a required pair that should not be separated, but
they are. Add another key-value pair:

$ plutil -insert more_string -string "second value" new.plist

$ more new.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>more_string</key>
        <string>second value</string>
        <key>some_string</key>
        <string>first string</string>
</dict>
</plist>

I'll add a third value, but an integer this time.

$ plutil -insert some_number -integer 137 new.plist

$ more new.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>more_string</key>
        <string>second value</string>
        <key>some_number</key>
        <integer>137</integer>
        <key>some_string</key>
        <string>first string</string>
</dict>
</plist>

Now there are six nodes under `<dict>`, although there should be only be three because there are only three logical things:

<dict>
        <entry name="more_string" type="string">second value</key>
        <entry name="some_number" type="integer">137</key>
        <entry name="some_string" type="string">first string</key>
</dict>

This gets in the way of simply looking at the data, so *plutil* has the `-p` switch to show something simpler, which is so close to JSON that I have to wonder why they didn't do that:

$ plutil -p new.plist
{
  "more_string" => "second value"
  "some_number" => 137
  "some_string" => "first string"
}

Now I'll make the same thing with [Mac::PropertyList](https://www.metacpan.org/pod/Mac::PropertyList):





