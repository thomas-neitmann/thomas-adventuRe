---
title: The right way to check for NAs
author: Thomas Neitmann
date: '2020-02-03'
slug: the-right-way-to-check-for-nas
categories:
  - bytesized
tags:
  - base
toc: no
images: ~
---

To check for missing values in `R` you might be tempted to use the equality operator `==` with your vector on one side and `NA` on the other. Don't!

If you insist, you'll get a useless results.


```r
x <- c(1, NA, 3)
x == NA
```

```
## [1] NA NA NA
```


Instead use the `is.na()` function.


```r
is.na(x)
```

```
## [1] FALSE  TRUE FALSE
```

