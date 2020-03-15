---
title: 'When things go wrong: how to amend a git commit?'
author: Thomas Neitmann
date: '2020-01-04'
slug: when-things-go-wrong-how-to-amend-a-git-commit
categories:
  - bytesized
tags:
  - git
toc: no
images: ~
---

While working on a data science project did you ever `git commit` a bunch of `.R` files only to realize a few seconds later that you forget to include something? I certainly did. Today alone 3 times.

What can you do? The obvious solution is to make a second commit. But that's a bad one. Instead do the following:

```bash
git add <forgotten.file>
git commit --amend --no-edit
```

Replace `<forgotten.file>` with the actual file name, e.g. `analysis.R`. This will add the file to your previous commit while keeping the commit message. If you want to change the commit message remove the `--no-edit` argument. When you do so a text editor will pop up where you can change the commit message.

Another scenario: you committed all files but forgot to make a change in one file. In that case simply edit the respective file and run the exact same two commands as above. Make sure to replace `<forgotten.file>` with the name of the file you just edited.

Finally to push the commit to GitHub run

```bash
git push -f origin <your branch>
```

where `<your branch>` is the branch you are currently working in, e.g. `master`.

A note to RStudio users: you need to run the `git` commands from the terminal instead of using the `git` GUI.
