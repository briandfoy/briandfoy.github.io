CURL=/usr/bin/curl
SITE_URL:=$(shell yq -r .url _config.yml)
SITE_HOST:=$(shell v='$(SITE_URL)'; url %h "$${v}")
GITHUB_USER=$(SITE_HOST:.github.io="")
CPANMODULES=.cpanmodules

.PHONY: publish
publish: tag
	git status
	git push origin master

.PHONY: tag
tag:
	$(PERL) bin/tags

.PHONY: rebuild
rebuild:
	$(CURL) -X \
	POST https://api.github.com/repos/$(GITHUB_USER)/$(SITE_HOST)/pages/builds \
	-H "Accept: application/vnd.github.mister-fantastic-preview+json"

.PHONY: setup
setup:
	cat $(CPANMODULES) | xargs cpan
	pip install yq

.PHONY: show_vars
show_vars:
	@echo $(SITE_URL)
	@echo $(SITE_HOST)
	@echo $(GITHUB_USER)
