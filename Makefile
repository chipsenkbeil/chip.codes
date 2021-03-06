
# Following https://github.com/steveklabnik/automatically_update_github_pages_with_travis_example

.PHONY: all clean build push

USER_NAME:="Chip Senkbeil"
USER_EMAIL:="chip.senkbeil+travis@gmail.com"
OUTPUT_DIR:="public/"

BRANCH:="gh-pages"
REPO:="github.com/chipsenkbeil/chip.codes.git"

DOMAIN:="chip.codes"
CNAME:="$(DOMAIN)\nwww.$(DOMAIN)"

# This is rerun every time it is accessed
REV=$(shell git rev-parse --short HEAD)

all: clean build

clean:
	rm -rf $(OUTPUT_DIR)

update:
	git pull origin master
	(cd themes/slate/ && git checkout master && git pull origin master)

build:
	$(GOPATH)/bin/hugo --theme="slate"

push:
	cd $(OUTPUT_DIR) && \
	git init && \
	git config user.email $(USER_EMAIL) && \
	git config user.name $(USER_NAME) && \
	git remote add upstream "https://$(GH_TOKEN)@$(REPO)" && \
	git fetch upstream && \
	git reset upstream/$(BRANCH) && \
	echo $(CNAME) > CNAME && \
	touch . && \
	git add -A && \
	git commit -m "Rebuilt pages at $(REV)" && \
	git push -q upstream HEAD:$(BRANCH)

