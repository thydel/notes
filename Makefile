top:; @date

SHELL != which bash

id:; @date -u +'touch %FT%TZ.md' | tr : _

mds := $(sort $(wildcard *-*.md))
jsons := $(mds:%.md=%.json)
gists := $(mds:%.md=%.gist)

json: $(jsons)
gist: $(gists)

%.json: %.md Makefile; pandoc $< --template meta.json | jq '. + { file: "$<", id: "$(subst _,:,$<)" }' > $@
%.gist: %.json Makefile; @< $< jq -r '"gh gist create -d \"\(.title)\" \(.file) | tee $@"'

~ := README.md
$~: jq := "- \(.date) [\(.title)](\(.file))"
$~: $~ := echo -e '\# notes\n\nTry to use zettelkasten via minimal MD and pandoc\n';
$~: $~ += jq -r '$(jq)'
$~: $(jsons); @cat $^ | ($($@)) > $@

main: README.md
