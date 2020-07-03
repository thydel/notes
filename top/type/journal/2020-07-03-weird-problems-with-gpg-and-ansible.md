---
title: Weird problems with GPG and ansible
date: 2020-07-03
id: "§2020-07-03T17:10:29Z"
tags: [ duplicity, ansible, gpg, entropy ]
type: journal
---

# The story

- Solve `gpg` failure to generate key from an `ansible` playbook by
  installing [haveged - A simple entropy daemon][].
- Batch delete many different `gpg` key with same ID with a pair of
  `bash` functions.

# The journal

```console
$ lsb_release -ds; ansible --version | head -1; gpg --version | head -1
Debian GNU/Linux 9.12 (stretch)
ansible 2.9.10.post0
gpg (GnuPG) 2.1.18
```

In the context of a `ansible` playbook generating `gpg` keys for
`duplicity`.

Seems like key generation that worked for one node on another WS hang
when generating the key for a second node.

Extracting and playing the command outside of `ansible` (which won't
show anything in that *hangup* case) shows that there is a `gpg`
timeout (but not when invoked from inside `ansible` where we have a
`python` process busy-waiting) and that, maybe I'm running out of
entropy.

Which lead us to [haveged - A simple entropy daemon][]

```bash
aptitude install haveged
```

[haveged - A simple entropy daemon]:
    http://www.issihosts.com/haveged/
    "issihosts.com"

But, because we interrupted the hanged `ansible` several time we now
have multiple different key with same ID (which yet another GPG
annoying glitch)

[How to delete gpg secret keys by force, without fingerprint?]:
    https://superuser.com/questions/174583/how-to-delete-gpg-secret-keys-by-force-without-fingerprint
    "superuser.com"

From [How to delete gpg secret keys by force, without fingerprint?][]
I made the following pipe (mainly adding `--homedir` and `awk NR%2`
because (I guess) `--list-secret-keys` list keys and subkeys and
deleting a key also delete the subkey.

```bash
homedir=ext/gpg-store/duplicity/.gnupg/
key=duplicity@somenode

list () { gpg2 --homedir ${1:?} ${3:---list-keys} --with-colons --fingerprint ${2:?}; }
fingerprint () { grep ^fpr | cut -d: -f 10 | awk NR%2; }
delete () { xargs -i echo gpg2 --homedir ${1:?} --yes --batch ${2:---delete-keys} {}; }

list-private () { list "$@" --list-secret-keys; }
delete-private () { delete "$@" --delete-secret-keys; }

list-private $homedir $key | fingerprint | delete-private $homedir | dash
list $homedir $key | fingerprint | delete $homedir | dash
```

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
