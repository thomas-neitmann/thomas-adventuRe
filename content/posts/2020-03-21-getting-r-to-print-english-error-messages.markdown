---
title: Getting R to Print English Error Messages
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

*<small>This article is also available in [Spanish](/es/posts/que-r-devuelva-errores-en-ingles).</small>*

If you live in a non-English locale---such as I do---you'll likely receive error messages in your locale language when things go wrong in `R`.


```r
1 + "r"
```

```
## Error in 1 + "r": nicht numerisches Argument für binären Operator
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

Never heard of `.Rprofile`? It's basically an `R` script that---if present---gets executed whenever you start `R`. That makes it perfect for the purpose of changing your locale.

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

The easiest way to edit or create this file is by using the `{usethis}` package (make sure to install it if you haven't already).


```r
usethis::edit_r_profile()
```

This will open the `.Rprofile` file in the user home directory, i.e. `~/.Rprofile`. This file will get executed in any R session you start *unless* you have another `.Rprofile` in your RStudio project directory. If you do, then use this code instead to edit the project specific `.Rprofile`.


```r
usethis::edit_r_profile(scope = "project")
```
