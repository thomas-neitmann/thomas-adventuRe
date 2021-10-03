---
title: ggplot2坐标轴的百分比转换
author: Thomas Neitmann
date: '2020-04-05'
slug: ggplot2-percentage-scale
categories:
  - R
tags:
  - ggcharts
  - ggplot2
  - datavisualization
toc: no
images: ~
---




当绘制的变量是以百分比为单位时，最好的办法就是为坐标轴标签添加百分号(%). 这样可以在处理百分比的数据时使得数据的可视化更加清晰明了。

下面我们使用一个示例数据集来说明这一点。


```r
library(dplyr)
data(mtcars)

cyl <- mtcars %>%
  count(cyl) %>%
  mutate(pct = n / sum(n) * 100) %>%
  print()
```

```
##   cyl  n    pct
## 1   4 11 34.375
## 2   6  7 21.875
## 3   8 14 43.750
```

我将使用我编写的[`ggcharts`](https://thomas-neitmann.github.io/ggcharts/index.html)这一包来创建以上数据的条形图。[`ggcharts`](https://thomas-neitmann.github.io/ggcharts/index.html)同时也提供了一个高级接口，可以用来使用`ggplot2`绘制图形。


```r
library(ggcharts)
(p <- bar_chart(cyl, cyl, pct))
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.zh_files/figure-html/unnamed-chunk-2-1.png" width="672" />

接下来，让我们使用`scales`中的`percent()`函数将坐标轴标签更改为百分号形式的。


```r
p + scale_y_continuous(labels = scales::percent)
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.zh_files/figure-html/unnamed-chunk-3-1.png" width="672" />

结果似乎有些出人意料！ 4000% 远远超过了我们需要的值。其中的问题关键是在默认情况之下，`scales::percent()`将数据中的值都乘以了100。这个可以通过`scale`参数来控制。



```r
scales::percent(100, scale = 1)
```

```
## [1] "100%"
```

然而，`scale_y_continuous()`中的`labels`参数期望的是一个函数而非一个实际的标签值作为其输入，引起使用`percent()`不是一个好的选项。不过好在`scales`包也提供了另一个`percent_format()`函数，它可以返回一个已经更改过默认值的`percent()`函数。


```r
pct1 <- scales::percent_format(scale = 1)
pct1(100)
```

```
## [1] "100%"
```

将以上得到的函数传递给`labels`参数，于是可以得到我们想要的结果。


```r
p + scale_y_continuous(labels = scales::percent_format(scale = 1))
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.zh_files/figure-html/unnamed-chunk-6-1.png" width="672" />

另外，除了百分比外还可以只计算百分数。


```r
cyl2 <- mtcars %>%
  count(cyl) %>%
  mutate(pct = n / sum(n))

bar_chart(cyl2, cyl, pct) +
  scale_y_continuous(labels = scales::percent)
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.zh_files/figure-html/unnamed-chunk-7-1.png" width="672" />


但是值得注意的是结果中的小数位都是保留了一位小数，而我认为坐标轴的标签在小数位应该保持一致。

`percent_format()`函数中有一个参数`accuracy`是可以控制这一点的。


```r
bar_chart(cyl2, cyl, pct) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.zh_files/figure-html/unnamed-chunk-8-1.png" width="672" />

在我看来，以上的这些还是令人困惑（至少可以这样说）。因此，我认为有更好的解决方案，就是在数据中就计算出“比例”和“精度”。


我的解决方案是使用我编写的[`scalesextra`](https://github.com/thomas-neitmann/scalesextra)包中的`scale_y_pct()`函数。


```r
library(scalesextra)
bar_chart(cyl, cyl, pct) + scale_y_pct()
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.zh_files/figure-html/unnamed-chunk-9-1.png" width="672" />

```r
bar_chart(cyl2, cyl, pct) + scale_y_pct()
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.zh_files/figure-html/unnamed-chunk-9-2.png" width="672" />


可以看到，不管数据是1的百分数还是百分比，都能正确地绘制。 此外，这两种情况都没有带小数位，与原始数据中的整数保持一致。

你还可以将`scale_y_continuous()`中的参数传递给`scale_y_pct()`，比如`breaks`。


```r
bar_chart(cyl, cyl, pct) + scale_y_pct(breaks = c(12.5, 30.75))
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.zh_files/figure-html/unnamed-chunk-10-1.png" width="672" />


请注意，坐标轴中显示的小数位数对于所有标签都保持一致。小数位数将从数据值中的最高小数位数确定。而使用`percent_format（）`则无法实现这一功能。


```r
bar_chart(cyl, cyl, pct) +
  scale_y_continuous(
    labels = scales::percent_format(scale = 1),
    breaks = c(12.5, 30.75)
  )
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.zh_files/figure-html/unnamed-chunk-11-1.png" width="672" />


`scalesextra`包尚处于早期开发阶段，因此只能从GitHub获得。 您可以通过在R控制台中运行以下这些命令来安装它。

```r
if (!"remotes" %in% installed.packages()) {
  install.packages("remotes")
}
remotes::install_github("thomas-neitmann/scalesextra")
```

你可以测试`scale_y_pct()` (以及`scale_x_pct()`)，如果有任何想法欢迎在评论中提出。此外，如果您发现任何错误（在早期开发的阶段），请在[GitHub](https://github.com/thomas-neitmann/scalesextra/issues)上发布。谢谢您的阅览！

*<small>本篇博客由[Ivan Z](https://twitter.com/IvanZ_1900)翻译成中文，如您发现任何翻译上的错误请随时指正。非常感谢！</small>*
