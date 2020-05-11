---
title: 'Analyzing the ggcharts CRAN Downloads. Part 1: Getting Data'
author: Thomas Neitmann
date: '2020-04-10'
slug: ggcharts-cran-downloads-part-1
categories:
  - R
  - article
tags: []
toc: no
images: ~
---

## Introduction

It's been a little over two weeks since my [`ggcharts`](https://thomas-neitmann.github.io/ggcharts/index.html) package has been published on CRAN. As you can imagine I am curious to see how many people actually use the package. While there is no way to actually measure the usage, the number of package downloads seems like a good proxy to me.


## CRAN Logs

Getting data on the number of package downloads is fairly easy thanks to the `cranlogs` package.


```r
cranlogs::cran_downloads("ggcharts", "last-week")
```

```
##         date count  package
## 1 2020-05-03    35 ggcharts
## 2 2020-05-04    43 ggcharts
## 3 2020-05-05    43 ggcharts
## 4 2020-05-06    31 ggcharts
## 5 2020-05-07    43 ggcharts
## 6 2020-05-08    34 ggcharts
## 7 2020-05-09    33 ggcharts
```

Notably, only downloads from RStudio's CRAN mirror are counted here. But I would guess that more than 90% of userRs also use RStudio so it shouldn't be too far off the actual number of downloads.

