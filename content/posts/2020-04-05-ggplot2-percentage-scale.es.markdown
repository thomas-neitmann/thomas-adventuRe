---
title: Transformar el Eje a Escala Porcentual en {ggplot2}
author: Thomas Neitmann
date: '2020-04-05'
slug: ggplot2-escala-porcentual
categories:
  - R
tags:
  - ggcharts
  - ggplot2
  - visualizaciondedatos
toc: no
images: ~
---




<!-- When plotting a variable whose unit of measure is percent it's best practice to have the axis labels contain the percentage sign (%). This makes it obvious to anyone looking at the data visualization that they are dealing with percentages.  -->

<!-- To illustrate this let's create an example dataset. -->

Cuando representamos gráficamente una variable cuya unidad de medida es porcentual es ideal que las etiquetas del eje contengan el símbolo de porcentaje (%). Así será evidente para cualquiera que vea el gráfico que lo que se refleja son porcentajes.

Para ilustrar esto vamos a crear un conjunto de datos de ejemplo.


```r
library(dplyr)
data(mtcars)

cyl <- mtcars %>%
  count(cyl) %>%
  mutate(pct = n / sum(n) * 100) %>%
  print()
```

```
##   cyl  n    pct
## 1   4 11 34.375
## 2   6  7 21.875
## 3   8 14 43.750
```

