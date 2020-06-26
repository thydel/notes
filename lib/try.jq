#!/usr/local/bin/jq -f

def str: { t: "Str", c: . };
def space: { t: "Space", c: [] };
def text: split(" ") | map(str, space) | .[:-1];
def para: [ { t: "Para", c: text } ];
def section_id: split(" ") | map(ascii_downcase) | join("-");
def header($l; $t): [ { t: "Header", c: [ $l, [ ($t | section_id), [], []], ($t | text) ] } ];

.[0].unMeta.id.c[0].c as $id | [.[0]] + [.[1] + header(1; "Get id from meta") + ($id | para)]
