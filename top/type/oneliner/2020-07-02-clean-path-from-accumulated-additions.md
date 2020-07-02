---
title: Clean PATH from accumulated additions
date: 2020-07-02
id: "§2020-07-02T18:59:19Z"
tags: [ bash, ansible ]
type: oneliner
---

When using ansible from a clone you do (e.g.)

```bash
source /usr/local/ext/ansible-stable-2.10/hacking/env-setup -q
```

But if you switch back and forth from one version to another (say
because you want to use the lastest version for new stuff, but you
still have old stuff not working yet the the lastest version) you will
see that your PATH keep adding new paths whithout ever removing the
old ones.

That's not a real problem ans you can always restart you shell, but...

```bash
clean_path() { echo $PATH | tr : '\n' | grep -v ${1:-ansible} | tr '\n' : | echo PATH=$(cat); }
. <(clean_path)
```

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
