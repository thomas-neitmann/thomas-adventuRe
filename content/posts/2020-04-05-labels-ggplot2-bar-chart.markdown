---
title: Adding labels to a ggplot2 bar chart
author: Thomas Neitmann
date: '2020-04-06'
slug: labels-ggplot2-bar-chart
categories:
  - R
  - bytesized
tags:
  - datavisualization
  - ggplot2
  - ggcharts
toc: no
images: ~
---




I often see bar charts where the bars are directly labeled with the value they represent. In this post I will walk you through how you can create such labeled bar charts using `ggplot2`.

First, let's load some data to work with and create a bar chart. To make this easier I will use the `bar_chart()` function from my [`ggcharts`](https://thomas-neitmann.github.io/ggcharts/index.html) package which outputs a `ggplot` that can be customized further using any `ggplot2` function.


```r
library(dplyr)
library(ggplot2)
library(ggcharts)
data(biomedicalrevenue)

chart <- biomedicalrevenue %>%
  filter(year == 2018) %>%
  bar_chart(company, revenue, limit = 10) %>%
  print()
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/unnamed-chunk-1-1.png" width="672" />

To add an annotation to the bars you'll have to use either `geom_text()` or `geom_label()`. I will start off with the former. Both require the `label` aesthetic which tells `ggplot2` which text to actually display. In addition, both functions require the `x` and `y` aesthetics but these are already set when using `bar_chart()` so I won't bother setting them explicitly after this first example.


```r
chart +
  geom_text(aes(x = company, y = revenue, label = revenue))
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/unnamed-chunk-2-1.png" width="672" />

By default the labels are center-aligned directly at the `y` value. You will never want to leave it like that because it's quite hard to read. To left-align the labels set the `hjust` parameter to `0` or `"left"`.


```r
chart +
  geom_text(aes(label = revenue, hjust = "left"))
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/unnamed-chunk-3-1.png" width="672" />

That's still not ideal I would say. Let's move the labels a bit further away from the bars by setting `hjust` to a negative number and increase the axis limits to improve the legibility of the label of the top most bar.


```r
chart +
  geom_text(aes(label = revenue, hjust = -0.2)) +
  ylim(NA, 100)
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/unnamed-chunk-4-1.png" width="672" />

Alternatively, you may want to have the labels inside the bars.


```r
chart +
  geom_text(aes(label = revenue, hjust = 1))
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Again, a bit close to the end of the bars. By increasing the `hjust` value the labels can be moved further to the left. In addition, black on blue is quite hard to read so let's change the text color to white. Notice that this happens outside of `aes()`.


```r
chart +
  geom_text(aes(label = revenue, hjust = 1.2), color = "white")
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/unnamed-chunk-6-1.png" width="672" />

Next, let's try `geom_label()` for once to see how it's different from `geom_text()`.


```r
chart +
  geom_label(aes(label = revenue, hjust = 1.2))
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/unnamed-chunk-7-1.png" width="672" />

I am not a fan of this look and will stick to `geom_text()` for the final plot.

The data in the plot represents annual revenues in billion US dollars. Let's change the labels accordingly and beautify the plot.


```r
biomedicalrevenue %>%
  filter(year == 2018) %>%
  mutate(label = sprintf("$%1.2f B.", revenue)) %>%
  bar_chart(company, revenue, limit = 10) +
  geom_text(aes(label = label, hjust = -0.1)) +
  scale_y_continuous(
    name = "Revenue (Billion USD)",
    limits = c(0, 100),
    expand = expansion()
  ) +
  labs(
    x = NULL,
    title = "Top 10 Biomedical Companies by 2018 Revenue"
  ) +
  theme(
    axis.text.x = element_blank(),
    panel.grid.major.x = element_blank()
  )
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/unnamed-chunk-8-1.png" width="672" />

Notice that I removed the axis labels and grid lines. In my opinion you should **_never_** have an axis and labels in the same plot.

To finish off this post, let's have a quick look at how to label a vertical bar chart. It's basically the same process but instead of using `hjust` you will need to use `vjust` to adjust the label position.


```r
biomedicalrevenue %>%
  filter(company == "Novartis") %>%
  mutate(label = sprintf("$%1.2f B.", revenue)) %>%
  column_chart(year, revenue) +
  geom_text(aes(label = label, vjust = -1)) +
  theme(
    axis.text.y = element_blank(),
    panel.grid.major.y = element_blank()
  ) +
  scale_x_continuous(
    name = "Fiscal Year",
    breaks = 2011:2018
  ) +
  scale_y_continuous(
    name = "Revenue (Billion USD)",
    limits = c(0, 70),
    expand = expansion()
  )
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/unnamed-chunk-9-1.png" width="672" />
