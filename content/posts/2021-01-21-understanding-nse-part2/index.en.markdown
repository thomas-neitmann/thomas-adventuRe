---
title: 'Understanding Non-Standard Evaluation. Part 2: Do It Yourself'
author: Thomas Neitmann
date: '2021-01-21'
slug: understanding-nse-part2
categories:
  - R
  - article
tags:
  - base
toc: no
images: ~
---

## Writing your own NSE functions

So, how does NSE work? Like, if you want to do it yourself and create your own NSE function. Let's explore that by writing our own version of `$`. The two ingredients we need are `substitute()` and `eval()`.


```r
`%$%` <- function(lhs, rhs) {
  eval(substitute(rhs), envir = lhs, enclos = parent.frame())
}
head(iris%$%Species)
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

There's quite a chance that this looks like total gibberish to you, so let's take it step-by-step.

First of all, if you want to create a binary operator in R yourself you have to enclose it inside `%`. That doesn't look too nice but that's just R's syntax. Since `%$%` is not a syntactic name, i.e. one that starts with a `.` or letter and contains only letters, numbers, `_` or `.`, you have to wrap it inside backticks when defining it. But note that the backticks are *not* needed when actually using the operator.

The parameter names `lhs` and `rhs` are just abbreviations for left-hand side and right-hand side, respectively. I think these are appropriate names given how you use the operator.

Next, onto `substitute()`. What does this function actually do? Usually, when you pass an argument to a function, that argument is evaluated to a value.


```r
me <- "Thomas"
look_inside <- function(x) x
look_inside(me)
```

```
## [1] "Thomas"
```

By using `substitute()` you can avoid evaluating the argument and instead look at the *expression* that has been passed as argument. The most simple expressions are symbols. 


```r
look_outside <- function(x) substitute(x)
look_outside(me)
```

```
## me
```

If yo


```r
look_outside(subset(iris, Species == "setosa"))
```

```
## subset(iris, Species == "setosa")
```

