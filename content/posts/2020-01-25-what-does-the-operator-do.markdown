---
title: What does the <<- operator do?
author: Thomas Neitmann
date: '2020-01-25'
slug: what-does-the-operator-do
categories:
  - R
  - bytesized
tags:
  - base
toc: no
images: ~
---

If you've been using `R` for a while, chances are high you came across the `<<-` operator. On several occasions I've heard or read people calling `<<-` the "global assignment operator". However, this is wrong. Let me elaborate why.

First, have a look at this example.


```r
x <- 0
foo <- function() {
  x <<- x + 1
  x
}
foo()
```

```
## [1] 1
```

```r
foo()
```

```
## [1] 2
```

```r
x
```

```
## [1] 2
```


Here `<<-` truly behaves like a global assignment operator. Every time you call `foo()` the variable `x` in the global environment is incremented by 1. So far so good.

If you look at the next example, though, you'll see that `<<-` does *not* always assign to the global environment.


```r
y <- 0
bar <- function() {
  y <- 99
  bla <- function() {
    y <<- y + 1
  }
  bla()
  y
}

bar()
```

```
## [1] 100
```

```r
y
```

```
## [1] 0
```

Instead, it assigns the value to the variable in the enclosing environment, i.e. the environment in which the function was created. It just happens to be that in the first example the enclosing environment was the global environment. In the second example that is not the case and so the variable `y` in the global environment is unaffected by calling `bar()`.

If you'd truly want to assign a value to a variable in the global environment you'd have to do something like this:

```r
.GlobalEnv$x <- 100
```

But, carefully think whether or not you really want to work with global variables (most of the time there are better solutions).
