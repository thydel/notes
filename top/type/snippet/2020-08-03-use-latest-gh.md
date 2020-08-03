---
title: Use latest gh
date: 2020-08-03
id: "§2020-08-03T12:59:22Z"
tags: [ github, cli ]
type: snippet
---

```bash
base=https://github.com/cli/cli/releases
version=$(curl -sI $base/latest | grep ^location: | cut -d: -f3 | xargs basename | tr -d v)
wget $base/download/v${version}/gh_${version}_linux_amd64.deb
sudo gdebi gh_${version}_linux_amd64.deb
```

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
