top:; @date

id:; @date -u +'touch %FT%TZ.md' | tr : _

mds := $(wildcard *-*.md)
jsons := $(mds:%.md=%.json)
gists := $(mds:%.md=%.gist)

json: $(jsons)
gist: $(gists)

%.json: %.md Makefile; pandoc $< --template meta.json | jq '. + { file: "$<", id: "$(subst _,:,$<)" }' > $@
%.gist: %.json Makefile; @< $< jq -r '"gh gist create -d \"\(.title)\" \(.file) | tee $@"'
