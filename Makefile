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

eq.l = $(and $(findstring $(strip $1),$(strip $2)),$(findstring $(strip $2),$(strip $1)))
cdr.l = $(filter-out $(firstword $1), $1)
map.l = $(eval λ = $(subst €,$$,$1))$(foreach _,$2,$(call λ,$_))

define varbysuff.l
$(strip
  $(foreach _, $(.VARIABLES),
    $(if
      $(and
        $(call eq.l, $(origin $_), file),
        $(call eq.l, $(suffix $_), .$(strip $1))),
      $_)))
endef

wip.l = $(if $(WIP),Makefile)

id.d := id
lib.d := lib

define ~
---
title:
date: $(day)
id: "§$(id)"
tags:
type:
endef
id: date != date -u +'%F %FT%TZ'
id: day  := $(firstword $(date))
id: id   := $(lastword $(date))
id: head := $~
id: file := $(id.d)/$(subst :,_,$(id)).md
id: phony; $(warning $(date) $(day)) echo -e '$(head)\n---' > $(file)

tmp.t := tmp
json.t := json
title.t := title

tmpdir.s := $(call map.l, €(€1), $(call varbysuff.l, t))
tmp: phony $(patsubst %, %/.stone, $(tmpdir.s))

md.s := $(sort $(wildcard $(id.d)/*-*.md))
json.s := $(md.s:$(id.d)/%.md=$(json.t)/%.json)

$(lib.d)/meta.json: $(lib.d)/.stone; echo '$$meta-json$$' > $@

~ := $(json.t)/%.json
$~: md = $<
$~: json = $@
$~: file = $(notdir $<)
$~: base = $(basename $(file))
$~: id = $(subst _,:,$(base))
$~: jq = . + { file: "$(file)", id: "$(id)" }
$~: cmd = pandoc $(md) --template $(lib.d)/meta.json | jq '$(jq)' > $(json)
$~: $(id.d)/%.md $(json.t)/.stone $(lib.d)/meta.json $(wip.l); $(cmd)

json.f := $(tmp.t)/all.json
$(json.f): $(tmp.t)/.stone $(json.s); cat $(call cdr.l, $^) > $@
json: phony $(json.f)

~ := README.md
$~: jq := "- \(.date) [\(.title)]($(id.d)/\(.file))"
$~: $~ := echo -e '\# notes\n\nTry to use zettelkasten via minimal MD and pandoc\n';
$~: $~ += jq -r '$(jq)' $(json.f)
$~: $(json.f) $(wip.l); ($($@)) > $@

~ := $(tmp.t)/title.sh
$~: hard := ln -f \(.file)
$~: soft := ln -sf ../\(.file)
$~: jq := "$(soft) \'$(title.t)/\(.date) \(.title).md\'"
$~: $~ := jq -r $$'$(jq)' $(json.f)
$~: $(json.f) $(wip.l); $($@) > $@
title: $~ $(tmp.t)/.stone $(title.t)/.stone phony; dash $<

χ := \\"#"
quote.l = $(subst «,$(χ),$(subst »,$(χ),$1))

~ := $(tmp.t)/link.md
$~: jq := $(call quote.l,"[§\(.id)]: \(.file) «§\(.title)»")
$~: $~ := jq -r $$'$(jq)' $(json.f)
$~: $(json.f) $(wip.l); $($@) > $@
link: $~ $(tmp.t)/.stone phony

main: phony README.md
all: phony main title link

define .gitignore
$(call map.l, echo €1/;, $(tmpdir.s))
echo .stone
endef

.gitignore: phony; ($($@)) > $@
gitignore: .gitignore

%/.stone:; mkdir -p $(@D); touch $@
.PRECIOUS: %/.stone

.stone:; touch $@
stone: phony; touch .$@

# Local Variables:
# indent-tabs-mode: nil
# End:
