---
title: Purge MySQLbinary logs
date: 2020-06-19
id: "§2020-06-19T13:50:19Z"
tags: mysql
type: oneliner
---

Sometimes disks fill up pretty fast

```bash
date +'%F %T' -d '2 hours ago' | xargs -i echo PURGE BINARY LOGS BEFORE "'{}'" | ssh $mysql mysql
```

See [PURGE BINARY LOGS Statement][]

[PURGE BINARY LOGS Statement]:
	https://dev.mysql.com/doc/refman/5.6/en/purge-binary-logs.html "https://dev.mysql.com/"

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
