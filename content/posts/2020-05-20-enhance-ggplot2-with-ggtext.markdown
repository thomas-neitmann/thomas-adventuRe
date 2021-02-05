---
title: Enhance your {ggplot2} data visualizations with {ggtext}
author: Thomas Neitmann
date: '2020-05-20'
slug: enhance-ggplot2-with-ggtext
categories:
  - R
tags:
  - ggplot2
  - datavisualization
toc: no
images: ~
---

I am super exciting to share with you my recent "discovery" of the [`{ggtext}`](https://wilkelab.org/ggtext/) `R` package.

I had looked for a solution to color individual words in the title of a `{ggplot2}` data visualization and `{ggtext}` provided me with a great solution for doing just that (and more).

So, how does it work? Have a look at this example:


```r
library(ggplot2)
library(dplyr)
data(biomedicalrevenue, package = "ggcharts")

plot <- biomedicalrevenue %>%
  filter(company %in% c("Roche", "Novartis")) %>%
  ggplot(aes(year, revenue, color = company)) +
  geom_line(size = 1.2) +
  ggtitle(
    paste0(
      "<span style = 'color:#93C1DE'>**Roche**</span>",
      " *overtook* <span style = 'color:darkorange'>**Novartis**</span>",
      " in 2016"
    )
  ) +
  scale_color_manual(
    values = c("Roche" = "#93C1DE", "Novartis" = "darkorange"),
    guide = "none"
  ) +
  ggcharts::theme_hermit(ticks = "x", grid = "X")  +
  theme(plot.title = ggtext::element_markdown())
plot
```

<img src="/posts/2020-05-20-enhance-ggplot2-with-ggtext_files/figure-html/ggtext_example-1.png" width="672" />

Inside `theme()` I set `plot.title = ggtext::element_markdown()`. This has the effect that the plot title I created using `ggtitle()` is interpreted as markdown/HTML. That made it possible to have the title of the plot act as a legend by coloring the appropriate keywords.

To color words you have to wrap them inside a `<span>` tag and use inline CSS to specify the color. In general with will look like this:

```HTML
<span style = 'color:color name or hex code'>Text you want to color</span>
```

Pay attention to the slash in the second `</span>` tag. If you miss that it won't render properly because that's invalid HTML.

Notice also that inside of `scale_color_manual()` I set `guide = "none"`. This results in no legend being drawn which would be redundant in this plot.

Quite a neat solution, isn't it?

<a target="_blank"  href="https://www.amazon.com/gp/product/1491978600/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=1491978600&linkCode=as2&tag=07075-20&linkId=cf413d9b2e8866f8c5f86d35d3bed2ab"><img border="0" src="//ws-na.amazon-adsystem.com/widgets/q?_encoding=UTF8&MarketPlace=US&ASIN=1491978600&ServiceVersion=20070822&ID=AsinImage&WS=1&Format=_SL250_&tag=07075-20" ></a><img src="//ir-na.amazon-adsystem.com/e/ir?t=07075-20&l=am2&o=1&a=1491978600" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" />

While you need to revert to HTML for coloring the text you can use markdown for making individual words bold (e.g. `**Roche**`), italics (e.g. `*overtook*`) and so forth. I love the flexibility this offers.

The `{ggtext}` package is not available from CRAN, yet, but you can install it from GitHub.

```r
remotes::install_github("wilkelab/ggtext")
```

Setting individual theme elements to `ggtext::element_markdown()` can add quite a bit of boilerplate code to your plot. That's why I decided to create the [`{mdthemes}`](https://github.com/thomas-neitmann/mdthemes) package which provides themes that interpret text as markdown out of the box. Let's contrast a "normal" theme with an `md_theme`. First, have a look at what happens if I add `theme_minimal()` to the plot I just created.


```r
plot + theme_minimal()
```

<img src="/posts/2020-05-20-enhance-ggplot2-with-ggtext_files/figure-html/normal_theme_example-1.png" width="672" />

As expected, the title is not rendered correctly because the `plot.title` theme element is overwritten. If you use `md_theme_minimal()`, however, it just works.


```r
plot + mdthemes::md_theme_minimal()
```

<img src="/posts/2020-05-20-enhance-ggplot2-with-ggtext_files/figure-html/mdthemes_example-1.png" width="672" />

Apart from the title, the subtitle, axis labels and captions are set to `element_markdown()` for all `mdthemes`.


```r
plot +
  labs(
    x = "**Year**",
    y = "Revenue (*Billion* USD)",
    caption = "Data Source: *en.wikipedia.org/wiki/List_of_largest_biomedical_companies_by_revenue*"
  ) +
  mdthemes::md_theme_minimal()
```

<img src="/posts/2020-05-20-enhance-ggplot2-with-ggtext_files/figure-html/mdthemes_example_cont-1.png" width="672" />


The `{mdthemes}` packages currently contains all themes from `{ggplot2}`, `{ggthemes}`, `{hrbrthemes}`, `{tvthemes}` and `{cowplot}` with support for rendering text as markdown.

If you want to turn a theme that is not part of the `{mdthemes}` package into an `md_theme` you can use the `as_md_theme()` function.


```r
plot + mdthemes::as_md_theme(theme_minimal())
```

<img src="/posts/2020-05-20-enhance-ggplot2-with-ggtext_files/figure-html/as_mdt_theme_example-1.png" width="672" />

Just like [`{ggtext}`](https://wilkelab.org/ggtext/), the [`{mdthemes}`](https://github.com/thomas-neitmann/mdthemes) package is currently only available from GitHub. You can install it by copy-pasting this code into your `R` console.

```r
remotes::install_github("thomas-neitmann/mdthemes")
```
