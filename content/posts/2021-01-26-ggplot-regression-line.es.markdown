---
title: ¿Cómo Añadir una Recta de Regresión a un ggplot?
author: Thomas Neitmann
date: '2021-01-26'
slug: ggplot-recta-de-regresion
categories:
  - R
  - article
tags:
  - ggplot2
  - visualizaciondedatos
toc: no
images: ~
---

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

<!-- Linear regression is arguably the most widely used statistical model out there. It's simple and gives easily interpretable results. Since linear regression essentially fits a line to a set of points it can also be readily visualized. This post focuses on how to do that in R using the `{ggplot2}` package. -->

Se podría decir que la regresión lineal es el modelo estadístico más utilizado. Este modelo es sencillo y produce resultados que son fáciles de interpretar. Puesto que la regresión lineal esencialmente ajusta una línea recta a un conjunto de puntos, también puede ser visualizada fácilmente. Este artículo se centra en cómo hacer esto en R usando el paquete `{ggplot2}`.

<!-- Let's start off by creating a scatter plot of weight (`wt`) vs. horse power (`hp`) of cars in the infamous `mtcars` dataset. -->

Comenzamos creando un gráfico de dispersión de las variables *weight* (`wt`) vs. *horse power* (`hp`) del conjunto de datos `mtcars`.


```r
library(ggplot2)
data(mtcars)
p <- ggplot(mtcars, aes(wt, hp)) +
  geom_point()
p
```

<img src="/posts/2021-01-26-ggplot-regression-line.es_files/figure-html/ggplot2_scatter_plot-1.png" width="672" />

<!-- There's an obvious positive trend visible: the heavier a car is the higher its horse power tend to be. -->

Es obvio que hay una relación positiva visible: mientras más pesado es un coche, tiende a tener más caballos de potencia.

<!-- Next, let's add a smoother to make this trend even more apparent. -->

A continuación añadimos una línea de suavizado para que esa tendencia sea todavía más visible.


```r
p + geom_smooth()
```

<img src="/posts/2021-01-26-ggplot-regression-line.es_files/figure-html/ggplot2_scatter_plot_with_loess_smoother-1.png" width="672" />

<!-- By default, `geom_smooth()` adds a LOESS smoother to the data. That's not what we're after, though. To make `geom_smooth()` draw a linear regression line we have to set the `method` parameter to `"lm"` which is short for "linear model". -->

Por defecto, `geom_smooth()` añade un suavizado LOESS a los datos, aunque esto no es lo que queremos. Para que `geom_smooth()` dibuje una recta de regresión lineal tenemos que establecer el parámetro `method` a `"lm"`, que es la abreviatura de "modelo lineal".


```r
p + geom_smooth(method = "lm")
```

<img src="/posts/2021-01-26-ggplot-regression-line.es_files/figure-html/ggplot2_scatter_plot_with_linear_regression_line-1.png" width="672" />

<!-- The gray shading around the line represents the 95% confidence interval. You can change the confidence interval level by changing the `level` parameter. A value of `0.8` represents a 80% confidence interval. -->

El sombreado gris alrededor de la línea representa el intervalo de confianza al 95%. El nivel del intervalo de confianza se puede modificar cambiando el parámetro `level`. Un valor de 0.8 representa un intervalo de confianza del 80%.


```r
p + geom_smooth(method = "lm", level = 0.8)
```

<img src="/posts/2021-01-26-ggplot-regression-line.es_files/figure-html/ggplot2_linear_regression_line_confidence_interval-1.png" width="672" />

<!-- If you don't want to show the confidence interval band at all, set the `se` parameter to `FALSE`. -->

Para que no se muestre el intervalo de confianza se debe establecer el parámetro `se` a `FALSE`.


```r
p + geom_smooth(method = "lm", se = FALSE)
```

<img src="/posts/2021-01-26-ggplot-regression-line.es_files/figure-html/ggplot2_linear_regression_line_without_confidence_interval-1.png" width="672" />

<!-- Sometimes a line is not a good fit to the data but a polynomial would be. So, how to add a polynomial regression line to a plot? To do so, we will still have to use `geom_smooth()` with `method = "lm"` but in addition specify the `formula` parameter. By default, `formula` is set to `y ~ x` (read: `y` as a function of `x`). To draw a polynomial of degree `n` you have to change the formula to `y ~ poly(x, n)`. Here's an example fitting a 2nd degree (quadratic) polynomial regression line. -->

En algunas ocasiones una recta no se adapta correctamente a los datos pero un ajuste polinómico sí. Entonces, ¿cómo se añade una línea de regresión polinómica al gráfico? Para esto se usa igualmente `geom_smooth()` con el parámetro `method = "lm"` pero además se debe especificar el parámetro `formula`. El valor por defecto de `formula` es `y ~ x` (se lee: `y` en función de `x`). Para dibujar un polinomio de grado `n` se cambia la fórmula a `y ~ poly(x, n)`. A continuación se muestra un ejemplo de ajuste con una curva de regresión polinómica de 2º grado (ajuste cuadrático).


```r
ggplot(mtcars, aes(qsec, hp)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2))
```

<img src="/posts/2021-01-26-ggplot-regression-line.es_files/figure-html/ggplot2_polynomial_regression_line-1.png" width="672" />

<!-- Now it's your turn! Start a new R session, load some data, and create a ggplot with a linear regression line. Happy programming! -->

¡Ahora es tú turno! Inicia una nueva sesión de R, carga unos datos y crea un gráfico ggplot con su línea de regresión. ¡Feliz programación!
