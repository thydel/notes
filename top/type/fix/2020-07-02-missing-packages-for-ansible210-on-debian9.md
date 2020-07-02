---
title: Missing packages for ansible-2.10 on debian9
date: 2020-07-02
id: "§2020-07-02T11:55:26Z"
tags: ansible, debian9
type: fix
---

Ansible 2.10 is here

```bash
(cd /usr/local/ext && test -d ansible-stable-2.10 || git clone --branch stable-2.10 --recursive git://github.com/ansible/ansible.git ansible-stable-2.10)
```

Then as usual

```console
$ use-ansible
(cd /usr/local/ext/ansible-stable-2.10 && git fetch && (git diff --quiet @{upstream} || git pull --rebase && git submodule update --init --recursive))
source /usr/local/ext/ansible-stable-2.10/hacking/env-setup -q
$ source <(use-ansible)
```

But

```console
$ ansible --version | grep ERROR
ERROR! Unexpected Exception, this is probably a bug: The 'packaging' distribution was not found and is required by ansible-base
```

Try

```bash
sudo aptitude install python-{packaging,straight.plugin}
```

OK

```console
$ ansible --version | head -1
ansible 2.10.0b1.post0
```

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
