---
title: Adding Labels to a {ggplot2} Bar Chart
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

<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- B -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1597114514381206"
     data-ad-slot="6037303850"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>




I often see bar charts where the bars are directly labeled with the value they represent. In this post I will walk you through how you can create such labeled bar charts using `ggplot2`.

The data I will use comes from the [2019 Stackoverflow Developer Survey](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-and-wanted). To make creating the plot easier I will use the `bar_chart()` function from my [`ggcharts`](https://thomas-neitmann.github.io/ggcharts/index.html) package which outputs a `ggplot` that can be customized further using any `ggplot2` function.


```r
library(dplyr)
library(ggplot2)
library(ggcharts)

dreaded_lang <- tibble::tribble(
  ~language, ~pct,
  "VBA", 75.2,
  "Objective-C", 68.7,
  "Assembly", 64.4,
  "C", 57.5,
  "PHP", 54.2,
  "Erlang", 52.6,
  "Ruby", 49.7,
  "R", 48.3,
  "C++", 48.0,
  "Java", 46.6
)

chart <- dreaded_lang %>%
  bar_chart(language, pct) %>%
  print()
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/ggplot2_bar_chart-1.png" width="672" />

To add an annotation to the bars you'll have to use either `geom_text()` or `geom_label()`. I will start off with the former. Both require the `label` aesthetic which tells `ggplot2` which text to actually display. In addition, both functions require the `x` and `y` aesthetics but these are already set when using `bar_chart()` so I won't bother setting them explicitly after this first example.


```r
chart +
  geom_text(aes(x = language, y = pct, label = pct))
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/ggplot2_bar_chart_label_center-1.png" width="672" />

By default the labels are center-aligned directly at the `y` value. You will never want to leave it like that because it's quite hard to read. To left-align the labels set the `hjust` parameter to `0` or `"left"`.


```r
chart +
  geom_text(aes(label = pct, hjust = "left"))
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/ggplot2_bar_chart_label_outside-1.png" width="672" />

That's still not ideal I would say. Let's move the labels a bit further away from the bars by setting `hjust` to a negative number and increase the axis limits to improve the legibility of the label of the top most bar.


```r
chart +
  geom_text(aes(label = pct, hjust = -0.2)) +
  ylim(NA, 100)
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/ggplot2_bar_chart_label_outside2-1.png" width="672" />

Alternatively, you may want to have the labels inside the bars.


```r
chart +
  geom_text(aes(label = pct, hjust = 1))
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/ggplot2_bar_chart_label_inside-1.png" width="672" />

Again, a bit close to the end of the bars. By increasing the `hjust` value the labels can be moved further to the left. In addition, black on blue is quite hard to read so let's change the text color to white. Notice that this happens outside of `aes()`.


```r
chart +
  geom_text(aes(label = pct, hjust = 1.2), color = "white")
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/ggplot2_bar_chart_label_inside_colored-1.png" width="672" />

Next, let's try `geom_label()` for once to see how it's different from `geom_text()`.


```r
chart +
  geom_label(aes(label = pct, hjust = 1.2))
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/ggplot2_bar_chart_geom_label-1.png" width="672" />

I am not a fan of this look and will stick to `geom_text()` for the final plot.

<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
<!-- B -->
<ins class="adsbygoogle"
     style="display:block"
     data-ad-client="ca-pub-1597114514381206"
     data-ad-slot="6037303850"
     data-ad-format="auto"
     data-full-width-responsive="true"></ins>
<script>
     (adsbygoogle = window.adsbygoogle || []).push({});
</script>

As the data in the plot represents percentages it's best practice to have the labels include the percentage sign. In addition, let's highlight our favorite language `R` and add title, footnotes etc.


```r
dreaded_lang %>%
  mutate(label = sprintf("%1.1f%%", pct)) %>%
  bar_chart(language, pct, highlight = "R", bar_color = "black") +
  geom_text(aes(label = label, hjust = -0.1), size = 5) +
  scale_y_continuous(
    limits = c(0, 100),
    expand = expansion()
  ) +
  labs(
    x = NULL,
    y = "Developers Who are Developing with the Language but<br>Have not Expressed Interest in Continuing to Do so",
    title = "Top 10 Most Dreaded Programming Languages",
    subtitle = "*R Placed 8th*",
    caption = "Source: Stackoverflow Developer Survey 2019"
  ) +
  mdthemes::md_theme_classic(base_size = 14) +
  theme(
    axis.text.x = element_blank(),
    axis.line.x = element_blank(),
    axis.ticks.x = element_blank()
  )
```

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/ggplot2_bar_chart_label_stackoverflow_developer_survey-1.png" width="672" />

Notice how easy it was to highlight a single bar thanks to [`ggcharts`](https://thomas-neitmann.github.io/ggcharts/index.html). In addition, I used my [`mdthemes`](https://github.com/thomas-neitmann/mdthemes) package which provides themes that interpret text as markdown. That way is was super easy to get the subtitle in *italics*. Furthermore, I removed the axis labels and grid lines. In my opinion you should **_never_** have an axis and labels in the same plot.

To finish off this post, let's have a quick look at how to label a vertical bar chart. It's basically the same process but instead of using `hjust` you will need to use `vjust` to adjust the label position.


```r
data("biomedicalrevenue")

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

<img src="/posts/2020-04-05-labels-ggplot2-bar-chart_files/figure-html/ggplot2_column_chart_label-1.png" width="672" />
