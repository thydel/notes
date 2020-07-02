---
title: Work with multiple clones
date: 2020-06-19
id: "§2020-06-19T07:47:18Z"
dates: [ 2020-06-24 ]
tags: git
type: oneliner
links: [ "§2020-06-12T11:11:38Z" ]
---

[§2020-06-12T11:11:38Z]: /top/type/howto/2020-06-12-work-with-multiple-remotes.md "§2020-06-12T11:11:38Z Work with multiple remotes"

After pushing to multiple remotes I usually also want to update all
remote nodes using these repos to keep everything in sync.

Note that all nodes keeping a bare repo are not necessarily the same
as all nodes keeping a clone.

Also note that this assume all clones share the same path.

First I configure my peers, e.g. from hypothetical work location, the
two other places where I have a workstation.

```bash
git config local.peers ws.manin
git config --add local.peers ws.wato
```

Then I add the onliner as a git alias

```bash
git config alias.sync '!git config --get-all local.peers | xargs -i echo ssh -An {} git -C $(pwd) pull'
```

Now `git sync | dash` will sync all remote clones, and assuming the
conf to [§ Work with multiple remotes][§2020-06-12T11:11:38Z] is OK `git
push; git sync | dash` will keep in sync all remote bares and clones.

But [git-extras][] has a `git-sync` command and Git aliases cannot shadow existing Git command.

Uses `msync` instead of `sync`

```bash
git config alias.msync '!git config --get-all local.peers | xargs -i echo ssh -An {} git -C $(pwd) pull'
```

[git-extras]: https://github.com/tj/git-extras "github.com"

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
