---
title: Getting R to print English error messages
author: Thomas Neitmann
date: '2020-03-21'
slug: getting-r-to-print-english-error-messages
categories:
  - R
  - bytesized
tags:
  - base
toc: no
images: ~
---

If you live in a non-English locale such as I do, you'll likely receive error messages in your locale language when things go wrong in `R`.


```r
1 + "r"
```

```
## Error in 1 + "r": nicht-numerisches Argument für binären Operator
```

This is a problem because it highly limits the results when searching for error messages on Google. Have you ever read a stackoverflow post that was not in English? I haven't.

So, how can you tell `R` to *not* translate error messages? By telling `R` that you are in an English locale.


```r
Sys.setenv(lang = "en_US")
```

Your next error will be printed in English.


```r
1 + "r"
```

```
## Error in 1 + "r": non-numeric argument to binary operator
```

Great!

The only problem with this approach is that the next time you start a new `R` session this change will be reverted. To make this change persistent add `Sys.setenv(lang = "en_US")` to your `.Rprofile` file.

Never heard of `.Rprofile`? It's basically an `R` script that - if present - gets executed whenever you start `R`. That makes it perfect for the purpose of changing your locale.
