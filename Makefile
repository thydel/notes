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

€ = $(subst €,$$,$1)

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

define ~head
---
title:
date: $(day)
id: "§$(id)"
tags:
type:
endef
define ~tail
[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
endef
id: date != date -u +'%F %FT%TZ'
id: day  := $(firstword $(date))
id: id   := $(lastword $(date))
id: head := $(~head)
id: tail := $(~tail)
id: file := $(id.d)/$(subst :,_,$(id)).md
id: phony; @echo -e '$(head)\n---\n\n$(tail)' > $(file)

~ := fixtail
$~: list := grep -L indent-tabs-mode id/*.md
$~: tail := $(~tail)
$~: add  := (echo; echo "$(tail)") | cat >> {}
$~: $~   := $(list) | xargs -i echo '$(add)'
$~: phony; @$($@)

tmp.t := tmp

# € is quoted $
# greek κ is quoted '
# « and » are quoted "
# greek ν is quoted NL
~ := fixhead
$~: list := grep -L ^id: id/*.md | tee $(tmp.t)/$~ | xargs basename -s .md
$~: list += | tr _ : | sed -e s/^/§/ | paste $(tmp.t)/$~ -
$~: ed   := /^date:/aνid: «%s»ν.νwq
$~: awk  := { printf "echo -e κ$(ed)κ | ed %s\n", €2, €1 }
$~: sed  := sed -e "s/κ/'/g" -e 's/[«»]/"/g' -e 's/ν/\\n/g'
$~: $~   := $(list) | awk '$(call €,$(awk))' | $(sed)
$~: phony; @$($@)

json.t := json
title.t := title

tmpdir.s := $(call map.l, €(€1), $(call varbysuff.l, t))
tmp: phony $(patsubst %, %/.stone, $(tmpdir.s))

md.s := $(sort $(wildcard $(id.d)/*-*.md))
json.s := $(md.s:$(id.d)/%.md=$(json.t)/%.json)
json-links.s := $(md.s:$(id.d)/%.md=$(json.t)/%-links.json)

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
$(json.f): sort := jq -s 'sort_by(.date)|reverse|.[]'
$(json.f): $(tmp.t)/.stone $(json.s); cat $(call cdr.l, $^) | $(sort) > $@
json: phony $(json.f)

~ := $(json.t)/%-links.json
$~: md = $<
$~: json = $@
$~: file = $(notdir $<)
$~: base = $(basename $(file))
$~: id = $(subst _,:,$(base))
$~: jq.link = { url: .[0], label: .[1] }
$~: jq.links = [.[1] | .. | select(type == "object" and .t == "Link") | .c[2]] | map($(jq.link))
$~: jq  = { id: "$(id)", links: $(jq.links) }
$~: cmd = pandoc -s -t json $(md) | jq '$(jq)' > $(json)
$~: $(id.d)/%.md $(json.t)/.stone$(wip.l); $(cmd)

json-links.f := $(tmp.t)/links.json
$(json-links.f): $(tmp.t)/.stone $(json-links.s); cat $(call cdr.l, $^) > $@
json-links: phony $(json-links.f)

~ := README.md
$~: jq := "- \(.date) [\(.title)]($(id.d)/\(.file))"
$~: $~ := echo -e '\# notes\n\nTry to use zettelkasten via minimal MD and pandoc\n';
$~: $~ += jq -r '$(jq)' $(json.f)
$~: $(json.f) $(wip.l); ($($@)) > $@

~ := $(tmp.t)/title.sh
$~: hard := ln -f \(.file)
$~: soft := ln -sf ../$(id.d)/\(.file)
$~: jq := "$(soft) \'$(title.t)/\(.date) \(.title).md\'"
$~: $~ := jq -r $$'$(jq)' $(json.f)
$~: $(json.f) $(wip.l); $($@) > $@
title: $~ $(tmp.t)/.stone $(title.t)/.stone phony; dash $<

χ := \\"#"
quote.l = $(subst «,$(χ),$(subst »,$(χ),$1))

σ :=  # Non breaking space

~ := $(tmp.t)/link.md
$~: jq := map($(call quote.l,"[§\(.id)]: \(.file) «§$(σ)\(.title)»"))
$~: jq += + [""] +
$~: jq += map("[§$(σ)\(.title)][§\(.id)]")
$~: jq += | .[]
$~: $~ := jq -sr $$'$(jq)' $(json.f)
$~: $(json.f) $(wip.l); $($@) > $@
link: $~ $(tmp.t)/.stone phony

main: phony README.md
all: phony main title link

try: phony; pandoc $(lastword $(md.s)) -t markdown_github --filter lib/try.sh

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