I was curious why for some days the number of downloads suddenly dropped to `0`. As it turned out this is a [known bug](https://github.com/r-hub/cranlogs/issues/54). Thus, I decided to "manually" download the CRAN logs from [cran-logs.rstudio.com](http://cran-logs.rstudio.com/).


## Downloading a Single Log File

If you visit this CRAN logs website you'll see that it contains one file per day. The data is stored in `.csv` files compressed with `gzip`. Let's have a look at a single file.


```r
url <- "http://cran-logs.rstudio.com/2020/2020-04-01.csv.gz"
file <- "2020-04-01.csv.gz"
download.file(url, file)
downloads <- read.csv(file)
head(downloads)
```

```
##         date     time     size r_version r_arch    r_os    package  version
## 1 2020-04-01 18:40:53   813724      <NA>   <NA>    <NA>    rgenoud  5.8-3.0
## 2 2020-04-01 18:40:58   258505      <NA>   <NA>    <NA> rstudioapi     0.11
## 3 2020-04-01 18:40:51    13426      <NA>   <NA>    <NA>        AUC    0.3.0
## 4 2020-04-01 18:40:54   745075     3.6.3 x86_64 mingw32      Hmisc    4.4-0
## 5 2020-04-01 18:40:58  1154641      <NA>   <NA>    <NA>    ggrepel    0.8.2
## 6 2020-04-01 18:40:56 18271283      <NA>   <NA>    <NA>         BH 1.72.0-3
##   country ip_id
## 1      NL     1
## 2      HK     2
## 3      US     3
## 4      GB     4
## 5      CO     5
## 6      US     6
```

If you run this code yourself you will note that the file is quite large (~60 MB) and downloading plus reading the file is slow. But compared to the `cran_downloads()` output it does contain more information so I think its worth the effort. Personally, I am especially interested in the `country` column.


## Downloading Multiple Log Files

Downloading a single file is nice but I was interested to see data on all downloads since the package was published on CRAN on March 26th. Downloading multiple files is not too difficult because all files follow the same naming structure, namely the date in ISO 8601 format, e.g. `2020-02-13.csv.gz`. Thus, below I am creating a vector of dates to subsequently loop over.


```r
start_date <- as.Date("2020-03-26")
end_date <- as.Date("2020-4-08")
dates <- as.Date(start_date:end_date, origin = "1970-01-01")
```

Inside `lapply()` I build the proper URL of the file, download it and read it into `R`. Next, I delete the file and finally filter only the records of `ggcharts`.

```r
base_url <- "http://cran-logs.rstudio.com/2020/"
downloads <- lapply(dates, function(date) {
  file <- paste0(as.character(date), ".csv.gz")
  url <- paste0(base_url, file)
  
  download.file(url, file)
  downloads <- read.csv(file)
  file.remove(file)
  
  downloads[downloads$package == "ggcharts", ]
})
```

If you want to run this code yourself, you'd better step away from your desk and grep yourself a coffee. It will feel like an eternity until all files are downloaded and read into `R`.

So, you may ask, is there a way to speed this up? Sure enough, there is!

For one, instead of downloading and reading the files sequentially you can do this in parallel thanks to `R`'s build-in `parallel` package. In addition, using `data.table` and its `fread()` function will dramatically reduce the time it takes to read a single file.


```r
cl <- parallel::makeCluster(parallel::detectCores())
downloads <- parallel::parLapply(cl, dates, function(date) {
  base_url <- "http://cran-logs.rstudio.com/2020/"
  file <- paste0(as.character(date), ".csv.gz")
  url <- paste0(base_url, file)
  
  download.file(url, file)
  downloads <- data.table::fread(file)
  file.remove(file)
  
  downloads[package == "ggcharts"]
})
parallel::stopCluster(cl)
```

This code will only run on Windows. If you are using `R` on macOS or Linux this will do the trick instead.

```r
downloads <- parallel::mclapply(dates, function(date) {
  base_url <- "http://cran-logs.rstudio.com/2020/"
  file <- paste0(as.character(date), ".csv.gz")
  url <- paste0(base_url, file)
  
  download.file(url, file)
  downloads <- data.table::fread(file)
  file.remove(file)
  
  downloads[package == "ggcharts"]
})
```

Note that I moved the `base_url` assignment inside of the lambda function. Not doing so will result in an error because the function is executed in its own environment which does not have access to `base_url` in the global environment.

Running this code will still take some time but is **_much_** faster than the solution with `lapply()` and `read.csv()`.

Just like `lapply()`, `parallel::parLapply()` and `parallel::mclapply()` return a list. Combining the individual datasets inside the list is easy.


```r
downloads <- data.table::rbindlist(downloads)
```


## Aggregating the Data 

At this point `downloads` contains one row per download of `ggcharts`. Getting the daily downloads can be achieved like this.


```r
daily_downloads <- downloads[, .N, by = date]
head(daily_downloads)
```

```
##          date  N
## 1: 2020-03-26 11
## 2: 2020-03-27 29
## 3: 2020-03-28 30
## 4: 2020-03-29 39
## 5: 2020-03-30 35
## 6: 2020-03-31 31
```

This is `data.table` syntax. The equivalent `dplyr` code looks like this.

```r
downloads %>%
  group_by(date) %>%
  summarise(N = n())
```

The `date` column is still a `character` at this point. Let's change that and in addition calculate the cumulative downloads.


```r
daily_downloads[, date := as.Date(date)]
daily_downloads[, cumulative_N := cumsum(N)]
```

If you are not used to working with `data.table` then you may wonder what this strange looking syntax is about. With `dplyr` you'd do something like this instead.

```r
daily_downloads <- daily_downloads %>%
  mutate(data = as.Date(data), cumulative_N = cumsum(N))
```

Notice that when using `dplyr` you have to re-assign the result to `daily_downloads` because you are copying the original dataset and only after that modify it. This is `R`'s standard behavior and is called copy-on-modify.

Using `data.table`'s special `:=` operator you can avoid the copying and instead directly add a new column to the existing dataset *in place*. This can save you a lot of time and memory when working with large datasets. Arguably, this is overkill here but since I was using `data.table` already I wanted to stick with it rather than switching to `dplyr`.

Next, let's calculate the total downloads by country.


```r
downloads_by_country <- downloads[, .N, by = country]
head(downloads_by_country)
```

```
##    country   N
## 1:      ES   5
## 2:      CZ   1
## 3:      US 204
## 4:      CA   7
## 5:      VE   3
## 6:      CN  12
```

The countries are coded according to the [ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) standard. Transforming these two letter codes into more readable country names can be done with the `countrycode` package.


```r
downloads_by_country[, country := countrycode::countrycode(country, "iso2c", "country.name")]
```

That's it for part 1. In [part 2](/posts/ggcharts-cran-downloads-part-2/) I will continue with creating a data visualization of the downloads. In the meantime feel free to ask me any question you may have about this post in the comments below.
