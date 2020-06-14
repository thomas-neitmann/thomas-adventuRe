---
title: '{mdthemes} is on CRAN: markdown powered themes for {ggplot2}'
author: Thomas Neitmann
date: '2020-06-14 18:00'
slug: mdthemes-is-on-cran-markdown-powered-themes-for-ggplot2
categories:
  - R
tags:
  - datavisualization
  - package
  - ggplot2
toc: no
images: ~
---




I'm very pleased to announce that `{mdthemes}`—my second (public) R package—is now available from CRAN. `{mdthemes}` adds support for rendering text as markdown to the themes from `{ggplot2}`, `{ggthemes}`, `{hrbrthemes}`, `{tvthemes}` and `{cowplot}`. It contains 55 themes in total. All themes start with `md_` followed by the name of the original theme, e.g. `md_theme_bw()`.

I've been meaning to put this package on CRAN for quite some time. However, before submitting I had to wait until `{ggtext}`—which does all the hard work for `{mdthemes}`—was available from CRAN. Fortunately, `{ggtext}` was accepted recently so I could go ahead with submitting `{mdthemes}`. 10 days and one re-submission later it finally got accepted.

To motivate the use of `{mdthemes}` let's say you'd like to use `theme_minimal()` but want a bold title rather then the plain default one. With vanilla `{ggplot2}` you'd have to rely on using `theme()`.


```r
library(ggplot2)
library(dplyr)
library(mdthemes)

ggplot(mtcars, aes(hp, mpg)) +
  geom_point() +
  ggtitle("Seminal Scatter Plot") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold"))
```

<img src="/posts/2020-06-07-mdthemes-is-on-cran-markdown-powered-themes-for-ggplot2_files/figure-html/unnamed-chunk-1-1.png" width="672" />

With `{mdthemes}` you can do this instead.


```r
ggplot(mtcars, aes(hp, mpg)) +
  geom_point() +
  ggtitle("**Seminal Scatter Plot**") +
  md_theme_minimal()
```

<img src="/posts/2020-06-07-mdthemes-is-on-cran-markdown-powered-themes-for-ggplot2_files/figure-html/unnamed-chunk-2-1.png" width="672" />

All I had to do was to put the title inside two asterisks and use `md_theme_minimal()` instead of `theme_minimal()`.

So far so good. Let's take a look at another, more complex example.


```r
ggplot(mtcars, aes(hp, mpg, color = factor(cyl))) +
  geom_point() +
  labs(
    title = "This is a **bold** title",
    subtitle = "And an *italics* subtitle",
    x = "**_hp_**"
  ) +
  md_theme_fivethirtyeight()
```

<img src="/posts/2020-06-07-mdthemes-is-on-cran-markdown-powered-themes-for-ggplot2_files/figure-html/unnamed-chunk-3-1.png" width="672" />

As you can see you are not limited to making the whole title bold (as is the case when using `theme()`). Rather you can bold individual words. The same is true for italics. Just wrap the word inside `*`. To make something bolditalic wrap it inside `**_`.

Next, let's have a look at coloring words.


```r
data(biomedicalrevenue, package = "ggcharts")

line_chart <- biomedicalrevenue %>%
  filter(company %in% c("Roche", "Novartis")) %>%
  ggplot(aes(year, revenue, color = company)) +
  geom_line(size = 1.2) +
  ggtitle(
    paste0(
      "<span style = 'color:#93C1DE'>**Roche**</span>",
      " overtook <span style = 'color:darkorange'>**Novartis**</span>",
      " in 2016"
    )
  ) +
  scale_color_manual(
    values = c("Roche" = "#93C1DE", "Novartis" = "darkorange"),
    guide = "none"
  ) +
  md_theme_economist_white()
line_chart
```

<img src="/posts/2020-06-07-mdthemes-is-on-cran-markdown-powered-themes-for-ggplot2_files/figure-html/unnamed-chunk-4-1.png" width="672" />

I wrapped the company names in the title inside a HTML `<span>` tag and used inline CSS to color them. That way I could get rid of the legend which I think is really neat.

You are not limited to coloring the title, you can do the same with the axis tick labels (or any text for that matter).


```r
data("gapminder", package = "gapminder")
label <- function(x) {
  if (x %in% c("Roche", "Novartis")) {
    paste0("<span style='color:#D52B1E'>**", x, "**</span>")
  } else {
    paste0("<span style='color:gray'>", x, "</span>")
  }
}

spec <- ggcharts::highlight_spec(
  what = c("Roche", "Novartis"),
  highlight_color = "#D52B1E",
  other_color = "gray"
)
biomedicalrevenue %>%
  filter(year == 2018) %>%
  ggcharts::bar_chart(
    company,
    revenue,
    highlight = spec,
    top_n = 10
  ) +
  scale_x_discrete(labels = Vectorize(label)) +
  labs(
    x = NULL,
    y = "Revenue in 2018 (Billion USD)",
    title = glue::glue("Two {shiny::span('**Swiss**', style='color:#D52B1E')} Companies Are Among The Top 10 Big Pharma")
  ) +
  md_theme_minimal_vgrid() +
  theme(plot.title.position = "plot")
```

<img src="/posts/2020-06-07-mdthemes-is-on-cran-markdown-powered-themes-for-ggplot2_files/figure-html/unnamed-chunk-5-1.png" width="672" />

Notice that I used the little helper function `shiny::span()` to create the required HTML for the title rather then writing it by hand.

As I mentioned in the beginning of this post, `{ggtext}` is the package which powers `{mdthemes}`. `{ggtext}` provides `element_markdown()` which—unlike `element_text()`—renders text as markdown/HTML. What `{mdthemes}` does is basically substituting every text related theme element that usually is `element_text()` with `element_markdown()`. To get all full picture of the subset of markdown/HTML that `{ggtext}` currently supports, check out the [package website](https://wilkelab.org/ggtext/).

I would like to mention that you can turn *any* theme into a markdown theme using the `as_md_theme()` function. In fact that's exactly what I do inside the package. Have a look at the function body of `md_theme_minimal()` for example.


```r
md_theme_minimal
```

```
function (...) 
{
    as_md_theme(ggplot2::theme_minimal(...))
}
<bytecode: 0x000000001876b9d8>
<environment: namespace:mdthemes>
```

Let's see this in action. Using the non-markdown theme `theme_hermit()` the text is not rendered.


```r
line_chart +
  ggcharts::theme_hermit(grid = "XY")
```

<img src="/posts/2020-06-07-mdthemes-is-on-cran-markdown-powered-themes-for-ggplot2_files/figure-html/unnamed-chunk-7-1.png" width="672" />

But now it is!


```r
line_chart +
  as_md_theme(ggcharts::theme_hermit(grid = "XY"))
```

<img src="/posts/2020-06-07-mdthemes-is-on-cran-markdown-powered-themes-for-ggplot2_files/figure-html/unnamed-chunk-8-1.png" width="672" />

While this is a nice workaround, I'd encourage you to let me know if `{mdthemes}` is missing your favorite theme(s)? To do so, please open an issue on [GitHub](https://github.com/thomas-neitmann/mdthemes/issues). I'm more than happy to add more themes.

That's it. Make sure to `install.packages("mdthemes")` and if you enjoy using the package please star in on [GitHub](https://github.com/thomas-neitmann/mdthemes). Thank you!
