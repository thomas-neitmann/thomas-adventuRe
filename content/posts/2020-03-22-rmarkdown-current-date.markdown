---
title: Always display the current date in an Rmarkdown report
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




`Rmarkdown` is a great tool for creating data-driven reports that have to be updated on a regular basis. To communicate to stakeholders that the report is indeed up to date it's important to display the current date below the title.

An obvious solution to display the current date is to update the date field in the YAML header manually before knitting. But this is both error prone and you are likely to forget about it. Instead you can display the current date in an automatic way using the method below.


```r
---
title: "Super Important Report"
author: "Thomas Neitmann"
date: `r Sys.Date()`
---
```

When knitting the `Rmarkdown` document `Sys.Date()` will be evaluated and  display the current date.


```r
Sys.Date()
## [1] "2021-02-06"
```

A caveat is the date format, though. `Sys.Date()` returns the current date in ISO 8601 format, i.e. `yyyy-mm-dd`. Your audience is likely not used to this format so you might want to use a date format that's common in your locale.

How to achieve that? Using the `format()` function. Here are some examples.


```r
current_date <- Sys.Date()
format(current_date, "%d.%m.%Y")
## [1] "06.02.2021"
format(current_date, "%d. %B %Y")
## [1] "06. febrero 2021"
format(current_date, "%m/%d/%Y")
## [1] "02/06/2021"
```

After deciding which format to use make sure to wrap `Sys.Date()` inside of `format()` in your YAML header.


```r
---
title: "Super Important Report"
author: "Thomas Neitmann"
date: `r format(Sys.Date(), "%d. %B %Y")`
---
```
