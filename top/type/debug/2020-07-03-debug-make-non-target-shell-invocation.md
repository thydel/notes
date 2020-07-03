---
title: Debug Make non target SHELL invocation
date: 2020-07-03
id: "§2020-07-03T12:53:19Z"
tags: [ make, bash ]
type: debug
---

Let's assume your `SHELL` is `bash`.

> `make -Bn`

Will show all recipes execution (`make --always-make --dry-run`), but
you won't see or catch problems with `$(shell)` invocation (which may
trigger pretty complex `make` variables initialization).

> `make SHELL='bash -v'`

Will show *raw source code line* of non target `$(shell)` invocations
(e.g. `date != date +%F`).

Note that non target `$(shell)` invocations are **not** affected by
`--dry-run`.

This pratical invocation will allow the extraction of `make` lines
with *`make` variables substitution already done* and thus the
debugging of a `$(shell)` invocation *outside* of the `Makfile`
context.

> `make -Bn SHELL='bash -v'`

Will obviously combine the effect of the two precedent invocations,
but you won't be able to easily distinguish which line is from which.

> `make -Bn SHELL='bash -x'`

Will prepend each non target `$(shell)` invocation by a `+`, but it
will be *expanded simple command* instead of *raw source code line*
which may be less readable (and could be different from source line),
like in, e.g.

```console
$ f () { echo "'\""; }
$ f
'"
$ (declare -f f; echo f) | bash
'"
$ (declare -f f; echo f) | bash -v
f ()
{
    echo "'\""
}
f
'"
$ (declare -f f; echo f) | bash -x
+ f
+ echo ''\''"'
'"
$ (declare -f f; echo f) | bash -vx
f ()
{
    echo "'\""
}
f
+ f
+ echo ''\''"'
'"
```

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
