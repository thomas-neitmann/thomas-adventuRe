---
title: Creating excel files from R using openxlsx
author: Thomas Neitmann
date: '2020-02-06'
slug: creating-excel-files-from-r-using-openxlsx
categories:
  - R
  - bytesized
tags:
  - excel
toc: no
images: ~
---

Yesterday I had to share data with some internal stakeholders in excel format. Why excel? Well, I guess if you are not a "data professional", then that's the easiest format to work with.

So, I started `R`, read in the dataset, did some data wrangling and then wanted to write the data to a xlsx file. I heard great things about the `openxlsx` package so I used it for the first time. My initial attempt was using the `write.xlsx()` function. That certainly did the job but the resulting file didn't look how I like my excel files. I am a fan of a freezed top row with bold and centered column headers.

I digged a bit into the `openxlsx` documentation and it turned out that the package can do all of this. Great!

Here is the code I used (obviously not exporting the mtcars dataset):

```r
library(openxlsx)
data(mtcars)

header_style <- createStyle(halign = "center", textDecoration = "bold")

wb <- createWorkbook()

addWorksheet(wb, "Data")
writeData(wb, "Data", mtcars, headerStyle = header_style)
freezePane(wb, "Data", firstRow = TRUE)
setColWidths(wb, "Data", cols = 1:ncol(mtcars), widths = "auto")
saveWorkbook(wb, file = "mtcars.xlsx", overwrite = TRUE)
```

The only thing that didn't quite work was adjusting the column width to fit the content. While there is a `setColWidths()` function where you can set the `widths` parameter to `"auto"` that didn't work a 100%. It *did* look much better than having all columns in the standard width, though. In the end that was good enough for me.
