---
title: Enhance your ggplot2 data visualizations with ggtext
author: Thomas Neitmann
date: '2020-02-11'
slug: enhacing-ggplot2-with-ggtext
categories:
  - bytesized
tags:
  - ggplot2
  - datavisualization
toc: no
images: ~
---

I am super exciting to share with you my recent "discovery" of the `ggtext` `R` package.

I had looked for a solution to color individual words in the title of a `ggplot2` data visualization and `ggtext` provided me with a great solution for doing just that (and more).

So, how does it work? Have a look at this example:


```r
library(ggplot2)
library(dplyr)
library(gapminder)
data(gapminder)

gapminder %>%
  filter(continent %in% c("Africa", "Europe")) %>%
  group_by(continent, year) %>%
  summarise(population = sum(pop / 1e9)) %>%
  ggplot(aes(year, population, color = continent)) +
  geom_line(size = 1.2) +
  ggtitle(
    paste0(
      "<span style = 'color:#FF7F0E'>**Africa**</span>",
      " outgrew <span style = 'color:#1F77B4'>**Europe**</span>",
      " *dramtically* in the 20th Century"
    )
  ) +
  scale_color_manual(values = c("Europe" = "#1F77B4", "Africa" = "#FF7F0E")) +
  theme(
    plot.title = ggtext::element_markdown(),
    legend.position = "none"
  )
```

<img src="/posts/2020-03-14-enhacing-ggplot2-with-ggtext_files/figure-html/unnamed-chunk-1-1.png" width="672" />


Inside `theme()` I am assigning `ggtext::element_markdown()` to `plot.title`. This has the effect that the plot title I created using `ggtitle()` is interpreted as markdown/HTML. That made it possible to have the title of the plot act as a legend by coloring the appropriate keywords.

Quite a neat solution, isn't it?

While you need to revert to HTML for coloring the text you can use markdown for making individual words bold (e.g. `**Europe**`), italics (e.g. `*dramatically*`) and so forth. I love the flexibility this offers.

The `ggtext` package is not yet available on CRAN but you can install it from GitHub using

```r
remotes::install_github("wilkelab/ggtext")
```
