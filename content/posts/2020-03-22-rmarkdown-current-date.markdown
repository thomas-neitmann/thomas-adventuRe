---
title: Always Display the Current Date in an Rmarkdown Report
author: Thomas Neitmann
date: '2020-03-22'
slug: rmarkdown-current-date
categories:
  - bytesized
  - R
tags:
  - rmarkdown
  - knitr
toc: no
images: ~
---

*<small>This post is also available in [Spanish](/es/posts/rmarkdown-actualizar-fecha).</small>*



`Rmarkdown` is a great tool for creating data-driven reports that have to be updated on a regular basis. To communicate to stakeholders that the report is indeed up to date it's important to display the current date below the title.

An obvious solution to display the current date is to update the `date` field in the YAML header manually before knitting. But this is both error prone and you are likely to forget about it. Instead you can automatically display the current date by placing an inline R chunk containing a call to `Sys.Date()` as the value of the `date` field.


```r
---
title: "Super Important Report"
author: "Thomas Neitmann"
date: `r Sys.Date()`
---
```

When knitting the `Rmarkdown` document `Sys.Date()` will be evaluated and display the current date.


```r
Sys.Date()
## [1] "2021-02-11"
```

A caveat is the date format, though. `Sys.Date()` returns the current date in ISO 8601 format, i.e. `yyyy-mm-dd`. Your audience is likely not used to this format. You should use a date format that's common in your locale or standard within your organization.

How to achieve that? Using the `format()` function. Here are some examples.


```r
current_date <- Sys.Date()
format(current_date, "%d.%m.%Y")
## [1] "11.02.2021"
format(current_date, "%d. %B %Y")
## [1] "11. Februar 2021"
format(current_date, "%m/%d/%Y")
## [1] "02/11/2021"
```

After deciding which format to use make sure to wrap `Sys.Date()` inside of `format()` in your YAML header.


```r
---
title: "Super Important Report"
author: "Thomas Neitmann"
date: `r format(Sys.Date(), "%d. %B %Y")`
---
```

Notice that when I requested the full month name to be displayed by using `format(current_date, "%d. %B %Y")` the result was in German, i.e. *Februar*. That's because the locale on my PC is set to German. To display month names in a different language you need to change the locale using `Sys.setlocale()`. Let's try Spanish.


```r
Sys.setlocale("LC_TIME", "Spanish")
## [1] "Spanish_Spain.1252"
format(current_date, "%d. %B %Y")
## [1] "11. febrero 2021"
```

It's not sufficient to put this line of code in the first code chunk of your `Rmarkdown` document. Instead you have to place it directly inside the `date` field of the YAML header. Pay attention to the semicolon between `Sys.setlocale()` and `format()`.


```r
---
title: "Super Important Report"
author: "Thomas Neitmann"
date: `r Sys.setlocale("LC_TIME", "Spanish"); format(Sys.Date(), "%d. %B %Y")`
---
```