<!-- To create a bar chart displaying these data I will use my [`ggcharts`](https://thomas-neitmann.github.io/ggcharts/index.html) package which provides a high-level interface to produce plots using `ggplot2`. -->

Para crear una gráfico de barras de estos datos usaré mi paquete [`ggcharts`](https://thomas-neitmann.github.io/ggcharts/index.html) que ofrece una interfaz de alto nivel para producir gráficos usando `ggplot2`


```r
library(ggcharts)
(p <- bar_chart(cyl, cyl, pct))
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.es_files/figure-html/unnamed-chunk-2-1.png" width="672" />

<!-- Next, let's try to change the axis labels to include a percentage sign using the `percent()` function from the `scales` package. -->

Ahora vamos a tratar de cambiar las etiquetas del eje para que incluyan el símbolo de porcentaje usando la función `percent()`del paquete `scales`.


```r
p + scale_y_continuous(labels = scales::percent)
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.es_files/figure-html/unnamed-chunk-3-1.png" width="672" />

<!-- Something is not right here! 4000%!? That seems a bit excessive. The problem here is that by default `scales::percent()` multiplies its input value by 100. This can be controlled by the `scale` parameter. -->

¡Pero no está bien, 4000%? Parece un poco excesivo. El problema es que, por defecto, `scales::percent()` multiplica por 100 los valores de entrada. Esto se puede ajustar con el parámetro `scale`.


```r
scales::percent(100, scale = 1)
```

```
## [1] "100%"
```

<!-- However, `scale_y_continuous()` expects a function as input for its `labels` parameter not the actual labels itself. Thus, using `percent()` is not an option anymore. Fortunately, the `scales` package offers a function called `percent_format()` that returns the `percent()` function with changed defaults. -->

Sin embargo, `scale_y_continous()` espera recibir una función como entrada de su parámetro `labels`, no las propias etiquetas. Por lo tanto, usar `percent()` no es una opción válida. Afortunadamente, el paquete `scales`tiene una función llamada `percent_format()` que devuelve la función `percent()` con las opciones cambiadas.


```r
pct1 <- scales::percent_format(scale = 1)
pct1(100)
```

```
## [1] "100%"
```

<!-- Passing this function to `labels` produces the desired result. -->
Al pasar esta función a `labels` obtenemos el resultado deseado.


```r
p + scale_y_continuous(labels = scales::percent_format(scale = 1))
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.es_files/figure-html/unnamed-chunk-6-1.png" width="672" />

<!-- Alternatively, one can simply calculate a fraction instead of the actual percentage. -->

Otra opción es simplemente calcular la fracción en vez del porcentaje.


```r
cyl2 <- mtcars %>%
  count(cyl) %>%
  mutate(pct = n / sum(n))

bar_chart(cyl2, cyl, pct) +
  scale_y_continuous(labels = scales::percent)
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.es_files/figure-html/unnamed-chunk-7-1.png" width="672" />

<!-- However, notice that suddenly all labels are printed with one decimal place. I think that's undesireable given that the labels are all whole numbers. -->

Sin embargo, ahora todas las etiquetas se reflejan con un valor decimal. Creo que esto no es adecuado dado que las etiquetas son números enteros.

<!-- To change this the `percent_format()` function has a paramter called `accuracy`. -->

Para resolver esto, usamos la función `percent_format()` que tiene un parámetro llamado `accuracy`.


```r
bar_chart(cyl2, cyl, pct) +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.es_files/figure-html/unnamed-chunk-8-1.png" width="672" />

<!-- To me all of this is confusing (to say the least). That's why I decided to come up with a better solution. After all, it should be possible to determine `scale` and `accuracy` directly from the data, right? -->

<!-- My solution is the `scale_y_pct()` function which is part of my [`scalesextra`](https://github.com/thomas-neitmann/scalesextra) package. -->

Para mí todo esto es, por lo menos, confuso. Por eso decidí crear una mejor solución. Al final, debe ser posible determinar `scale` y `accuracy` directamente a partir de los datos, ¿no?.

Mi solución es la función `scale_y_pct()`que es parte de mi paquete [`scalesextra`](https://github.com/thomas-neitmann/scalesextra).


```r
library(scalesextra)
bar_chart(cyl, cyl, pct) + scale_y_pct()
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.es_files/figure-html/unnamed-chunk-9-1.png" width="672" />

```r
bar_chart(cyl2, cyl, pct) + scale_y_pct()
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.es_files/figure-html/unnamed-chunk-9-2.png" width="672" />

<!-- As you can see, regardless of whether your data is a fraction of 1 or a true percentage the data is scaled correctly. Furthermore, in both cases no decimal is displayed as all labels are integers. -->

<!-- You can pass any parameter of `scale_y_continuous()` to `scale_y_pct()`, e.g. `breaks`. -->

Como puedes ver, los datos se escalan correctamente independientemente de que sean una fracción de 1 o un porcentaje. Además, en ningún caso se muestran los decimales puesto que todas las etiquetas son enteros.

A `scale_y_pct()` se le pueden pasar cualquiera de los parámetros de `scale_y_continuous()`, p. ej. `breaks`.



```r
bar_chart(cyl, cyl, pct) + scale_y_pct(breaks = c(12.5, 30.75))
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.es_files/figure-html/unnamed-chunk-10-1.png" width="672" />

<!-- Notice that the number of decimal places displayed is consistent for all labels and automatically determined from the value with the highest number of decimal places. Again, this does not happen automatically when using `percent_format()`. -->

Nótese que el número de decimales que se muestran es consistente para todas las etiquetas y se determina automáticamente a partir del valor con el mayor número de decimales. Una vez más, esto no sucede automáticamente cuando se usa `percent_format()`.



```r
bar_chart(cyl, cyl, pct) +
  scale_y_continuous(
    labels = scales::percent_format(scale = 1),
    breaks = c(12.5, 30.75)
  )
```

<img src="/posts/2020-04-05-ggplot2-percentage-scale.es_files/figure-html/unnamed-chunk-11-1.png" width="672" />

<!-- `scalesextra` is in very early development and thus only available from GitHub. You can install it by running these commands in you `R` console. -->

`scalesextra` está en una fase muy precoz de desarrollo y por lo tanto sólo está dispobible en GitHub. Lo puedes instalar ejecutando los siguientes comandos en la consola de `R`

```r
if (!"remotes" %in% installed.packages()) {
  install.packages("remotes")
}
remotes::install_github("thomas-neitmann/scalesextra")
```

<!-- Please test `scale_y_pct()` (and its sister `scale_x_pct()`) and let me know what you think in the comments. Should you find a bug (which is likely given the early stage of development), please open an issue on [GitHub](https://github.com/thomas-neitmann/scalesextra/issues). -->

Por favor, prueba `scale_y_pct()` (y su hermana `scale_x_pct()`) y dime lo que opinas de ellas en los comentarios. Si encuentras algún error (lo que es muy probable dado que está en una fase de desarrollo temprana), por favor abre un *issue* en [GitHub](https://github.com/thomas-neitmann/scalesextra/issues).
*<small>Este artículo ha sido traducido del original en inglés por Gustavo Zapata Wainberg.</small>*
