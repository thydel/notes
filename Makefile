MAKEFLAGS += -Rr
MAKEFLAGS += --warn-undefined-variables
SHELL := $(shell which bash)
.SHELLFLAGS := -euo pipefail -c

.ONESHELL:
.DELETE_ON_ERROR:
.PHONY: phony

.RECIPEPREFIX :=
.RECIPEPREFIX +=

top:; @date

Makefile:;
%.md:;

id:; @date -u +'touch %FT%TZ.md' | tr : _

mds := $(sort $(wildcard *-*.md))
jsons := $(mds:%.md=%.json)
gists := $(mds:%.md=%.gist)

json: $(jsons)
gist: $(gists)

~ := %.json
$~: md = $<
$~: json = $@
$~: base = $(basename $(md))
$~: id = $(subst _,:,$(base))
$~: jq = . + { file: "$(md)", id: "$(id)" }
$~: %.md Makefile; pandoc $(md) --template meta.json | jq '$(jq)' > $(json)

%.gist: %.json Makefile; @< $< jq -r '"gh gist create -d \"\(.title)\" \(.file) | tee $@"'

~ := README.md
$~: jq := "- \(.date) [\(.title)](\(.file))"
$~: $~ := echo -e '\# notes\n\nTry to use zettelkasten via minimal MD and pandoc\n';
$~: $~ += jq -r '$(jq)'
$~: $(jsons); @cat $^ | ($($@)) > $@

main: README.md
