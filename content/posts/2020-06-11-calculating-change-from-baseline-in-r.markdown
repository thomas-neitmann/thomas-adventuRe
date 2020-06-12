---
title: Calculating change from baseline in R
author: Thomas Neitmann
date: '2020-06-11'
slug: calculating-change-from-baseline-in-r
categories:
  - R
  - article
tags:
  - dplyr
  - base
  - datawrangling
toc: no
images: ~
---



As a statistical programmer working on clinical trials data I frequently have to calculate change from baseline. In clinical trials baseline is typically defined as the last measurement prior to a clinical trial subject receiving any study drug. Change from baseline is frequently calculated for laboratory measurements, e.g. hemoglobin concentration in blood.

SAS is still the standard used to program datasets in the pharmaceutical industry but `R` is catching up. Recently, I derived change from baseline for the first time in `R`. Using my beloved `{dplyr}` package this was straightforward to do.

To illustrate this I will use an artificial dataset of a clinical trial. The data comes from the [Wonderful Wednesday](https://www.psiweb.org/sigs-special-interest-groups/visualisation/welcome-to-wonderful-wednesdays) initiative of the data visualization special interest group within [PSI](https://www.psiweb.org/). The dataset contains six columns:

- **USUBJID**: Subject unique identifier
- **TRT01PN**: Treatment group (numeric)
- **TRT01P**: Treatment group
- **AVISITN**: Visit identifier (numeric)
- **AVISIT**: Visit identifier
- **AVAL**: haemoglobin concentration (g/dL)


```r
library(dplyr)
data_source <- "https://raw.githubusercontent.com/VIS-SIG/Wonderful-Wednesdays/master/data/2020/2020-06-10/hgb_data.csv"
trial_data <- read.csv(data_source, stringsAsFactors = FALSE)
glimpse(trial_data)
```

```
Rows: 2,100
Columns: 6
$ USUBJID <chr> "ABC123456.000001", "ABC123456.000001", "ABC123456.000001",...
$ TRT01PN <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,...
$ TRT01P  <chr> "Treatment E", "Treatment E", "Treatment E", "Treatment E",...
$ AVISITN <int> 10, 20, 30, 40, 50, 60, 70, 10, 20, 30, 40, 50, 60, 70, 10,...
$ AVISIT  <chr> "Baseline", "Week 4", "Week 8", "Week 12", "Week 16", "Week...
$ AVAL    <dbl> 10.197338, 11.272717, 12.288091, 13.508947, 12.195863, 10.1...
```

From the quick `glimpse()` you can see that each subject has multiple visits: Baseline, Week 4, Week 8 and so forth. To calculate change from baseline I have to subtract the baseline value from the value at each visit. Here's how.


```r
trial_data_chg <- trial_data %>%
  arrange(USUBJID, AVISITN) %>%
  group_by(USUBJID) %>%
  mutate(CHG = AVAL - AVAL[1L]) %>%
  ungroup()
```

First, it's important to arrange the data of each subject in increasing order of `AVISITN`. Next, I grouped the data by `USUBJID` such that `AVAL[1L]` refers to the baseline value of each subject. Finally, I subtracted the baseline value from the value measured at each visit.

Let's have a look at the result to see whether this actually did what I said it would do.


```r
trial_data_chg %>%
  select(USUBJID, AVISIT, AVAL, CHG) %>%
  print(n = 14)
```

```
# A tibble: 2,100 x 4
   USUBJID          AVISIT    AVAL     CHG
   <chr>            <chr>    <dbl>   <dbl>
 1 ABC123456.000001 Baseline 10.2   0     
 2 ABC123456.000001 Week 4   11.3   1.08  
 3 ABC123456.000001 Week 8   12.3   2.09  
 4 ABC123456.000001 Week 12  13.5   3.31  
 5 ABC123456.000001 Week 16  12.2   2.00  
 6 ABC123456.000001 Week 20  10.2  -0.0213
 7 ABC123456.000001 Week 24  12.3   2.09  
 8 ABC123456.000002 Baseline  9.40  0     
 9 ABC123456.000002 Week 4    9.14 -0.259 
10 ABC123456.000002 Week 8    8.56 -0.838 
11 ABC123456.000002 Week 12   8.59 -0.809 
12 ABC123456.000002 Week 16   8.46 -0.942 
13 ABC123456.000002 Week 20   8.78 -0.624 
14 ABC123456.000002 Week 24   6.97 -2.43  
# ... with 2,086 more rows
```

Looks good! This method will also work if the value at baseline is `NA` because subtracting `NA` from a number results in `NA`. This is the right result for change from baseline if there's no baseline available. However, this method will fail if there's no baseline record at all. In such a case the value of the first visit, e.g. Week 4, would be subtracted from the other visit values. This is wrong, though. Here's what I mean.


```r
trial_data <- trial_data[-1L, ] # remove baseline of first subject
trial_data %>%
  arrange(USUBJID, AVISITN) %>%
  group_by(USUBJID) %>%
  mutate(CHG = AVAL - AVAL[1L]) %>%
  ungroup() %>%
  select(USUBJID, AVISIT, AVAL, CHG) %>%
  print(n = 14)
```

```
# A tibble: 2,099 x 4
   USUBJID          AVISIT    AVAL    CHG
   <chr>            <chr>    <dbl>  <dbl>
 1 ABC123456.000001 Week 4   11.3   0    
 2 ABC123456.000001 Week 8   12.3   1.02 
 3 ABC123456.000001 Week 12  13.5   2.24 
 4 ABC123456.000001 Week 16  12.2   0.923
 5 ABC123456.000001 Week 20  10.2  -1.10 
 6 ABC123456.000001 Week 24  12.3   1.01 
 7 ABC123456.000002 Baseline  9.40  0    
 8 ABC123456.000002 Week 4    9.14 -0.259
 9 ABC123456.000002 Week 8    8.56 -0.838
10 ABC123456.000002 Week 12   8.59 -0.809
11 ABC123456.000002 Week 16   8.46 -0.942
12 ABC123456.000002 Week 20   8.78 -0.624
13 ABC123456.000002 Week 24   6.97 -2.43 
14 ABC123456.000003 Baseline  9.44  0    
# ... with 2,085 more rows
```


So, how to take care of missing baseline records? Like so.


```r
trial_data_chg2 <- trial_data %>%
  group_by(USUBJID) %>%
  mutate(
    HASBL = any(AVISIT == "Baseline"),
    CHG = if (HASBL) AVAL - AVAL[AVISIT == "Baseline"] else NA
  ) %>%
  select(-HASBL) %>%
  ungroup()
```

You could put the `any(AVISIT == "Baseline")` expression directly into `if()` but I think this way it's clearer to see what's going on. Let's check that this in fact produced the right result.


```r
trial_data_chg2 %>%
  select(USUBJID, AVISIT, AVAL, CHG) %>%
  print(n = 14)
```

```
# A tibble: 2,099 x 4
   USUBJID          AVISIT    AVAL    CHG
   <chr>            <chr>    <dbl>  <dbl>
 1 ABC123456.000001 Week 4   11.3  NA    
 2 ABC123456.000001 Week 8   12.3  NA    
 3 ABC123456.000001 Week 12  13.5  NA    
 4 ABC123456.000001 Week 16  12.2  NA    
 5 ABC123456.000001 Week 20  10.2  NA    
 6 ABC123456.000001 Week 24  12.3  NA    
 7 ABC123456.000002 Baseline  9.40  0    
 8 ABC123456.000002 Week 4    9.14 -0.259
 9 ABC123456.000002 Week 8    8.56 -0.838
10 ABC123456.000002 Week 12   8.59 -0.809
11 ABC123456.000002 Week 16   8.46 -0.942
12 ABC123456.000002 Week 20   8.78 -0.624
13 ABC123456.000002 Week 24   6.97 -2.43 
14 ABC123456.000003 Baseline  9.44  0    
# ... with 2,085 more rows
```

That looks good, awesome!

Next, I will show you how you can achieve the same result using only base `R`. I will use the good old split-apply-combine strategy.


```r
by_subject <- split(trial_data, trial_data$USUBJID)
by_subject_chg <- lapply(by_subject, function(data) {
  if (any(data$AVISIT == "Baseline")) {
    data$CHG <- data$AVAL - data$AVAL[data$AVISIT == "Baseline"]
  } else {
    data$CHG <- NA
  }
  data
})
trial_data_chg3 <- do.call(rbind, by_subject_chg)
diffdf::diffdf(trial_data_chg2, trial_data_chg3)
```

```
No issues were found!
```

Compared to the `{dplyr}` approach this is a bit clumsy but it certainly does the job and you don't need any add-on packages. `split()`—as the name suggests—splits its input `data.frame` into a `list` of `data.frame`s, one for each level of the second argument. `lapply()` applies a function to every element of a `list`. `do.call(rbind, <list>)` combines the datasets in `<list>` back to a single `data.frame`.

Actually you can combine `split()` and `lapply()` into a single step using `by()` which makes it more concise.


```r
by_subject_chg <- by(
  data = trial_data,
  INDICES = trial_data$USUBJID,
  FUN = function(data) {
    if (any(data$AVISIT == "Baseline")) {
      data$CHG <- data$AVAL - data$AVAL[data$AVISIT == "Baseline"]
    } else {
      data$CHG <- NA
    }
    data
  }
)
trial_data_chg4 <- do.call(rbind, by_subject_chg)
diffdf::diffdf(trial_data_chg2, trial_data_chg4)
```

```
No issues were found!
```

The example dataset contains only a single laboratory measure but in practice that's never the case. Let's have a look at how to calculate change from baseline when having multiple lab parameters in the dataset. To do so I will duplicate the dataset and add a variable called `PARAM` to identify different lab measures.


```r
trial_data$PARAM <- "Hemoglobin"
trial_data2 <- trial_data
trial_data2$PARAM <- "WBC" # White Blood Count
trial_data_mult <- rbind(trial_data, trial_data2)
```

First, the `{dplyr}` version.


```r
trial_data_mult_chg <- trial_data_mult %>%
  group_by(USUBJID, PARAM) %>%
  mutate(
    HASBL = any(AVISIT == "Baseline"),
    CHG = if (HASBL) AVAL - AVAL[AVISIT == "Baseline"] else NA
  ) %>%
  select(-HASBL) %>%
  ungroup()

trial_data_mult_chg %>%
  select(USUBJID, AVISIT, PARAM, AVAL, CHG) %>%
  head(13)
```

```
# A tibble: 13 x 5
   USUBJID          AVISIT   PARAM       AVAL    CHG
   <chr>            <chr>    <chr>      <dbl>  <dbl>
 1 ABC123456.000001 Week 4   Hemoglobin 11.3  NA    
 2 ABC123456.000001 Week 8   Hemoglobin 12.3  NA    
 3 ABC123456.000001 Week 12  Hemoglobin 13.5  NA    
 4 ABC123456.000001 Week 16  Hemoglobin 12.2  NA    
 5 ABC123456.000001 Week 20  Hemoglobin 10.2  NA    
 6 ABC123456.000001 Week 24  Hemoglobin 12.3  NA    
 7 ABC123456.000002 Baseline Hemoglobin  9.40  0    
 8 ABC123456.000002 Week 4   Hemoglobin  9.14 -0.259
 9 ABC123456.000002 Week 8   Hemoglobin  8.56 -0.838
10 ABC123456.000002 Week 12  Hemoglobin  8.59 -0.809
11 ABC123456.000002 Week 16  Hemoglobin  8.46 -0.942
12 ABC123456.000002 Week 20  Hemoglobin  8.78 -0.624
13 ABC123456.000002 Week 24  Hemoglobin  6.97 -2.43 
```

```r
trial_data_mult_chg %>%
  select(USUBJID, AVISIT, PARAM, AVAL, CHG) %>%
  tail(7)
```

```
# A tibble: 7 x 5
  USUBJID          AVISIT   PARAM  AVAL    CHG
  <chr>            <chr>    <chr> <dbl>  <dbl>
1 ABC123456.000300 Baseline WBC    9.75  0    
2 ABC123456.000300 Week 4   WBC    8.88 -0.871
3 ABC123456.000300 Week 8   WBC    8.57 -1.18 
4 ABC123456.000300 Week 12  WBC    8.13 -1.62 
5 ABC123456.000300 Week 16  WBC    8.87 -0.880
6 ABC123456.000300 Week 20  WBC   12.7   2.95 
7 ABC123456.000300 Week 24  WBC   12.0   2.20 
```

That was easy. All I had to do was to add a second grouping variable, i.e. `PARAM`.

Next, the base `R` version.


```r
by_subject_chg <- by(
  data = trial_data_mult,
  INDICES = list(trial_data_mult$USUBJID, trial_data_mult$PARAM),
  FUN = function(data) {
    if (any(data$AVISIT == "Baseline")) {
      data$CHG <- data$AVAL - data$AVAL[data$AVISIT == "Baseline"]
    } else {
      data$CHG <- NA
    }
    data
  }
)
trial_data_mult_chg2 <- do.call(rbind, by_subject_chg)
diffdf::diffdf(trial_data_mult_chg, trial_data_mult_chg2)
```

```
No issues were found!
```

Again a minimal change. Just pass a `list` of variables to split by to the `INDICES` argument of `by()`.

There you have it, that's how you calculate change from baseline in `R` using `{dplyr}` and good old `{base}`. If you enjoyed reading this post please share it with your friends and colleagues. Thank you!
