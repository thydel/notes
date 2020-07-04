---
title: Use gitattributes for GPG and ccrypt files
date: 2020-07-04
id: "§2020-07-04T13:48:59Z"
tags: gpg, ccrypt, git
type: howto
---

Starting from [Versioning PDF files with git][]

For `gpg`

```bash
echo '*.gpg diff=gpg' >> .gitattributes
git config diff.gpg.textconv 'gpg2 -d --quiet --yes --compress-algo=none --batch --use-agent'
```

For `ccrypt` (my old personal setup) use `pass` to get the per directory password

```bash
floop () { (declare -f $1; c=$1; shift; echo "$@" | xargs -n1 | xargs -i echo $c {}) | bash; }
pinstall () { install /dev/fd/0 "$1"; }; export -f pinstall

ccat-u () { echo -e '#!/bin/bash\npass' cpt/${1:?} '| ccat -k - $1' | pinstall /usr/local/bin/ccat-"${1:?}"; }
attr-u () { (cd cpt-$1; grep -qs ccat-$1 .gitattributes || echo "*.cpt diff=ccat-$1" >> .gitattributes); }
conf-u () { git config diff.ccat-$1.textconv ccat-$1; }

all () { ccat-u $1; attr-u $1; conf-u $1; }
floop all thy tde
```

Then

```bash
git diff # Shows the change you made (and forgot to commit) some days ago
git tag empty $(git hash-object -t tree /dev/null)
git diff empty -- cpt-tde/crtypted.yml.cpt # alias ccat, but using auto contextual password from pass(1)
```

Now I must read

- [gitattributes - Defining attributes per path][]
- [Customizing Git - Git Attributes][]

[Versioning PDF files with git]:
    https://tante.cc/2009/03/24/versioning-pdf-files-with-git/
    "tante.cc"

[gitattributes - Defining attributes per path]:
    https://git-scm.com/docs/gitattributes
    "git-scm.com"

[Customizing Git - Git Attributes]:
    https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes
    "git-scm.com/book"

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
