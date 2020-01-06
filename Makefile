SITE_URL:=$(shell yq -r .url _config.yml)
SITE_HOST:=$(shell v='$(SITE_URL)'; url %h "$${v}")
GITHUB_USER:=$(SITE_HOST:.github.io=)

# Things related to the GitHub API
CURL:=/usr/bin/curl --netrc --silent
GITHUB_API_BASE:=https://api.github.com/repos/$(GITHUB_USER)/$(SITE_HOST)/pages

CPANMODULES=.cpanmodules

# Things related to spellchecking
ASPELL_WORDLIST=./.aspell.rws
PID:=$$PPID
PER_FILE_WORDLIST:=/tmp/.aspell.$(PID).rws
ASPELL:=aspell --add-extra-dicts=$(ASPELL_WORDLIST) --encoding=utf-8
ASPELL_BASE=.aspell.pws
STRIP_MD:=bin/strip_md_codeblocks

.PHONY: publish
publish: tag ## Remake stuff and send it to GitHub
	git status
	git push origin master

# https://longqian.me/2017/02/09/github-jekyll-tag/
.PHONY: tag
tag: ## create the tag files
	$(PERL) bin/tags
	git add tag && git commit -m 'New tags' tag

# https://developer.github.com/v3/repos/pages/
.PHONY: status
status: ## show the GitHub Pages build status
	@ $(CURL) $(GITHUB_API_BASE) | jq -r .status

# https://developer.github.com/v3/repos/pages/
.PHONY: error
error: ## show the error from the last build
	@ $(CURL) $(GITHUB_API_BASE)/builds/latest | jq -r .error.message

.PHONY: spell
spell: ## spellcheck the markdown files in _posts/
	@ for file in _posts/*.md; do \
		echo "====" $$file "===="; \
		echo "personal_ws-1.1 en 0" > $(PER_FILE_WORDLIST); \
		$(PERL) bin/stopwords $$file >> $(PER_FILE_WORDLIST); \
		$(STRIP_MD) $$file | $(ASPELL) --add-extra-dicts=$(PER_FILE_WORDLIST) list | sort | uniq -u; \
	done
	@ rm $(PER_FILE_WORDLIST)

# https://developer.github.com/v3/repos/pages/
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
	@echo "PER_FILE_WORDLIST " $(PER_FILE_WORDLIST)

######################################################################
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help ## Show all the Makefile targets with descriptions
help: ## show a list of targets
	@grep -E '^[a-zA-Z][/a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
