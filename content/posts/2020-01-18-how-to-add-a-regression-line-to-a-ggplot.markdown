---
title: How to add a regression line to a ggplot?
author: Thomas Neitmann
date: '2020-01-18'
slug: how-to-add-a-regression-line-to-a-ggplot
categories:
  - R
  - bytesized
tags:
  - ggplot2
  - datavisualization
toc: no
images: ~
---


```r
library(ggplot2)
data(mtcars)
```


### Step 1


```r
p <- ggplot(mtcars, aes(hp, wt)) +
  geom_point()
p
```

<img src="/posts/2020-01-18-how-to-add-a-regression-line-to-a-ggplot_files/figure-html/unnamed-chunk-2-1.png" width="672" />

### Step 2


```r
p + geom_smooth()
```

<img src="/posts/2020-01-18-how-to-add-a-regression-line-to-a-ggplot_files/figure-html/unnamed-chunk-3-1.png" width="672" />

### Step 3


```r
p + geom_smooth(method = "lm")
```

<img src="/posts/2020-01-18-how-to-add-a-regression-line-to-a-ggplot_files/figure-html/unnamed-chunk-4-1.png" width="672" />

### Putting it all together


```r
ggplot(mtcars, aes(hp, wt)) +
  geom_point() +
  geom_smooth(method = "lm")
```

<img src="/posts/2020-01-18-how-to-add-a-regression-line-to-a-ggplot_files/figure-html/unnamed-chunk-5-1.png" width="672" />

