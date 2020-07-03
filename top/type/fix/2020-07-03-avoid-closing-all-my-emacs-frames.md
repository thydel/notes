---
title: Avoid closing all my emacs frames
date: 2020-07-03
id: "§2020-07-03T11:23:15Z"
tags: emacs
type: fix
---

[how to make emacs prompt me before closing the last emacs gui frame when running emacs as a daemon?]:
    https://emacs.stackexchange.com/questions/30454/how-to-make-emacs-prompt-me-before-closing-the-last-emacs-gui-frame-when-running
    "emacs.stackexchange.com"

I can't help to hit `C-x C-c` while working in emacs (well, it's not
like if the two keys were adjacent 8).

It's not such a big problem because I usually works with
`emacsclient`, but it's annoying to loose your handful of frame when
in a middle of something

I quickly found this answer to

[how to make emacs prompt me before closing the last emacs gui frame when running emacs as a daemon?][]

I twisted it a bit by calling `delete-frame` instead of
`save-buffers-kill-emacs` and adding `unwind-protect`

``` lisp
(defun ask-before-closing ()
  "Close only if y was pressed."
  (interactive)
  (unwind-protect
      (if (y-or-n-p (format "Are you sure you want to close this frame? "))
          (delete-frame)
        (message "Canceled frame close"))
    (message "Other frame closed")))
(when (daemonp) (global-set-key (kbd "C-x C-c") 'ask-before-closing))
```

Not that I master any of these things, but this stuff seems to solve
my problem.

[Local Variables:]::
[indent-tabs-mode: nil]::
[End:]::
