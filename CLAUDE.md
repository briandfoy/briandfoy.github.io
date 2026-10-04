# Claude instructions

* obey any global instructions
* you can read any files in this directory without asking

## Architecture

* This is a Jekyll project
* Targets GitHub pages

## Avoided technology

* Avoid all ad trackers, beacons, and other privacy-violating tools
* No analytics links

## Categories and tags

* Edit articles in `_articles/`; `bin/sort_articles.pl` copies them to `_posts/` or `_drafts/` based on `status:`
* `categories:` and `tags:` are single lines of space-separated, lowercase, hyphenated words
* Categories are broad buckets, such as programming, opinion, reading-list, cheatsheet, computer-science, science, technology, society, writing, teaching, system-administration, personal-history, timeline, book-review, and rescued-content
* Tags are specific topics, technologies, and people
* Specific technologies and topics are tags, not categories (e.g. perl, raku, macos, command-line, open-source, ai, containers, regex, object-orientation)
* Tags are singular (daemon, not daemons)
* Prefer existing categories and tags over new ones
* Tag people (authors, speakers) only when their name appears in the article text, not from URLs or outside knowledge
* rescued-content is a category for articles republished from elsewhere (they usually have an `original_url`)
* Articles tagged open-source also get the programming category
* The raku and perl6 tags always appear together
* Use `bin/move_word.pl WORD FROM TO FILE...` to move a word between `categories:` and `tags:`
