---
title: Come si Aggiunge una Linea di Regressione ad un ggplot?
author: Thomas Neitmann
date: '2021-01-26'
slug: ggplot-retta-di-regressione
categories:
  - R
  - article
tags:
  - ggplot2
  - datavisualization
toc: no
images: ~
---

<!-- Linear regression is arguably the most widely used statistical model out there. It's simple and gives easily interpretable results. Since linear regression essentially fits a line to a set of points it can also be readily visualized. This post focuses on how to do that in R using the `{ggplot2}` package. -->

La regressione lineare è forse il modello statistico più diffuso. È semplice e restituisce risultati facilmente interpretabili. Dal momento che la regressione lineare essenzialmente interpola una retta per un insieme di punti, può anche essere rappresentata facilmente. Questo post si concentra su come farlo in R usando il pacchetto `{ggplot2}`.

<!-- Let's start off by creating a scatter plot of weight (`wt`) vs. horse power (`hp`) of cars in the infamous `mtcars` dataset. -->

Cominciamo creando uno scatter plot di peso (`wt`) su potenza motore (`hp`) di automobili nel famigerato dataset `mtcars`.


```r
library(ggplot2)
data(mtcars)
p <- ggplot(mtcars, aes(wt, hp)) +
  geom_point()
p
```

<img src="/posts/2021-01-26-ggplot-regression-line.it_files/figure-html/ggplot2_scatter_plot-1.png" width="672" />

<!-- There's an obvious positive trend visible: the heavier a car is the higher its horse power tend to be. -->

Appare evidente che ci sia una relazione positiva: più pesante è una macchina, maggiore tenderà ad essere la potenza del motore.

<!-- Next, let's add a smoother to make this trend even more apparent. -->

A questo punto, aggiungiamo uno *smoother* per rendere ancora più evidente la relazione.


```r
p + geom_smooth()
```

<img src="/posts/2021-01-26-ggplot-regression-line.it_files/figure-html/ggplot2_scatter_plot_with_loess_smoother-1.png" width="672" />

<!-- By default, `geom_smooth()` adds a LOESS smoother to the data. That's not what we're after, though. To make `geom_smooth()` draw a linear regression line we have to set the `method` parameter to `"lm"` which is short for "linear model". -->

Di defaut, `geom_smooth()` aggiunge una curva LOESS ai dati. Tuttavia non è quello che vogliamo. Per far sì che `geom_smooth()` disegni una retta di regressione lineare dobbiamo impostare il parametro `method` su `"lm"`, che è l'abbreviazione di "linear model" (modello lineare).


```r
p + geom_smooth(method = "lm")
```

<img src="/posts/2021-01-26-ggplot-regression-line.it_files/figure-html/ggplot2_scatter_plot_with_linear_regression_line-1.png" width="672" />

<!-- The gray shading around the line represents the 95% confidence interval. You can change the confidence interval level by changing the `level` parameter. A value of `0.8` represents a 80% confidence interval. -->

La parte in grigio chiaro attorno alla linea indica l'intervallo di confidenza al 95%. Puoi cambiare il livello dell'intervallo di confidenza modificando il parametro `level`. Un valore di `0.8` corrisponde a un intervallo di confidenza all'80%.


```r
p + geom_smooth(method = "lm", level = 0.8)
```

<img src="/posts/2021-01-26-ggplot-regression-line.it_files/figure-html/ggplot2_linear_regression_line_confidence_interval-1.png" width="672" />

<!--If you don't want to show the confidence interval band at all, set the `se` parameter to `FALSE`. -->

Se non vuoi inserire l'intervallo di confidenza nel grafico, imposta il parametro `se` come `FALSE`.


```r
p + geom_smooth(method = "lm", se = FALSE)
```

<img src="/posts/2021-01-26-ggplot-regression-line.it_files/figure-html/ggplot2_linear_regression_line_without_confidence_interval-1.png" width="672" />

<!-- Sometimes a line is not a good fit to the data but a polynomial would be. So, how to add a polynomial regression line to a plot? To do so, we will still have to use `geom_smooth()` with `method = "lm"` but in addition specify the `formula` parameter. By default, `formula` is set to `y ~ x` (read: `y` as a function of `x`). To draw a polynomial of degree `n` you have to change the formula to `y ~ poly(x, n)`. Here's an example fitting a 2nd degree (quadratic) polynomial regression line. -->

Qualche volta una retta potrebbe non essere la soluzione più adatta per i dati, mentre potrebbe esserlo una polinomiale. Come possiamo aggiungere una linea di regressione polinomiale ad un grafico? Per farlo dobbiamo comunque usare `geom_smooth()` con `method = "lm"` ma in aggiunta dobbiamo specificare il parametro `formula`. Di default, `formula` è impostato su `y ~ x` (si legge `y` in funzione di `x`). Per tracciare una polinomiale di grado `n` bisogna cambiare la formula in `y ~ poly(x, n)`. Ecco un esempio che utilizza una curva di regressione polinomiale di secondo grado (quadratica).


```r
ggplot(mtcars, aes(qsec, hp)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2))
```

<img src="/posts/2021-01-26-ggplot-regression-line.it_files/figure-html/ggplot2_polynomial_regression_line-1.png" width="672" />

<!-- Now it's your turn! Start a new R session, load some data, and create a ggplot with a linear regression line. Happy programming! -->

Ora è il tuo turno! Apri una nuova sessione in R, carica dei dati e crea un ggplot con una retta di regressione lineare. Buona programmazione!

*<small>Questo post è stato tradotto dall'inglese da [Stefano Anzani](https://github.com/stefanoanzani).</small>*
