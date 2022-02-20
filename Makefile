# These things are related to the config
SITE_URL:=$(shell yq -r .url _config.yml)
SITE_HOST:=$(shell v='$(SITE_URL)'; url %h "$${v}")
GITHUB_USER:=$(SITE_HOST:.github.io=)

# Things related to the GitHub API
CURL:=/usr/bin/curl --netrc --silent
GITHUB_API_BASE:=https://api.github.com/repos/$(GITHUB_USER)/$(SITE_HOST)/pages

# These things are related to Perl
CPANMODULES=.cpanmodules

# These things are related to Ruby
RUBYLIB=lib
export RUBYLIB

# These things are related to Markdown Lint (mdl)
# https://github.com/markdownlint/markdownlint
MDL:=mdl -c .mdlrc

# Things related to spellchecking
ASPELL_WORDLIST=./.aspell.rws
PID:=$$PPID
PER_FILE_WORDLIST:=/tmp/.aspell.$(PID).rws
ASPELL:=aspell --add-extra-dicts=$(ASPELL_WORDLIST) --encoding=utf-8
ASPELL_BASE=.aspell.pws
STRIP_MD:=bin/strip_md_codeblocks

# Things relates to the posts
DRAFTS_DIR:=_drafts
POSTS:=$(wildcard _posts/*.md)
GENERATED_PAGES:=archives.md
INCLUDES:=$(wildcard _includes/*.html)
LAYOUTS:=$(wildcard _layouts/*.html)
STYLES:=$(wildcard _sass/*.scss)

OPEN=open
EDITOR=bbedit

######################################################################
# Setup

# XXX needs the ruby / jekyll installation
# XXX install mdl
.PHONY: setup
setup: ## setup the tools (try to install what you need)
	cat $(CPANMODULES) | xargs cpan
	pip install yq
	sudo gem install bundler
	bundle install

.PHONY: show_vars
show_vars: ## show some variables, useful for debugging
	@echo "SITE_URL    " $(SITE_URL)
	@echo "SITE HOST   " $(SITE_HOST)
	@echo "GITHUB_USER " $(GITHUB_USER)
	@echo "PER_FILE_WORDLIST " $(PER_FILE_WORDLIST)
	@echo "Posts " $(POSTS)

######################################################################
# Local server

# https://help.github.com/en/enterprise/2.14/user/articles/setting-up-your-github-pages-site-locally-with-jekyll
.PHONY: localstart ## serve the site locally
localstart: preprocess ## run jekyll locally
	- pkill -f jekyll 2> /dev/null
	bundle exec jekyll serve --drafts --detach
	open -a 'Safari' http://127.0.0.1:4000/

.PHONY: localstop
localstop: ## stop the local server
	- pkill -f jekyll > /dev/null

.PHONY: localrestart
localrestart: localstop localstart ## restart the local server

.PHONY: open
open: ## open the website
	@ $(OPEN) $(SITE_URL)

######################################################################
# Making pages

archives.md: bin/make_archives bin/post_years $(POSTS)
	@ bin/post_years $(POSTS) | xargs bin/make_archives > $@
	- git add $@
	- git commit -m 'Update archives for the years' $@

books.md: bin/make_books_page.pl books.json
	$(PERL) bin/make_books_page.pl > $@

.PHONY: new
new: ## create a new draft an open it in an editor
	@ bin/new_article; \
	  LATEST_FILE=`ls -1Art $(DRAFTS_DIR) | tail -n 1`;\
	  echo "Latest file " $$LATEST_FILE;\
	  $(EDITOR) $(DRAFTS_DIR)/$$LATEST_FILE;\

.PHONY: preprocess
preprocess: archives.md books.md tags $(GENERATED_PAGES) $(INCLUDES) $(LAYOUTS) $(STYLES) ## wrap everything to build the site

.PHONY: tags
tags:
	@ true

######################################################################
# Testing things
.PHONY: lint
lint: ## check the markdown
	@ for file in _posts/*.md; do \
		echo "====" $$file "===="; \
		$(STRIP_MD) "$$file" | $(MDL); \
	done

.PHONY: spell
spell: ## spellcheck the markdown files in _posts/
	@ for file in _posts/*.md; do \
		echo "====" $$file "===="; \
		echo "personal_ws-1.1 en 0 utf-8" > $(PER_FILE_WORDLIST); \
		$(PERL) bin/stopwords "$$file" >> $(PER_FILE_WORDLIST); \
		$(STRIP_MD) "$$file" | $(ASPELL) --add-extra-dicts=$(PER_FILE_WORDLIST) list | sort | uniq -u; \
	done
	@ rm $(PER_FILE_WORDLIST)

######################################################################
# Publishing
# https://developer.github.com/v3/repos/pages/
.PHONY: publish
publish: preprocess ## remake stuff and send it to GitHub
	git status
	$(PERL) bin/tag_release
	git push --follow-tags all master

.PHONY: rebuild
rebuild: ## tell GitHub to rebuild the site
	$(CURL) -X POST \
	$(GITHUB_API_BASE)/builds \
	-H "Accept: application/vnd.github.mister-fantastic-preview+json"

######################################################################
# Monitoring
# https://developer.github.com/v3/repos/pages/
.PHONY: status
status: ## show the GitHub Pages build status
	@ $(CURL) $(GITHUB_API_BASE) | jq -r .status

# https://developer.github.com/v3/repos/pages/
# also think about the localserver target
.PHONY: error
error: ## show the error from the last build
	@ $(CURL) $(GITHUB_API_BASE)/builds/latest | jq -r .error.message

######################################################################
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help ## Show all the Makefile targets with descriptions
help: ## show a list of targets
	@grep -E '^[a-zA-Z][/a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
