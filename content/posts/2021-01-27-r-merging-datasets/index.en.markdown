---
title: All You Need To Know About Merging Datasets in R
author: Thomas Neitmann
date: '2021-01-27'
slug: r-merging-datasets
categories:
  - R
  - article
tags:
  - base
  - dplyr
  - datawrangling
toc: no
images: ~
---

Merging (or joining) two or more datasets by one or more common ID variables is a common task for any data scientist. If you get the merge wrong you can create some serious damage to your downstream analysis so you'd better make sure you're doing the right thing! In order to do so, I'll walk you through three different approaches to joining tables in R: the {base} way, the {dplyr} way and the SQL way (yes, you can use SQL in R).

## Types of Merges

First of, though, let's review the different ways you can merge datasets. Borrowing from the SQL terminology I will cover these three types:

- Left join
- Rigt join
- Inner join
- Full join

### Left Join

In a left join involving dataset `L` and dataset `R` the finale table---let's call it `LR`---will contain *all* records from dataset `A` but only those records from dataset `B` whose key (ID) is contained in `B`. Thus, if `A` has 10 records then `AB` will have 10 records as well.

![](/static/posts/2021-01-27-r-merging-datasets/left_join.gif)

### Right Join

![](/static/posts/2021-01-27-r-merging-datasets/right_join.gif)

### Inner Join

![](/static/posts/2021-01-27-r-merging-datasets/inner_join.gif)

### Full Join

![](/static/posts/2021-01-27-r-merging-datasets/full_join.gif)

