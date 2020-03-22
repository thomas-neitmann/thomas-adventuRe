---
title: Loading vs. attaching a package
author: Thomas Neitmann
date: '2020-01-20'
slug: loading-vs-attaching-a-package
categories:
  - R
  - bytesized
tags:
  - base
  - package
toc: no
images: ~
---

`R` users often talk of loading a package when they use `library()`. But technical `library()` doesn't load the package but attaches it. So what's the difference?

If you've ever used the `::` operator, e.g. `dplyr::filter()`, you have loaded a package. Loading a package does exactly what the name suggests: it loads all functions and datasets of a particular package. However, to access these functions and datasets you will still need to use `::` every time you refer to something within the package.

When you use `library()` the package is attached to the search path. You can think of the search path as a queue of (literally) packages, each one filled with functions and datasets. Whenever you use a function without `::`, `R` looks for a function with that name in the first package. If it doesn't find it, `R` continues to look for it in the next package and so on until it finds the function.

Importantly, calling `library(pkg)` will place `pkg` at the beginning of the queue. That's why after calling `library(dplyr)`, `filter()` will be `dplyr::filter()` and not `stats::filter()` any longer.


```r
args(filter) # stats::filter
```

```
## function (x, filter, method = c("convolution", "recursive"), 
##     sides = 2L, circular = FALSE, init = NULL) 
## NULL
```

```r
library(dplyr)
args(filter) # dplyr::filter
```

```
## function (.data, ..., .preserve = FALSE) 
## NULL
```

This behavior can cause trouble, so if you know there's a function with the same name in multiple packages I'd advice you to be explicit and use `::` every time you use that function.
