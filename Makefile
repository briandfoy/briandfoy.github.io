CURL:=/usr/bin/curl --netrc --silent
SITE_URL:=$(shell yq -r .url _config.yml)
SITE_HOST:=$(shell v='$(SITE_URL)'; url %h "$${v}")
GITHUB_USER:=$(SITE_HOST:.github.io=)
CPANMODULES=.cpanmodules
ASPELL_WORDLIST=./.aspell.rws
ASPELL:=aspell --add-extra-dicts=$(ASPELL_WORDLIST)
ASPELL_BASE=.aspell.pws
GITHUB_API_BASE:=https://api.github.com/repos/$(GITHUB_USER)/$(SITE_HOST)/pages
STRIP_MD:=bin/strip_md_codeblocks

.PHONY: publish
publish: tag ## Remake stuff and send it to GitHub
	git status
	git push origin master

.PHONY: tag
tag: ## create the tag files
	$(PERL) bin/tags
	git add tag && git commit -m 'New tags' tag

.PHONY: status
status: ## show the GitHub Pages build status
	@ $(CURL) $(GITHUB_API_BASE) | jq -r .status

.PHONY: error
error: ## show the error from the last build
	@ $(CURL) $(GITHUB_API_BASE)/builds/latest | jq -r .error.message

.PHONY: spell
spell: ## spellcheck the markdown files in _posts/
	for file in _posts/*.md; do \
		echo "====" $$file "===="; \
		$(STRIP_MD) $$file | $(ASPELL) list | sort | uniq -u; \
	done

.PHONY: rebuild
rebuild: ## tell GitHub to rebuild the site
	$(CURL) -X POST \
	$(GITHUB_API_BASE)/builds \
	-H "Accept: application/vnd.github.mister-fantastic-preview+json"

.PHONY: setup
setup: ## setup the tools (try to install what you need)
	cat $(CPANMODULES) | xargs cpan
	pip install yq

.PHONY: show_vars
show_vars: ## show some variables, useful for debugging
	@echo "SITE_URL    " $(SITE_URL)
	@echo "SITE HOST   " $(SITE_HOST)
	@echo "GITHUB_USER " $(GITHUB_USER)

######################################################################
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help ## Show all the Makefile targets with descriptions
help: ## show a list of targets
	@grep -E '^[a-zA-Z][/a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
