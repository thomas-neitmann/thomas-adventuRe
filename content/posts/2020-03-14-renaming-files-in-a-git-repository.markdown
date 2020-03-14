---
title: Renaming files in a git repository
author: Thomas Neitmann
date: '2020-02-16'
slug: renaming-files-in-a-git-repository
categories:
  - bytesized
tags:
  - git
toc: no
images: ~
---

If you are using `git` for your data science project (which you should!), you have to be careful when renaming a file.

If you simply rename the file in your OS file browser, `git` would interpret this as deleting the file with the old name and creating a new one with the new name. They wouldn't be linked in any way and you'd essentially loose the history of that file.

So, how can you rename a file and keep its history? You need to use the `git mv` command and subsequently make a commit. Here's an example:

```bash
git mv old_name.ext new_name.ext
git commit -m 'Rename old_name.ext to new_name.txt'
```

That's it! Don't be afraid to rename a file when using `git`. Just use the right command.
