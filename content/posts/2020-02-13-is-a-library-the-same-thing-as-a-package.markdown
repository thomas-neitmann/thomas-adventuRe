---
title: Is a library the same thing as a package?
author: Thomas Neitmann
date: '2020-02-13'
slug: is-a-library-the-same-thing-as-a-package
categories: []
tags:
  - base
toc: no
images: ~
---

In `R` you use the `library()` function to load a package. Thus, surely a package and a library must be the same thing, right?

Actually no, they are not!

So, what's the difference between the two? A library is nothing but a folder on your computer in which installed packages are saved. Just like a real library that contains books. It is merely a container. A library on its own is useless. It's the content, the packages, that gives you the power to do almost anything in `R`.

If you are using `R` on Windows you'll likely have two libraries. One system wide library containing all packages that come with `R` and a user library that contains all packages you have installed on top of the defaults.

To see which libraries you are using use


```r
.libPaths()
```

```
## [1] "C:/Users/neitmant/R-Portable/App/R-Portable/library"
```

You can use the same function to tell `R` that a certain folder on your computer should be considered a library, e.g.

```r
.libPaths("./library")
```

Be aware, though, that this will overwrite your default libraries. To add an additional library on top of the existing ones you need to be explicit.

```r
old_libraries <- .libPaths()
.libPaths(c("./library", old_libraries))
```

With that being said you know why I invetiable have to smile if I see an article about the top five `R` libraries for xyz.
