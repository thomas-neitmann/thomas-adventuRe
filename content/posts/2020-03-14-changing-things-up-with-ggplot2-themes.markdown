---
title: Changing things up with ggplot2 themes
author: Thomas Neitmann
date: '2020-02-21'
slug: changing-things-up-with-ggplot2-themes
categories:
  - R
  - bytesized
tags:
  - ggplot2
toc: no
images: ~
---

Are you tired of adding your favorite `ggplot2` theme to every data visualization you create in `R`? Then I have a solution for you!

Before you start to create any plots call the `theme_set()` function with your favorite theme as first argument, e.g.


```r
library(ggplot2)
theme_set(theme_minimal())
```

That will ensure all plots you subsequently create will use this theme unless you add a different one.


```r
data("mtcars")
ggplot(mtcars, aes(hp, mpg, color = wt)) +
  geom_point()
```

<img src="/posts/2020-03-14-changing-things-up-with-ggplot2-themes_files/figure-html/unnamed-chunk-2-1.png" width="672" />


Very handy for lazy people like me.
