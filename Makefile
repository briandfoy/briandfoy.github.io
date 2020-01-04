CURL=/usr/bin/curl
SITE_URL=$(shell perl -MApp::ypath -e 'run' url .)
GITHUB_USER=
SITE_HOST=$(shell perl -MApp::ypath -MMojo::URL -e 'print Mojo::URL->new(run(qw(url .))->host')

.PHONY: rebuild
rebuild:
	$(CURL) -X \
	POST https://api.github.com/repos/$(GITHUB_USER)/$(GITHUB_REPO)/pages/builds \
	-H "Accept: application/vnd.github.mister-fantastic-preview+json"

.PHONY: show_vars
show_vars:
	echo $(SITE_URL)
	echo $(GITHUB_REPO)
