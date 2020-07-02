---
title: Generate all the binary number from 0 to 2^n
date: 2020-06-24
id: "§2020-06-24T19:38:38Z"
tags: [ bash, fun ]
type: oneliner
links: [ "§2020-06-23T13:50:48Z" ]
---

```console
$ f () { seq $1 | xargs -i echo -n '{0,1}' | eval echo $(cat) | xargs -n1; }
$ f 5
00000
00001
00010
00011
00100
00101
00110
00111
01000
01001
01010
01011
01100
01101
01110
01111
10000
10001
10010
10011
10100
10101
10110
10111
11000
11001
11010
11011
11100
11101
11110
11111
```

And using [grex][] (See [§ Use grex][§2020-06-23T13:50:48Z]) convert back to regexp

```console
$ stdin='--file /dev/fd/0'
$ f 8 | grex -g $stdin | tee /dev/fd/2 | tr -d '^$' | grex -gr $stdin | tr -d '()\\'
^[01][01][01][01][01][01][01][01]$
^[01]{8}$
```

[grex]: https://github.com/pemistahl/grex "github.com"
[§2020-06-23T13:50:48Z]: /top/type/tool/2020-06-23-use-grex.md "§2020-06-23T13:50:48Z Use grex"

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
